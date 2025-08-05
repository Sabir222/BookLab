# Docker Setup for Turbo Monorepo

✔ ✘

## 📁 File Structure

```
turbo-monorepo/
├── apps/
│   ├── web/
│   │   ├── Dockerfile
│   │   └── .dockerignore
│   ├── docs/
│   │   ├── Dockerfile
│   │   └── .dockerignore
│   └── server/
│       ├── Dockerfile
│       └── .dockerignore
├── docker-compose.dev.yml
├── docker-compose.prod.yml
├── .dockerignore
├── .env.development
├── .env.production
├── .env.local
└── README-Docker.md
```

## 🚀 Quick Start

### Development Environment

1. **Prepare environment:**

   ```bash
   # Copy environment template
   cp .env.development .env

   # Create init-scripts directory for database initialization (optional)
   mkdir -p init-scripts
   ```

2. **Start all services:**

   ```bash
   docker-compose -f docker-compose.dev.yml up --build
   ```

3. **Access your services:**
   - Web App: http://localhost:3000
   - Docs App: http://localhost:3001
   - Server API: http://localhost:4000
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

### Production Environment

1. **Prepare environment:**

   ```bash
   # Copy and modify production environment
   cp .env.production .env
   # Edit .env with your production secrets and domains
   ```

2. **Deploy:**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d --build
   ```

## 🛠️ Development Features

### Hot Reloading

The development setup includes:

- **File watching**: Changes to source code trigger automatic rebuilds
- **Volume mounting**: Source code is mounted for instant updates
- **Turbo integration**: Uses Turbo's development server for optimal performance

### Development Commands

```bash
# Start all services in development mode
docker-compose -f docker-compose.dev.yml up --build

# Start specific services
docker-compose -f docker-compose.dev.yml up postgres redis server

# Run in background
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f
docker-compose -f docker-compose.dev.yml logs -f server  # Specific service

# Stop all services
docker-compose -f docker-compose.dev.yml down

# Stop and remove volumes (careful - this deletes data!)
docker-compose -f docker-compose.dev.yml down -v

# Rebuild specific service
docker-compose -f docker-compose.dev.yml build --no-cache server

# Execute commands in running containers
docker-compose -f docker-compose.dev.yml exec server bun run check-types
docker-compose -f docker-compose.dev.yml exec web bun run lint
```

## 🏗️ Production Deployment

### Environment Configuration

Before deploying to production, update your `.env` file:

```bash
# Critical: Update these values for production
SESSION_SECRET=your_256_bit_secret_key_here
JWT_SECRET=your_jwt_secret_key_here
JWT_REFRESH_SECRET=your_jwt_refresh_secret_key_here
CORS_ORIGIN=https://yourdomain.com,https://docs.yourdomain.com
DB_PASSWORD=your_secure_database_password
REDIS_PASSWORD=your_secure_redis_password
```

### Production Commands

```bash
# Deploy production environment
docker-compose -f docker-compose.prod.yml up -d --build

# Update specific service
docker-compose -f docker-compose.prod.yml up -d --build --no-deps server

# View production logs
docker-compose -f docker-compose.prod.yml logs -f

# Scale services (if needed)
docker-compose -f docker-compose.prod.yml up -d --scale web=2

# Health check status
docker-compose -f docker-compose.prod.yml ps
```

## 🔧 Service Configuration

### PostgreSQL

- **Version**: PostgreSQL 16 Alpine
- **Port**: 5432
- **Database**: booklab_db
- **User**: sabir (configurable via environment)
- **Data Persistence**: Named volumes for both dev and prod
- **Health Checks**: Built-in readiness checks

### Redis

- **Version**: Redis 7 Alpine
- **Port**: 6379
- **Password Protection**: Enabled
- **Persistence**: AOF enabled for durability
- **Memory Management**: LRU eviction in production

### Next.js Apps (Web & Docs)

- **Build**: Multi-stage with Bun optimization
- **Security**: Non-root user execution
- **Health Checks**: HTTP endpoint monitoring
- **Development**: Hot reloading with file watching

### Express Server

- **Runtime**: Bun (not Node.js)
- **Build**: TypeScript compilation via Turbo
- **Dependencies**: Shared packages properly included
- **Security**: Non-root user, secure headers

## 📊 Health Monitoring

All services include health checks:

```bash
# Check health status
docker-compose -f docker-compose.dev.yml ps

# Detailed health information
docker inspect turbo-postgres-dev | grep -A 10 Health
docker inspect turbo-redis-dev | grep -A 10 Health
docker inspect turbo-server-dev | grep -A 10 Health
```

Health check endpoints:

- Server: `http://localhost:4000/health`
- Web: `http://localhost:3000` (Next.js default)
- Docs: `http://localhost:3001` (Next.js default)

## 🗂️ Volume Management

### Development Volumes

- `postgres_data_dev`: PostgreSQL data persistence
- `redis_data_dev`: Redis data persistence
- Source code: Mounted for hot reloading

### Production Volumes

- `postgres_data_prod`: PostgreSQL production data
- `redis_data_prod`: Redis production data

```bash
# Backup database
docker-compose -f docker-compose.prod.yml exec postgres pg_dump -U sabir booklab_db > backup.sql

# Restore database
docker-compose -f docker-compose.prod.yml exec -T postgres psql -U sabir booklab_db < backup.sql

# Backup Redis
docker-compose -f docker-compose.prod.yml exec redis redis-cli --rdb /data/dump.rdb BGSAVE
```

## 🛡️ Security Best Practices

### Implemented Security Features

- **Non-root users**: All services run with dedicated users
- **Resource limits**: CPU and memory constraints in production
- **Secret management**: Environment-based configuration
- **Network isolation**: Services communicate via Docker network
- **Health monitoring**: Automatic restart on failure

### Additional Security Recommendations

1. **Use Docker secrets** for sensitive data in production
2. **Implement reverse proxy** (nginx/traefik) with SSL
3. **Enable database SSL** for production connections
4. **Regular security updates** for base images
5. **Log monitoring** and alerting setup

## 🚨 Troubleshooting

### Common Issues

**Build failures:**

```bash
# Clear Docker build cache
docker builder prune -a

# Rebuild without cache
docker-compose -f docker-compose.dev.yml build --no-cache
```

**Permission issues:**

```bash
# Fix file permissions
sudo chown -R $USER:$USER .
```

**Database connection issues:**

```bash
# Check if PostgreSQL is ready
docker-compose -f docker-compose.dev.yml exec postgres pg_isready -U sabir

# Connect to database directly
docker-compose -f docker-compose.dev.yml exec postgres psql -U sabir -d booklab_db
```

**Port conflicts:**

```bash
# Check what's using ports
sudo lsof -i :3000
sudo lsof -i :4000
sudo lsof -i :5432
```

### Debug Commands

```bash
# Enter container shell
docker-compose -f docker-compose.dev.yml exec server sh
docker-compose -f docker-compose.dev.yml exec web sh

# Check container logs
docker-compose -f docker-compose.dev.yml logs server
docker-compose -f docker-compose.dev.yml logs --tail=50 -f web

# Inspect container configuration
docker inspect turbo-server-dev
```

## 🔄 Database Initialization

Create `init-scripts/01-init.sql` for database setup:

```sql
-- Create additional databases or users if needed
-- This script runs when PostgreSQL container starts for the first time

-- Example: Create a test database
-- CREATE DATABASE booklab_test;
-- GRANT ALL PRIVILEGES ON DATABASE booklab_test TO sabir;
```

## 📈 Performance Optimization

### Development Optimizations

- **Bun package manager**: Faster installs and runtime
- **Multi-stage builds**: Minimal production images
- **Layer caching**: Optimized Dockerfile layer structure
- **Volume mounts**: Instant code updates

### Production Optimizations

- **Resource limits**: Prevent resource exhaustion
- **Health checks**: Automatic failure recovery
- **Image optimization**: Alpine-based minimal images
- **Network optimization**: Single Docker network

## 🔧 Maintenance

### Regular Maintenance Tasks

```bash
# Update base images
docker-compose -f docker-compose.prod.yml pull

# Clean up unused resources
docker system prune -a
docker volume prune

# Backup data volumes
docker run --rm -v turbo-monorepo_postgres_data_prod:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .
```

### Monitoring Commands

```bash
# Resource usage
docker stats

# Service status
docker-compose -f docker-compose.prod.yml ps

# Container inspection
docker-compose -f docker-compose.prod.yml top
```

This setup provides a robust, scalable, and secure Docker environment for your Turbo monorepo with separate development and production configurations, comprehensive health monitoring, and production-ready security practices.
