import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Request } from 'express';

/**
 * Protects profile sync from the iOS app before Supabase Auth JWT is wired.
 * Send header: X-LikeMinds-Sync-Key: <SYNC_API_KEY from .env>
 */
@Injectable()
export class SyncApiKeyGuard implements CanActivate {
  constructor(private readonly configService: ConfigService) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request>();
    const configured = this.configService.get<string>('SYNC_API_KEY');

    if (!configured) {
      throw new UnauthorizedException('SYNC_API_KEY is not configured on the server');
    }

    const provided = request.header('x-likeminds-sync-key');
    if (!provided || provided !== configured) {
      throw new UnauthorizedException('Invalid sync API key');
    }

    return true;
  }
}
