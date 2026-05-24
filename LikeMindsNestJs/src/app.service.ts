import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  health() {
    return {
      status: 'ok',
      message: 'Like Minds Backend is running',
      timestamp: new Date().toISOString(),
    };
  }
}
