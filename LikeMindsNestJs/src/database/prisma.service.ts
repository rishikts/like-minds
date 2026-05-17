import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private logger = new Logger('PrismaService');

  async onModuleInit() {
    await this.$connect();
    this.logger.log('Database connected successfully');
  }

  async onModuleDestroy() {
    await this.$disconnect();
    this.logger.log('Database disconnected');
  }

  /**
   * Utility method to handle transaction queries
   */
  async executeWithinTransaction<T>(callback: (prisma: PrismaService) => Promise<T>): Promise<T> {
    return this.$transaction(async tx => {
      return callback(tx as PrismaService);
    });
  }
}
