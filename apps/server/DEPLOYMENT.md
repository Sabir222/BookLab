# BookLab Server Deployment Guide

This guide covers various deployment strategies for the BookLab Express server.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Configuration](#environment-configuration)
- [Docker Deployment](#docker-deployment)
- [Cloud Deployment](#cloud-deployment)
- [Production Checklist](#production-checklist)
- [Monitoring & Health Checks](#monitoring--health-checks)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

- **Node.js**: 18+ or Bun 1.0+
- **PostgreSQL**: 14+ (managed service recommended for production)
- **Redis**: 6+ (managed service recommended for production)
- **Memory**: Minimum 512MB RAM (2GB+ recommended for production)
- **Storage**: 10GB+ available space

### Required Services

1. **PostgreSQL Database**
   - Properly configured with required extensions
   - Regular backups configured
   - Connection pooling enabled

2. **Redis Cache**
   - Persistent storage configured
   - Memory eviction policy set
   - Monitoring enabled

3. **Load Balancer** (for production)
   - Health check endpoints configured
   - SSL termination
   - Rate limiting

## Environment Configuration

### Production Environment Variables

```env
# Server Configuration
NODE_ENV=production
PORT=5000
CORS_ORIGIN=https://yourdomain.com,https://www.yourdomain.com

# Database (use managed service URLs)
DATABASE_URL=postgresql://user:password@db-host:5432/booklab_prod

# Redis (use managed service URL)
REDIS_URL=redis://user:password@redis-host:6379

# Security (use strong, unique secrets)
SESSION_SECRET=64-character-random-string
JWT_ACCESS_SECRET=64-character-random-string
JWT_REFRESH_SECRET=64-character-random-string

# Optional Production Settings
LOG_LEVEL=warn
CACHE_TTL=300
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=1000
```

### Generating Secure Secrets

```bash
# Generate session secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Generate JWT secrets
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

## Docker Deployment

### Single Container Deployment

#### Build and Run

```bash
# Build the image
docker build -t booklab-server .

# Run with environment file
docker run -d \
  --name booklab-server \
  -p 5000:4000 \
  --env-file .env.production \
  --restart unless-stopped \
  booklab-server
```

#### Docker Compose Production

Create `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  server:
    build: .
    ports:
      - "5000:4000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
      - SESSION_SECRET=${SESSION_SECRET}
      - JWT_ACCESS_SECRET=${JWT_ACCESS_SECRET}
      - JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET}
      - CORS_ORIGIN=${CORS_ORIGIN}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:4000/api/health/quick"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: booklab_prod
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

volumes:
  postgres_data:
  redis_data:
```

Deploy:

```bash
# Start production services
docker-compose -f docker-compose.prod.yml up -d

# Check logs
docker-compose -f docker-compose.prod.yml logs -f server

# Stop services
docker-compose -f docker-compose.prod.yml down
```

### Multi-Stage Production Dockerfile

Create `Dockerfile.prod`:

```dockerfile
# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY turbo.json ./
COPY apps/server/package.json ./apps/server/
COPY packages/ ./packages/

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY apps/server/src ./apps/server/src
COPY apps/server/tsconfig.json ./apps/server/

# Build application
RUN npm run build

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S booklab -u 1001 -G nodejs

# Copy built application
COPY --from=builder --chown=booklab:nodejs /app/apps/server/dist ./dist
COPY --from=builder --chown=booklab:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=booklab:nodejs /app/package*.json ./

# Install production dependencies only
RUN npm ci --only=production && npm cache clean --force

# Switch to non-root user
USER booklab

# Expose port
EXPOSE 4000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:4000/api/health/quick || exit 1

# Start application
CMD ["node", "dist/server.js"]
```

## Cloud Deployment

### AWS Deployment

#### Using AWS ECS with Fargate

1. **Build and Push to ECR**

```bash
# Create ECR repository
aws ecr create-repository --repository-name booklab-server

# Get login token
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Build and tag image
docker build -t booklab-server .
docker tag booklab-server:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/booklab-server:latest

# Push image
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/booklab-server:latest
```

2. **Create ECS Task Definition**

```json
{
  "family": "booklab-server",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024",
  "executionRoleArn": "arn:aws:iam::account:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "booklab-server",
      "image": "<account-id>.dkr.ecr.us-east-1.amazonaws.com/booklab-server:latest",
      "portMappings": [
        {
          "containerPort": 4000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "production"
        }
      ],
      "secrets": [
        {
          "name": "DATABASE_URL",
          "valueFrom": "arn:aws:secretsmanager:region:account:secret:booklab/database-url"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/booklab-server",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "healthCheck": {
        "command": ["CMD-SHELL", "curl -f http://localhost:4000/api/health/quick || exit 1"],
        "interval": 30,
        "timeout": 5,
        "retries": 3,
        "startPeriod": 60
      }
    }
  ]
}
```

#### Using AWS Elastic Beanstalk

1. **Create Dockerrun.aws.json**

```json
{
  "AWSEBDockerrunVersion": "1",
  "Image": {
    "Name": "<account-id>.dkr.ecr.us-east-1.amazonaws.com/booklab-server:latest",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": "4000"
    }
  ]
}
```

2. **Deploy**

```bash
# Initialize EB application
eb init booklab-server

# Create environment
eb create production

# Deploy
eb deploy
```

### Google Cloud Platform

#### Using Cloud Run

```bash
# Build and push to Container Registry
gcloud builds submit --tag gcr.io/PROJECT_ID/booklab-server

# Deploy to Cloud Run
gcloud run deploy booklab-server \
  --image gcr.io/PROJECT_ID/booklab-server \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 4000 \
  --memory 1Gi \
  --cpu 1 \
  --set-env-vars NODE_ENV=production \
  --set-secrets DATABASE_URL=database-url:latest \
  --set-secrets REDIS_URL=redis-url:latest
```

### Heroku Deployment

1. **Create Heroku App**

```bash
# Create app
heroku create booklab-server-prod

# Add PostgreSQL addon
heroku addons:create heroku-postgresql:standard-0

# Add Redis addon
heroku addons:create heroku-redis:premium-0

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set SESSION_SECRET=$(openssl rand -hex 32)
heroku config:set JWT_ACCESS_SECRET=$(openssl rand -hex 64)
heroku config:set JWT_REFRESH_SECRET=$(openssl rand -hex 64)
```

2. **Deploy**

```bash
# Deploy using Docker
heroku container:push web
heroku container:release web

# Or deploy using Git
git push heroku main
```

## Production Checklist

### Pre-Deployment

- [ ] **Environment Variables**
  - [ ] All required variables set
  - [ ] Secrets are secure and unique
  - [ ] CORS origins configured correctly
  - [ ] Database URLs point to production instances

- [ ] **Database**
  - [ ] Migrations run successfully
  - [ ] Backup strategy implemented
  - [ ] Connection pooling configured
  - [ ] Monitoring enabled

- [ ] **Redis**
  - [ ] Persistent storage configured
  - [ ] Memory limits set appropriately
  - [ ] Monitoring enabled

- [ ] **Security**
  - [ ] HTTPS/SSL configured
  - [ ] Security headers enabled (Helmet)
  - [ ] Rate limiting configured
  - [ ] Input validation in place

### Post-Deployment

- [ ] **Health Checks**
  - [ ] All health endpoints responding
  - [ ] Load balancer health checks configured
  - [ ] Monitoring alerts set up

- [ ] **Performance**
  - [ ] Response times acceptable
  - [ ] Cache hit rates optimal
  - [ ] Resource usage within limits

- [ ] **Logging**
  - [ ] Application logs captured
  - [ ] Error tracking configured
  - [ ] Log rotation in place

## Monitoring & Health Checks

### Health Check Endpoints

Configure your load balancer to use these endpoints:

```bash
# Primary health check (detailed)
GET /api/health

# Quick health check (for load balancers)
GET /api/health/quick

# Service-specific checks
GET /api/health/postgres
GET /api/health/redis
```

### Monitoring Setup

#### Prometheus Metrics

Add metrics endpoint:

```javascript
// Add to server.ts
import prometheus from 'prom-client';

// Create metrics
const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status']
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
  res.set('Content-Type', prometheus.register.contentType);
  res.end(prometheus.register.metrics());
});
```

#### Log Aggregation

Use structured logging:

```javascript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});
```

### Alerting

Set up alerts for:

- **Health check failures**
- **High error rates (>5%)**
- **High response times (>2s)**
- **Database connection issues**
- **Redis connection issues**
- **High memory usage (>80%)**
- **High CPU usage (>80%)**

## Troubleshooting

### Common Issues

#### Application Won't Start

```bash
# Check logs
docker logs booklab-server

# Common causes:
# - Missing environment variables
# - Database connection issues
# - Port already in use
# - Insufficient permissions
```

#### Database Connection Issues

```bash
# Test database connectivity
psql $DATABASE_URL

# Check connection pool
# Look for "too many connections" errors
# Verify connection string format
```

#### Redis Connection Issues

```bash
# Test Redis connectivity
redis-cli -u $REDIS_URL ping

# Check Redis memory usage
redis-cli info memory

# Verify Redis configuration
```

#### High Memory Usage

```bash
# Check container memory usage
docker stats booklab-server

# Profile Node.js memory
# Add --inspect flag and use Chrome DevTools
# Check for memory leaks in Redis cache
```

#### Performance Issues

```bash
# Check response times
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:5000/api/health

# Monitor database queries
# Enable SQL logging in development
# Check Redis cache hit rates
```

### Recovery Procedures

#### Database Recovery

```bash
# Restore from backup
pg_restore -d $DATABASE_URL backup.dump

# Run health check
curl http://localhost:5000/api/health/postgres
```

#### Redis Recovery

```bash
# Restart Redis service
docker restart redis

# Clear cache if corrupted
redis-cli FLUSHALL

# Verify cache is working
curl http://localhost:5000/api/health/redis
```

#### Application Recovery

```bash
# Restart application
docker restart booklab-server

# Check health
curl http://localhost:5000/api/health

# Monitor logs
docker logs -f booklab-server
```

### Support Contacts

- **Development Team**: dev-team@booklab.com
- **DevOps Team**: devops@booklab.com
- **Emergency Hotline**: +1-555-BOOKLAB

---

For additional support, check the main [README.md](./README.md) and [API Documentation](./API_DOCUMENTATION.md).
