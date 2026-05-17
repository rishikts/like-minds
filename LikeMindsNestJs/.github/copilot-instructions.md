<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Like Minds Backend - Project Setup Checklist

## Overview
Like Minds is a Gen Z social networking and meetup platform built with NestJS, TypeScript, PostgreSQL, and Prisma ORM. This document tracks the project bootstrap and ongoing development guidelines.

## Project Setup Progress

- [x] **Clarify Project Requirements**
  - Gen Z social networking and meetup platform
  - NestJS + TypeScript backend
  - PostgreSQL + Prisma ORM
  - Supabase Auth + Storage
  - Modular monolith architecture
  - REST APIs with DTOs and validation

- [x] **Scaffold the Project**
  - Created folder structure for modular architecture
  - Generated `package.json` with all dependencies
  - Set up TypeScript configuration
  - Created NestJS CLI config
  - Initialized Prisma schema with PostgreSQL
  - Created feature module stubs (auth, users, interests, communities, meetups, notifications)

- [x] **Customize the Project**
  - Prisma schema with all core entities (Users, Interests, Communities, Meetups, RSVP, Notifications, UserFollow)
  - Database seeding script for initial data
  - PrismaService for database connections
  - JWT authentication guard for protected routes
  - Global response interceptor for consistent API responses
  - Global exception filter for error handling
  - Custom decorators (@CurrentUser, @Roles)
  - Common filters, guards, and interceptors

- [x] **Create Configuration Files**
  - Environment configuration (.env.example)
  - ESLint configuration
  - Prettier configuration
  - .gitignore
  - nest-cli.json

## Architecture Guidelines

### Controller → Service → Repository → Prisma (Strict)
Every request must follow this flow:
1. Controller receives request
2. Validates DTOs
3. Calls Service
4. Service calls Repository
5. Repository calls Prisma
6. Returns data through the chain

**Forbidden:**
- Controllers accessing Prisma directly
- Services calling other Services (use repositories)
- Circular dependencies

### Module Structure
Each feature module must have:
```
module/
├── dto/                          # Data Transfer Objects
│   ├── create-*.dto.ts
│   ├── update-*.dto.ts
│   └── query-*.dto.ts
├── entities/                     # Optional: TypeORM/Prisma entity representations
├── repositories/                 # Data access layer
│   └── *.repository.ts
├── services/                     # Business logic
│   └── *.service.ts
├── controllers/                  # HTTP endpoints
│   └── *.controller.ts
├── guards/                       # Optional: module-specific guards
├── interceptors/                 # Optional: module-specific interceptors
└── *.module.ts                   # Module definition
```

### Database Best Practices
- Use UUIDs for all primary keys
- Always include `createdAt` and `updatedAt` timestamps
- Use `status` field instead of soft deletes (ACTIVE, INACTIVE, BANNED)
- Implement proper indexing on frequently queried fields
- Use cascading deletes for relational integrity
- Use transactions for operations spanning multiple models

### API Response Format
All endpoints return this format:
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": { /* actual response */ },
  "timestamp": "2026-05-17T10:00:00.000Z",
  "path": "/api/v1/endpoint"
}
```

### Error Handling
Use NestJS built-in exceptions:
```typescript
throw new BadRequestException('Invalid input');
throw new UnauthorizedException('Token expired');
throw new ForbiddenException('Access denied');
throw new NotFoundException('Resource not found');
throw new ConflictException('Resource already exists');
throw new InternalServerErrorException('Server error');
```

### Validation
- Use `class-validator` for DTO validation
- Apply `@IsString()`, `@IsEmail()`, etc. decorators
- Use custom validators for complex logic
- Enable `whitelist: true` in ValidationPipe to reject unknown properties
- Enable `forbidNonWhitelisted: true` to throw error on unknown properties

### Authentication & Authorization
- All protected routes use `@UseGuards(JwtAuthGuard)` 
- Extract user with `@CurrentUser()` decorator
- Use `@Roles()` decorator for role-based access
- Implement RoleGuard for role validation

### TypeScript Standards
- Strict mode enabled
- No `any` types allowed (use `unknown` or generics)
- Interface over type for object definitions
- Use enums from Prisma schema when possible
- Proper error typing

## Next Steps for Implementation

1. **Auth Module** (Priority 1)
   - Supabase JWT verification strategy
   - User registration/creation endpoint
   - Login endpoint
   - Profile endpoints
   - Role-based access control

2. **Users Module** (Priority 1)
   - User profile CRUD operations
   - User follow/unfollow system
   - User onboarding flow
   - User blocking system

3. **Interests Module** (Priority 2)
   - List all interests
   - User interest assignment
   - Interest search

4. **Communities Module** (Priority 2)
   - Create community
   - Join/leave community
   - Community management (edit, delete)
   - Community members list
   - Community discovery/search

5. **Meetups Module** (Priority 2)
   - Create meetup
   - RSVP system
   - Update/cancel meetup
   - Meetup discovery by community/location
   - Upcoming meetups feed

6. **Notifications Module** (Priority 3)
   - Send notifications (service)
   - Get notifications endpoint
   - Mark as read
   - WebSocket integration (future)

7. **Testing** (Priority 3)
   - Unit tests for services
   - Integration tests for endpoints
   - E2E tests for critical flows

8. **Performance & Scaling** (Priority 4)
   - Redis caching for frequently accessed data
   - Database query optimization
   - Pagination on list endpoints
   - Rate limiting
   - Monitoring and logging

## Development Commands

```bash
# Install dependencies
npm install

# Development with watch mode
npm run start:dev

# Database migrations
npm run db:migrate:create

# Seed initial data
npm run db:seed

# Code quality
npm run lint
npm run format
npm run test
```

## Important Notes

- Never use `@nestjs/typeorm` - stick with Prisma
- No microservices (monolith only)
- No Kubernetes orchestration
- Frontend apps communicate ONLY through this backend
- All file uploads go through Supabase Storage (not database)
- Keep services focused and avoid god classes (under 300 lines per service)
- Use pagination on list endpoints for scalability
- Implement rate limiting for public endpoints

## File Locations Reference

- **Main Entry:** `/src/main.ts`
- **Root Module:** `/src/app.module.ts`
- **Database Config:** `/src/database/prisma.service.ts`
- **Auth Guard:** `/src/common/guards/jwt-auth.guard.ts`
- **Decorators:** `/src/common/decorators/`
- **Prisma Schema:** `/prisma/schema.prisma`
- **Environment Vars:** `.env` (see `.env.example` for reference)

## Copilot Instructions

When helping with this project:
1. Always follow the Controller → Service → Repository → Prisma pattern
2. Generate production-grade code, not placeholders
3. Keep modules focused and single-responsibility
4. Use proper error handling with NestJS exceptions
5. Validate all inputs with DTOs
6. Add JSDoc comments for public APIs
7. Use async/await consistently
8. Optimize for maintainability over brevity
9. Consider scalability in database queries
10. Keep responses consistent with the global response format

