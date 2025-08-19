# BookLab Express Server

## Tech Stack

The BookLab backend is built with the following technologies:

- **Express.js** - Web application framework for Node.js
- **TypeScript** - Typed superset of JavaScript for better code quality
- **PostgreSQL** - Primary database for persistent data storage
- **Redis** - In-memory data structure store for caching
- **JWT** - JSON Web Tokens for authentication
- **Bcrypt** - Password hashing library
- **Zod** - TypeScript-first schema declaration and validation library

## Database Layer

The database layer is implemented in a separate package `@repo/db` which provides:

- PostgreSQL queries and connection management
- Redis caching utilities
- Database schema definitions

For more information about the database implementation, see the [db package documentation](../../packages/db/README.md).

## Project Structure

```
apps/server/
├── src/
│   ├── features/           # Feature modules (auth, book, user, etc.)
│   │   ├── auth/           # Authentication module
│   │   ├── book/           # Book management module
│   │   ├── newsletter/     # Newsletter subscription module
│   │   ├── user/           # User management module
│   │   └── wishlist/       # Wishlist management module
│   ├── utils/              # Utility functions and helpers
│   ├── docs/               # API documentation and Swagger files
│   └── server.ts           # Main server entry point
├── package.json            # Project dependencies and scripts
└── tsconfig.json           # TypeScript configuration
```

Each feature module follows a consistent structure:

```
feature/
├── controllers/            # Request handlers
├── middleware/             # Feature-specific middleware
├── routes/                 # Route definitions
└── validation/             # Request validation schemas
```

## API Documentation

Comprehensive API documentation is available through Swagger UI. When the server is running, you can access the interactive API documentation at:

- API Docs: [Swagger](https://app.swaggerhub.com/apis-docs/MRSABIR4/book-lab_api/1.0.0)
- Development: `http://localhost:4000/api/docs`

The Swagger UI provides:

- Interactive API testing interface
- Detailed endpoint descriptions
- Request/response examples
- Authentication flow documentation

## Environment Variables

The server requires several environment variables to be set. See `.env.example` for a complete list of required variables.

## Development

To start the development server:

```bash
pnpm dev
```

To build the project for production:

```bash
pnpm build
```

To start the production server:

```bash
pnpm start
```

## Docker Setup

To run the server with Docker, use the following commands from the root of the monorepo:

```bash
# Build and start all services
docker-compose up --build

# Run in detached mode
docker-compose up --build -d

# Stop all services
docker-compose down
```

The server will be available at http://localhost:4000

### Environment Variables

Create a `.env` file in the server directory with your configuration:

```bash
# Database
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/booklab

# Redis
REDIS_URL=redis://redis:6379

# Session
SESSION_SECRET=your-session-secret

# CORS
CORS_ORIGIN=http://localhost:3000

# JWT
JWT_SECRET=your-jwt-secret
JWT_EXPIRES_IN=7d
```