# Database Package

This package handles database connections and operations for BookLab, supporting both PostgreSQL and Redis.

## Features

- PostgreSQL connection pooling
- Redis client management
- Database migrations
- Health checks for both databases
- Seeding scripts

## Setup

1. Copy `.env.example` to `.env` and configure your database credentials
2. Run `bun db:setup` to run migrations and seed the database

## Environment Variables

```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_user
DB_PASSWORD=your_password
DB_NAME=your_database
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
```

## Scripts

- `bun db:migrate` - Run database migrations
- `bun db:seed` - Seed the database with sample data
- `bun db:seed-one` - Seed a single entity
- `bun db:seed-transactional` - Seed data in a transaction
- `bun db:setup` - Run migrations and seed (recommended for initial setup)

## Exports

- `@repo/db/postgres` - PostgreSQL client and utilities
- `@repo/db/redis` - Redis client and utilities
- `@repo/db/health` - Health check functions

## Health Checks

The package provides comprehensive health checking for both PostgreSQL and Redis connections, with detailed status reporting.

