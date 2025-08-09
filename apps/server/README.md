# BookLab Express Server

A modern, high-performance Express.js server built with TypeScript for the BookLab application. Features comprehensive book management, user authentication, Redis caching, and PostgreSQL integration.

## 🚀 Features

- **Modern Architecture**: TypeScript, Express.js 5, feature-based organization
- **Authentication System**: JWT-based auth with refresh tokens and secure sessions
- **Book Management**: Comprehensive book search, categorization, and management
- **High Performance**: Redis caching with intelligent cache invalidation
- **Database Integration**: PostgreSQL with optimized queries and migrations
- **Security First**: Helmet, CORS, rate limiting, input validation, and secure password hashing
- **Developer Experience**: Hot reload, comprehensive testing, Docker support
- **Production Ready**: Health checks, monitoring, structured logging

## 📋 Prerequisites

- **Node.js** 18+ or **Bun** 1.0+
- **PostgreSQL** 14+
- **Redis** 6+
- **Docker & Docker Compose** (optional, for containerized development)

## ⚡ Quick Start

### 1. Install Dependencies

```bash
# Using pnpm (recommended)
pnpm install

# Or using npm
npm install

# Or using bun
bun install
```

### 2. Environment Setup

```bash
# Copy environment template
cp .env.example .env

# Edit the .env file with your configuration
```

Required environment variables:
```env
# Server
PORT=5000
NODE_ENV=development
CORS_ORIGIN=http://localhost:3000

# Database
DATABASE_URL=postgresql://username:password@localhost:5432/booklab

# Redis
REDIS_URL=redis://localhost:6379

# Authentication
SESSION_SECRET=your-super-secret-session-key-at-least-32-chars
JWT_ACCESS_SECRET=your-jwt-access-secret
JWT_REFRESH_SECRET=your-jwt-refresh-secret
```

### 3. Database Setup

```bash
# Run database migrations
pnpm run migrate

# Seed with sample data (optional)
pnpm run seed
```

### 4. Start Development Server

```bash
pnpm run dev
```

The server will start at `http://localhost:5000` with hot reloading enabled.

## 📚 API Documentation

For complete API documentation, see [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)

### Quick API Overview

- **Base URL**: `http://localhost:5000/api`
- **Authentication**: JWT Bearer tokens
- **Format**: JSON requests and responses

#### Key Endpoints

```bash
# Health Check
GET /api/health

# Authentication
POST /api/auth/signup      # Create account
POST /api/auth/login       # Login
GET  /api/auth/me          # Get user info
GET  /api/auth/logout      # Logout

# Books
GET  /api/books                    # List all books
GET  /api/books/:id                # Get book by ID
GET  /api/books/search?q=query     # Search books by title
GET  /api/books/search/author?q=   # Search by author
GET  /api/books/new-releases       # Get new releases
```

### Test User Credentials

For testing purposes, you can use these credentials:

```json
{
  "email": "testuser@example.com",
  "username": "testuser",
  "password": "TestPassword10!"
}
```

## 🛠 Development Scripts

```bash
# Development
pnpm run dev          # Start dev server with hot reload
pnpm run build        # Build TypeScript to JavaScript
pnpm run start        # Start production server

# Testing
pnpm run test         # Run test suite
pnpm run test:watch   # Run tests in watch mode
pnpm run check-types  # TypeScript type checking

# Database
pnpm run migrate      # Run database migrations
pnpm run seed         # Seed database with sample data

# Health & Monitoring
pnpm run health       # Check API health (formatted JSON)
pnpm run health:quick # Quick health check

# Code Quality
pnpm run lint         # Run ESLint
```

## 🏗 Project Structure

```
apps/server/
├── src/
│   ├── features/           # Feature modules
│   │   ├── auth/          # Authentication system
│   │   │   ├── controllers/
│   │   │   ├── middlewares/
│   │   │   ├── routes/
│   │   │   └── validation/
│   │   └── book/          # Book management
│   │       ├── controller/
│   │       ├── middleware/
│   │       ├── routes/
│   │       └── validation/
│   ├── utils/             # Shared utilities
│   └── server.ts          # Main server entry point
├── dist/                  # Compiled JavaScript
├── Dockerfile            # Docker configuration
├── package.json
└── tsconfig.json
```

## 🐳 Docker Development

### Using Docker Compose (Recommended)

```bash
# Start all services (server, PostgreSQL, Redis)
docker-compose -f docker-compose.dev.yml up

# Stop all services
docker-compose -f docker-compose.dev.yml down

# Rebuild and start
docker-compose -f docker-compose.dev.yml up --build
```

### Manual Docker Build

```bash
# Build the image
docker build -t booklab-server .

# Run the container
docker run -p 5000:4000 \
  -e DATABASE_URL=postgresql://... \
  -e REDIS_URL=redis://... \
  booklab-server
```

## 🧪 Testing

The project includes comprehensive tests using Vitest:

```bash
# Run all tests
pnpm run test

# Run tests with coverage
pnpm run test --coverage

# Run specific test file
pnpm run test auth/controllers/signupController.test.ts

# Run tests in watch mode
pnpm run test:watch
```

### Test Structure

```
src/
├── features/
│   └── auth/
│       └── controllers/
│           └── __test__/
│               └── signupController.test.ts
```

## 📊 Monitoring & Health Checks

### Health Check Endpoints

```bash
# Comprehensive health check
curl http://localhost:5000/api/health | jq

# Quick health check (for load balancers)
curl http://localhost:5000/api/health/quick

# Service-specific checks
curl http://localhost:5000/api/health/postgres
curl http://localhost:5000/api/health/redis
```

### Using the Health Scripts

```bash
# Pretty-printed health status
pnpm run health

# Quick health check
pnpm run health:quick
```

## 🔒 Security Features

- **Helmet**: Security headers and XSS protection
- **CORS**: Configurable cross-origin resource sharing
- **Rate Limiting**: Protection against brute force attacks
- **Input Validation**: Zod schema validation for all inputs
- **Password Security**: bcrypt hashing with salt rounds
- **JWT Security**: Secure token generation and validation
- **Session Security**: HTTP-only cookies with secure flags
- **SQL Injection Protection**: Parameterized queries

## 🚀 Production Deployment

### Environment Variables

Ensure these are set in production:

```env
NODE_ENV=production
PORT=5000
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
SESSION_SECRET=secure-32-char-secret
JWT_ACCESS_SECRET=secure-secret
JWT_REFRESH_SECRET=secure-secret
CORS_ORIGIN=https://yourdomain.com
```

### Production Checklist

- [ ] Set `NODE_ENV=production`
- [ ] Configure secure database connection
- [ ] Set up Redis instance
- [ ] Configure HTTPS/SSL
- [ ] Set secure session secrets
- [ ] Configure CORS for production domains
- [ ] Set up monitoring and logging
- [ ] Configure health check endpoints for load balancer
- [ ] Set up database backups
- [ ] Configure rate limiting for production load

### Docker Production

```dockerfile
# Use multi-stage build for production
FROM node:18-alpine AS builder
# ... build steps

FROM node:18-alpine AS production
# ... production configuration
```

## 🔧 Configuration

### Environment Variables Reference

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `PORT` | Server port | `5000` | No |
| `NODE_ENV` | Environment | `development` | No |
| `CORS_ORIGIN` | Allowed origins | - | Yes |
| `DATABASE_URL` | PostgreSQL URL | - | Yes |
| `REDIS_URL` | Redis URL | - | Yes |
| `SESSION_SECRET` | Session secret | - | Yes |
| `JWT_ACCESS_SECRET` | JWT access secret | - | Yes |
| `JWT_REFRESH_SECRET` | JWT refresh secret | - | Yes |
| `JWT_ACCESS_EXPIRES_IN` | Access token expiry | `15m` | No |
| `JWT_REFRESH_EXPIRES_IN` | Refresh token expiry | `7d` | No |

### Database Configuration

The server uses PostgreSQL with connection pooling and migration support. See the `@repo/db` package for database utilities and migrations.

### Redis Configuration

Redis is used for:
- Session storage
- API response caching
- Rate limiting storage

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Run tests: `pnpm run test`
5. Run linting: `pnpm run lint`
6. Commit changes: `git commit -m 'Add amazing feature'`
7. Push to branch: `git push origin feature/amazing-feature`
8. Open a Pull Request

### Development Guidelines

- Follow TypeScript best practices
- Write tests for new features
- Update documentation for API changes
- Use conventional commit messages
- Ensure all tests pass before submitting PR

## 📝 Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history and changes.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.

## 🆘 Support & Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Kill process using port 5000
lsof -ti:5000 | xargs kill -9
```

**Database connection issues:**
```bash
# Check PostgreSQL status
pg_isready -h localhost -p 5432

# Test database connection
psql $DATABASE_URL
```

**Redis connection issues:**
```bash
# Test Redis connection
redis-cli ping
```

### Getting Help

- Check the [API Documentation](./API_DOCUMENTATION.md)
- Review the [troubleshooting guide](./docs/troubleshooting.md)
- Open an issue on GitHub
- Check existing issues and discussions

---