# Like Minds Backend

Production-grade scalable backend for a Gen Z social networking and meetup platform.

## 🏗️ Architecture Overview

**Tech Stack:**
- **Framework:** NestJS with TypeScript
- **Database:** PostgreSQL with Prisma ORM
- **Auth:** Supabase Auth (JWT)
- **Storage:** Supabase Storage
- **Deployment:** Railway (initial), AWS (later)

**Architecture Pattern:**
- Modular monolith
- Clean architecture (Controller → Service → Repository → Prisma)
- Scalable feature modules
- DTO validation on all endpoints
- Role-based access control

## 📁 Project Structure

```
src/
├── modules/                      # Feature modules
│   ├── auth/                     # Authentication
│   ├── users/                    # User management
│   ├── interests/                # Interest management
│   ├── communities/              # Community management
│   ├── meetups/                  # Meetup management
│   └── notifications/            # Notifications
│
├── common/                       # Shared utilities
│   ├── guards/                   # JWT auth guard
│   ├── interceptors/             # Response interceptor
│   ├── decorators/               # Custom decorators
│   ├── filters/                  # Exception filters
│   └── pipes/                    # Validation pipes
│
├── database/                     # Database setup
│   ├── prisma.module.ts
│   └── prisma.service.ts
│
├── config/                       # Configuration
├── main.ts                       # Application entry point
└── app.module.ts                 # Root module

prisma/
├── schema.prisma                 # Database schema
└── seed.ts                       # Database seeding
```

## 🗄️ Database Schema

**Core Entities:**
- **Users** - User accounts with profiles
- **Interests** - Interest categories and tags
- **UserInterests** - Many-to-many relationship
- **Communities** - User communities by interest
- **CommunityMembers** - Community membership with roles
- **Meetups** - Scheduled community meetups
- **MeetupRSVP** - User RSVP status for meetups
- **Notifications** - In-app notifications
- **UserFollow** - Follow relationships between users

**Key Features:**
- UUIDs for all primary keys
- Soft delete support (status fields)
- Proper indexing for scalability
- Cascading deletes for relational integrity
- Timestamps on all entities

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- PostgreSQL 14+
- npm or yarn

### 1. Install Dependencies
```bash
npm install
```

### 2. Setup Environment
```bash
cp .env.example .env
# Edit .env with your configuration
```

### 3. Database Setup
```bash
# Generate Prisma client
npm run db:generate

# Create and run migrations
npm run db:migrate:create

# Seed initial data
npm run db:seed
```

### 4. Development Server
```bash
npm run start:dev
```

Server runs at `http://localhost:3000`

## 📚 API Documentation

### Base URL
```
http://localhost:3000/api/v1
```

### Health Check
```
GET /health
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "status": "ok",
    "message": "Like Minds Backend is running",
    "timestamp": "2026-05-17T10:00:00.000Z"
  }
}
```

## 🔐 Authentication

All protected endpoints require JWT token in Authorization header:

```
Authorization: Bearer <token>
```

Token is obtained from Supabase Auth after user login.

## 🛠️ Available Scripts

```bash
# Development
npm run start:dev        # Watch mode with auto-reload
npm run start:debug      # Debug mode
npm run start            # Production mode

# Database
npm run db:generate      # Generate Prisma client
npm run db:migrate:create # Create and run migrations
npm run db:migrate:prod  # Run migrations in production
npm run db:studio        # Open Prisma Studio
npm run db:seed          # Run seed script

# Code Quality
npm run lint             # Run ESLint
npm run format           # Format code with Prettier
npm run test             # Run tests
npm run test:watch       # Watch mode for tests
npm run test:cov         # Generate coverage report
```

## 📝 Environment Variables

See `.env.example` for all available options:

- `DATABASE_URL` - PostgreSQL connection string
- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Environment (development/production)
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_JWT_SECRET` - JWT secret for token verification
- `JWT_SECRET` - Application JWT secret
- `JWT_EXPIRATION` - Token expiration time
- `CORS_ORIGIN` - Allowed CORS origins

## 🔄 Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/module-name
   ```

2. **Develop Feature**
   - Add/update DTOs
   - Implement Service logic
   - Create Repository if needed
   - Add Controller endpoints
   - Write tests

3. **Database Changes**
   ```bash
   # Create migration
   npm run db:migrate:create
   # Test migration
   npm run db:migrate:deploy
   ```

4. **Code Quality**
   ```bash
   npm run lint
   npm run format
   npm run test
   ```

5. **Submit PR**
   - Ensure all tests pass
   - Lint and format code
   - Update documentation

## 🧪 Testing

```bash
# Run all tests
npm run test

# Watch mode
npm run test:watch

# Coverage report
npm run test:cov
```

## 📦 Deployment

### Railway (Initial)
1. Connect GitHub repo
2. Add environment variables in Railway dashboard
3. Set build command: `npm run build`
4. Set start command: `npm run start:prod`

### AWS (Future)
- Deploy to ECS/Lambda
- Use RDS for PostgreSQL
- Use S3 for file storage

## 🐛 Debugging

### VS Code Debug Config
```json
{
  "type": "node",
  "request": "attach",
  "name": "Attach",
  "skipFiles": ["<node_internals>/**"],
  "port": 9229
}
```

Start with:
```bash
npm run start:debug
```

### Prisma Studio
```bash
npm run db:studio
```

Opens visual database browser at `http://localhost:5555`

## 📚 Module Development Guide

Each module follows this structure:

```
module/
├── dto/
│   ├── create-*.dto.ts
│   └── update-*.dto.ts
├── entities/
│   └── *.entity.ts
├── repositories/
│   └── *.repository.ts
├── services/
│   └── *.service.ts
├── controllers/
│   └── *.controller.ts
└── *.module.ts
```

### Creating New Module
1. Create module directory
2. Generate DTOs with validation
3. Implement repository layer
4. Implement service layer
5. Implement controller
6. Update module imports

## 🤝 Code Standards

- Use TypeScript strict mode
- Follow NestJS best practices
- Validate all inputs with class-validator
- Use async/await
- Implement proper error handling
- Add JSDoc comments for public APIs
- Keep services focused (single responsibility)
- Use dependency injection

## 📖 Resources

- [NestJS Documentation](https://docs.nestjs.com)
- [Prisma Documentation](https://www.prisma.io/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [TypeScript Best Practices](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)

## 📞 Support

For issues or questions:
1. Check existing documentation
2. Review module examples
3. Check error logs
4. Open an issue

## 📄 License

UNLICENSED - Private project
