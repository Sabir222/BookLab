# BookLab Express Server API Documentation

## Overview

BookLab is a modern Express.js server built with TypeScript that provides a comprehensive book management and user authentication system. The server features Redis caching, PostgreSQL database integration, and a robust authentication system with JWT tokens.

## Table of Contents

- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Environment Variables](#environment-variables)
- [API Endpoints](#api-endpoints)
- [Authentication](#authentication)
- [Error Handling](#error-handling)
- [Caching](#caching)
- [Database Schema](#database-schema)
- [Development](#development)
- [Docker Deployment](#docker-deployment)

## Quick Start

### Prerequisites

- Node.js 18+ or Bun
- PostgreSQL 14+
- Redis 6+
- Docker & Docker Compose (optional)

### Installation

```bash
# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env

# Run database migrations
pnpm run migrate

# Start development server
pnpm run dev
```

The server will start on `http://localhost:5000` (or the port specified in your environment).

## Architecture

The server follows a modular architecture with feature-based organization:

```
src/
├── features/           # Feature modules
│   ├── auth/          # Authentication system
│   │   ├── controllers/
│   │   ├── middlewares/
│   │   ├── routes/
│   │   └── validation/
│   └── book/          # Book management
│       ├── controller/
│       ├── middleware/
│       ├── routes/
│       └── validation/
├── utils/             # Shared utilities
└── server.ts          # Main server entry point
```

### Key Technologies

- **Express.js 5**: Web framework
- **TypeScript**: Type safety
- **PostgreSQL**: Primary database
- **Redis**: Caching layer
- **JWT**: Authentication tokens
- **Zod**: Schema validation
- **Helmet**: Security middleware
- **bcrypt**: Password hashing

## Environment Variables

Create a `.env` file in the server root with the following variables:

```env
# Server Configuration
PORT=5000
NODE_ENV=development
CORS_ORIGIN=http://localhost:3000,http://localhost:3001

# Database
DATABASE_URL=postgresql://username:password@localhost:5432/booklab
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=booklab
POSTGRES_USER=username
POSTGRES_PASSWORD=password

# Redis
REDIS_URL=redis://localhost:6379
REDIS_HOST=localhost
REDIS_PORT=6379

# Authentication
SESSION_SECRET=your-super-secret-session-key-at-least-32-chars
JWT_ACCESS_SECRET=your-jwt-access-secret
JWT_REFRESH_SECRET=your-jwt-refresh-secret
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
```

## API Endpoints

### Base URL
```
http://localhost:5000/api
```

### Health Check Endpoints

#### GET /api/health
Get comprehensive system health status.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 3600,
  "services": {
    "postgres": {
      "status": "healthy",
      "responseTime": 5
    },
    "redis": {
      "status": "healthy",
      "responseTime": 2
    }
  },
  "overall": {
    "status": "healthy",
    "message": "All services operational"
  }
}
```

#### GET /api/health/quick
Quick health check for load balancers.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "services": {
    "postgres": true,
    "redis": true
  }
}
```

#### GET /api/health/postgres
PostgreSQL-specific health check.

#### GET /api/health/redis
Redis-specific health check.

### Authentication Endpoints

#### POST /api/auth/signup
Create a new user account.

**Request Body:**
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "SecurePass123!"
}
```

**Validation Rules:**
- `username`: minimum 3 characters
- `email`: valid email format
- `password`: minimum 8 characters, must contain at least one number, one uppercase letter, and one symbol

**Success Response (201):**
```json
{
  "message": "User created successfully",
  "user": {
    "id": "user-uuid",
    "username": "johndoe",
    "email": "john@example.com"
  },
  "accessToken": "jwt-token"
}
```

**Error Responses:**
- `400`: Missing or invalid fields
- `409`: Email or username already exists

#### POST /api/auth/login
Authenticate an existing user.

**Request Body:**
```json
{
  "username": "johndoe",
  "password": "SecurePass123!"
}
```

**Success Response (200):**
```json
{
  "message": "Logged in successfully",
  "user": {
    "id": "user-uuid",
    "username": "johndoe",
    "email": "john@example.com"
  },
  "accessToken": "jwt-token"
}
```

**Error Responses:**
- `400`: Missing fields or user not found
- `401`: Invalid password

#### GET /api/auth/me
Get current user information (requires authentication).

**Headers:**
```
Authorization: Bearer <access-token>
```

**Success Response (200):**
```json
{
  "user": {
    "id": "user-uuid",
    "username": "johndoe",
    "email": "john@example.com"
  }
}
```

#### GET /api/auth/logout
Logout current user (clears cookies).

**Success Response (200):**
```json
{
  "message": "Logged out successfully"
}
```

#### GET /api/auth/refresh
Refresh access token using refresh token.

**Success Response (200):**
```json
{
  "accessToken": "new-jwt-token"
}
```

### Book Endpoints

#### GET /api/books
Get all books with optional limit.

**Query Parameters:**
- `limit` (optional): Number of books to return (1-100, default: 50)

**Example:**
```
GET /api/books?limit=20
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "books": [
      {
        "book_id": "book-uuid",
        "title": "The Great Gatsby",
        "isbn": "978-0-7432-7356-5",
        "publication_date": "1925-04-10",
        "description": "A classic American novel...",
        "page_count": 180,
        "language": "English",
        "cover_image_url": "https://example.com/cover.jpg",
        "authors": ["F. Scott Fitzgerald"],
        "categories": ["Fiction", "Classic Literature"],
        "genres": ["Literary Fiction"],
        "publisher": "Charles Scribner's Sons"
      }
    ]
  },
  "meta": {
    "cached": false
  }
}
```

#### GET /api/books/:id
Get a specific book by ID.

**Parameters:**
- `id`: Book UUID

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "book": {
      "book_id": "book-uuid",
      "title": "The Great Gatsby",
      // ... full book details
    }
  }
}
```

**Error Responses:**
- `400`: Missing book ID
- `404`: Book not found

#### GET /api/books/search
Search books by title.

**Query Parameters:**
- `q` (required): Search query

**Example:**
```
GET /api/books/search?q=gatsby
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "books": [
      // Array of matching books
    ]
  },
  "meta": {
    "cached": false
  }
}
```

#### GET /api/books/search/author
Search books by author name.

**Query Parameters:**
- `q` (required): Author name

**Example:**
```
GET /api/books/search/author?q=fitzgerald
```

#### GET /api/books/search/category
Search books by category.

**Query Parameters:**
- `q` (required): Category name

**Example:**
```
GET /api/books/search/category?q=fiction
```

#### GET /api/books/search/isbn
Search books by ISBN.

**Query Parameters:**
- `q` (required): ISBN number

**Example:**
```
GET /api/books/search/isbn?q=978-0-7432-7356-5
```

#### GET /api/books/new-releases
Get recently published books.

**Query Parameters:**
- `days` (optional): Number of days back to search (1-365, default: 30)
- `limit` (optional): Number of books to return (1-100, default: 20)

**Example:**
```
GET /api/books/new-releases?days=7&limit=10
```

#### GET /api/books/:id/related
Get books related to a specific book.

**Parameters:**
- `id`: Book UUID

**Example:**
```
GET /api/books/book-uuid/related
```

## Authentication

The server uses JWT (JSON Web Tokens) for authentication with the following approach:

### Token Types

1. **Access Token**: Short-lived token (15 minutes) for API access
2. **Refresh Token**: Long-lived token (7 days) for refreshing access tokens

### Authentication Flow

1. User signs up or logs in
2. Server returns access token and sets refresh token as HTTP-only cookie
3. Client includes access token in `Authorization` header for protected routes
4. When access token expires, client uses refresh endpoint to get new access token

### Protected Routes

Currently, only the `/api/auth/me` endpoint requires authentication. Include the access token in the Authorization header:

```
Authorization: Bearer <access-token>
```

### Rate Limiting

Authentication endpoints have rate limiting applied:
- Signup: Limited to prevent abuse
- Other auth endpoints: Standard rate limiting

## Error Handling

The API returns consistent error responses:

```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

### Common Error Codes

- `MISSING_FIELDS`: Required fields are missing
- `INVALID_CREDENTIALS`: Login credentials are incorrect
- `USER_NOT_FOUND`: User does not exist
- `EMAIL_EXISTS`: Email already registered
- `USERNAME_EXISTS`: Username already taken
- `BOOK_NOT_FOUND`: Book not found
- `INVALID_SEARCH_QUERY`: Search query is invalid
- `INTERNAL_SERVER_ERROR`: Server error occurred

### HTTP Status Codes

- `200`: Success
- `201`: Created (signup)
- `400`: Bad Request (validation errors)
- `401`: Unauthorized (authentication required)
- `404`: Not Found
- `409`: Conflict (duplicate data)
- `500`: Internal Server Error

## Caching

The server implements Redis caching for performance optimization:

### Cached Endpoints

- All book search endpoints
- Book listings
- Individual book details
- Related books

### Cache Configuration

- **TTL**: 60 seconds for most book data
- **Keys**: Structured as `books:type:query`
- **Behavior**: Cache miss triggers database query and cache update

### Cache Headers

Responses include cache metadata:

```json
{
  "meta": {
    "cached": true
  }
}
```

## Database Schema

The server connects to a PostgreSQL database with the following main tables:

### Users
- `user_id` (UUID, Primary Key)
- `username` (String, Unique)
- `email` (String, Unique)
- `hashed_password` (String)
- `created_at` (Timestamp)

### Books
- `book_id` (UUID, Primary Key)
- `title` (String)
- `isbn` (String)
- `publication_date` (Date)
- `description` (Text)
- `page_count` (Integer)
- `language` (String)
- `cover_image_url` (String)

### Related Tables
- `authors`: Book authors
- `categories`: Book categories
- `genres`: Book genres
- `publishers`: Book publishers
- Junction tables for many-to-many relationships

## Development

### Scripts

```bash
# Development
pnpm run dev          # Start development server with hot reload
pnpm run build        # Build TypeScript to JavaScript
pnpm run start        # Start production server

# Testing
pnpm run test         # Run test suite
pnpm run check-types  # TypeScript type checking

# Database
pnpm run migrate      # Run database migrations
pnpm run seed         # Seed database with sample data

# Health Checks
pnpm run health       # Check API health (formatted)
pnpm run health:quick # Quick health check

# Code Quality
pnpm run lint         # Run ESLint
```

### Development Environment

The server uses `nodemon` with `tsx` for hot reloading during development. Any changes to TypeScript files will automatically restart the server.

### Testing

The project includes comprehensive tests using Vitest:

```bash
# Run all tests
pnpm run test

# Run tests in watch mode
pnpm run test --watch

# Run tests with coverage
pnpm run test --coverage
```

## Docker Deployment

The server includes Docker configuration for containerized deployment.

### Docker Build

```bash
# Build the image
docker build -t booklab-server .

# Run the container
docker run -p 5000:4000 -e NODE_ENV=production booklab-server
```

### Docker Compose

For full stack deployment with PostgreSQL and Redis:

```bash
# Start all services
docker-compose -f docker-compose.dev.yml up

# Stop services
docker-compose -f docker-compose.dev.yml down
```

### Environment in Docker

The Docker container expects these environment variables:
- Database connection details
- Redis connection details
- JWT secrets
- CORS origins

### Production Considerations

1. **Environment Variables**: Ensure all production secrets are properly set
2. **Database**: Use managed PostgreSQL service in production
3. **Redis**: Use managed Redis service for caching
4. **SSL**: Configure HTTPS in production
5. **Monitoring**: Implement health checks and monitoring
6. **Logging**: Configure structured logging for production

## Security Features

### Implemented Security

1. **Helmet**: Security headers
2. **CORS**: Configurable cross-origin requests
3. **Rate Limiting**: Protection against abuse
4. **Password Hashing**: bcrypt for secure password storage
5. **JWT**: Secure token-based authentication
6. **Input Validation**: Zod schema validation
7. **SQL Injection Protection**: Parameterized queries
8. **Session Security**: Secure cookie configuration

### Security Best Practices

1. Keep dependencies updated
2. Use HTTPS in production
3. Implement proper logging and monitoring
4. Regular security audits
5. Environment variable protection
6. Database access controls

## Support

For issues, questions, or contributions, please refer to the project repository or contact the development team.

---

**Last Updated**: January 2024  
**API Version**: 1.0.0  
**Server Version**: See package.json
