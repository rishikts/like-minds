import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { ResponseInterceptor } from './common/interceptors/response.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  // Configuration
  const port = configService.get<number>('PORT', 3000);
  const nodeEnv = configService.get<string>('NODE_ENV', 'development');
  const corsOrigin = configService.get<string>('CORS_ORIGIN', 'http://localhost:3000');

  app.enableCors({
    origin: corsOrigin.split(',').map((o) => o.trim()),
    credentials: true,
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Global exception filter
  app.useGlobalFilters(new AllExceptionsFilter());

  // Global response interceptor
  app.useGlobalInterceptors(new ResponseInterceptor());

  // API versioning
  app.setGlobalPrefix('api/v1');

  // Start server
  await app.listen(port, () => {
    console.log(`
    ╔════════════════════════════════════════╗
    ║  🎉 Like Minds Backend Server Ready   ║
    ╠════════════════════════════════════════╣
    ║  🌐 Server:    http://localhost:${port}         ║
    ║  🔧 Env:       ${nodeEnv.padEnd(28)}║
    ║  📚 Docs:      /api/v1                ║
    ╚════════════════════════════════════════╝
    `);
  });
}

bootstrap();
