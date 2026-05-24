# Like Minds Backend - Setup Instructions

## Prerequisites

### System Requirements
- **Node.js:** 18+ (with npm 9+)
- **PostgreSQL:** 14+
- **Git:** for version control

### Install Node.js

**macOS:**
```bash
# Using Homebrew
brew install node

# Verify installation
node --version  # Should be v18.0.0 or higher
npm --version   # Should be 9.0.0 or higher
```

**Windows:**
Download from [nodejs.org](https://nodejs.org) and run the installer.

**Linux (Ubuntu/Debian):**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Setup PostgreSQL

**macOS:**
```bash
# Using Homebrew
brew install postgresql@14
brew services start postgresql@14

# Create database
createdb like_minds
```

**Docker (Recommended):**
```bash
docker run --name postgres-like-minds \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=like_minds \
  -p 5432:5432 \
  -d postgres:14
```

## Getting Started

### 1. Install Dependencies
```bash
cd LikeMindsNestJs
npm install
```

### 2. Setup Environment Variables
```bash
# Copy example file
cp .env.example .env

# Edit .env with your configuration
nano .env  # or use your preferred editor
```

**Required environment variables:**
```
DATABASE_URL=postgresql://user:password@localhost:5432/like_minds?schema=public
SUPABASE_JWT_SECRET=your_secret_key
JWT_SECRET=your_jwt_secret
```

### 3. Initialize Database
```bash
# Generate Prisma client
npm run db:generate

# Run migrations
npm run db:migrate:create

# Seed initial data
npm run db:seed
```

### 4. Start Development Server
```bash
npm run start:dev
```

Server will be available at: `http://localhost:3000`

Health check endpoint: `http://localhost:3000/api/v1/health`

## Project Layout

```
like-minds-nestjs/
├── src/
│   ├── modules/              # Feature modules
│   ├── common/               # Shared utilities
│   ├── database/             # Database setup
│   ├── config/               # Configuration
│   ├── main.ts               # Entry point
│   └── app.module.ts         # Root module
├── prisma/
│   ├── schema.prisma         # Database schema
│   └── seed.ts               # Initial data
├── test/                     # Test files
├── .env                      # Environment (git ignored)
├── .env.example              # Environment template
├── package.json              # Dependencies
└── tsconfig.json             # TypeScript config
```

## Development Workflow

### Code Quality

```bash
# Lint code
npm run lint

# Format code
npm run format

# Run tests
npm run test
npm run test:watch
npm run test:cov
```

### Database Management

```bash
# Open Prisma Studio (visual DB browser)
npm run db:studio

# Create new migration
npm run db:migrate:create

# Deploy migrations (production)
npm run db:migrate:prod

# Seed database
npm run db:seed
```

### Debugging

**VS Code:**
1. Add to `.vscode/launch.json`:
```json
{
  "type": "node",
  "request": "attach",
  "name": "Attach",
  "skipFiles": ["<node_internals>/**"],
  "port": 9229
}
```

2. Start debug server:
```bash
npm run start:debug
```

3. Attach debugger in VS Code (F5)

## Common Tasks

### Create New Module

```bash
# Generate module scaffold
nest g module modules/new-module
nest g controller modules/new-module
nest g service modules/new-module
```

### Create Database Migration

```bash
npm run db:migrate:create
# Follow prompts for migration name
```

### Run Tests

```bash
# All tests
npm run test

# Watch mode
npm run test:watch

# Coverage report
npm run test:cov
```

### Production Build

```bash
# Build
npm run build

# Start production server
npm run start:prod
```

## Troubleshooting

### "Cannot find module 'prisma'"
```bash
npm run db:generate
```

### "Database connection failed"
- Check DATABASE_URL in .env
- Verify PostgreSQL is running
- Check connection string syntax

### "Port 3000 already in use"
```bash
# Use different port
PORT=3001 npm run start:dev
```

### TypeScript compilation errors
```bash
# Clear cache and reinstall
rm -rf node_modules
rm package-lock.json
npm install
```

## Next Steps

1. ✅ Project bootstrap completed
2. 📖 Read README.md for architecture details
3. 🔐 Implement Auth Module
4. 👥 Build Users Module
5. 🎮 Add Interest Management
6. 🏘️ Create Communities Module
7. 📅 Implement Meetups System
8. 🔔 Add Notifications

## Resources

- [NestJS Docs](https://docs.nestjs.com)
- [Prisma Docs](https://www.prisma.io/docs)
- [PostgreSQL Docs](https://www.postgresql.org/docs)
- [Supabase Auth](https://supabase.com/docs/guides/auth)

## Support

For issues:
1. Check logs: `npm run start:dev`
2. Review .env configuration
3. Verify database connection
4. Check Prisma schema

---

**Happy coding! 🚀**
