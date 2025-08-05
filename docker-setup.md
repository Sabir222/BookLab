# Complete Docker Setup for Turbo Monorepo

This document contains all the Docker configuration files for your Turbo monorepo project.

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
└── .env.local
```

---

## 🚀 **apps/web/Dockerfile**

```dockerfile
# apps/web/Dockerfile
FROM oven/bun:1.1.38-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Copy root package.json and lockfile
COPY package.json bun.lock ./
COPY turbo.json ./

# Copy package.json files from all workspaces
COPY apps/web/package.json ./apps/web/
COPY packages/*/package.json ./packages/*/

# Install dependencies
RUN bun install --frozen-lockfile

# Build stage
FROM base AS builder
WORKDIR /app

# Copy dependencies
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/web/node_modules ./apps/web/node_modules

# Copy source code
COPY . .

# Build the web app
RUN bunx turbo build --filter=web

# Production stage
FROM base AS production
WORKDIR /app

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built application
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/.next/static ./apps/web/.next/static
COPY --from=builder --chown=nextjs:nodejs /app/apps/web/public ./apps/web/public

USER nextjs

EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/api/health || exit 1

CMD ["bun", "run", "apps/web/server.js"]

# Development stage
FROM base AS development
WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Copy dependencies
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY . .

# Create non-root user for development
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 --ingroup nodejs devuser
RUN chown -R devuser:nodejs /app

USER devuser

EXPOSE 3000
ENV PORT=3000

# Health check for development
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000 || exit 1

CMD ["bunx", "turbo", "run", "dev", "--filter=web"]
```

---

## 📚 **apps/docs/Dockerfile**

```dockerfile
# apps/docs/Dockerfile
FROM oven/bun:1.1.38-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Copy root package.json and lockfile
COPY package.json bun.lock ./
COPY turbo.json ./

# Copy package.json files from all workspaces
COPY apps/docs/package.json ./apps/docs/
COPY packages/*/package.json ./packages/*/

# Install dependencies
RUN bun install --frozen-lockfile

# Build stage
FROM base AS builder
WORKDIR /app

# Copy dependencies
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/apps/docs/node_modules ./apps/docs/node_modules

# Copy source code
COPY . .

# Build the docs app
RUN bunx turbo build --filter=docs

# Production stage
FROM base AS production
WORKDIR /app

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built application
COPY --from=builder --chown=nextjs:nodejs /app/apps/docs/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/apps/docs/.next/static ./apps/docs/.next/static
COPY --from=builder --chown=nextjs:nodejs /app/apps/docs/public ./apps/docs/public

USER nextjs

EXPOSE 3001
ENV PORT=3001
ENV HOSTNAME="0.0.0.0"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3001/api/health || exit 1

CMD ["bun", "run", "apps/docs/server.js"]

# Development stage
FROM base AS development
WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Copy dependencies
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY . .

# Create non-root user for development
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 --ingroup nodejs devuser
RUN chown -R devuser:nodejs /app

USER devuser

EXPOSE 3001
ENV PORT=3001

# Health check for development
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3001 || exit 1

CMD ["bunx", "turbo", "run", "dev", "--filter=docs"]
```

---

## 🚀 **apps/server/Dockerfile**

```dockerfile
# apps/server/Dockerfile
FROM oven/bun:1.1.38-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Copy root package.json and lockfile
COPY package.json bun.lock ./
COPY turbo.json ./

# Copy package.json files from all workspaces
COPY apps/server/package.json ./apps/server/
COPY packages/*/package.json ./packages/*/

# Install dependencies
RUN bun install --frozen-lockfile

# Development stage (default for dev)
FROM base AS development
WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Copy dependencies
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY . .

# Create non-root user for development
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 --ingroup nodejs devuser
RUN chown -R devuser:nodejs /app

USER devuser

EXPOSE 4000
ENV PORT=4000
ENV NODE_ENV=development

# Health check for development
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:4000/health || exit 1

CMD ["bunx", "turbo", "run", "dev", "--filter=server"]

# Build stage
FROM base AS builder
WORKDIR /app

# Copy dependencies
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY . .

# Build the server and dependencies
RUN bunx turbo build --filter=server

# Production stage
FROM base AS production
WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Create non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 --ingroup nodejs serveruser

# Copy built application and node_modules
COPY --from=builder --chown=serveruser:nodejs /app/apps/server/dist ./apps/server/dist
COPY --from=builder --chown=serveruser:nodejs /app/packages ./packages
COPY --from=builder --chown=serveruser:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=serveruser:nodejs /app/apps/server/package.json ./apps/server/

USER serveruser

EXPOSE 4000
ENV PORT=4000
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:4000/health || exit 1

CMD ["bun", "run", "apps/server/dist/index.js"]
```

---

## 🐳 **docker-compose.dev.yml**

```yaml
services:
  # PostgreSQL Database
  postgres:
    image: postgres:16-alpine
    container_name: turbo-postgres-dev
    restart: unless-stopped
    environment:
      POSTGRES_USER: sabir
      POSTGRES_PASSWORD: pw
      POSTGRES_DB: booklab_db
      POSTGRES_INITDB_ARGS: "--auth-host=scram-sha-256 --auth-local=scram-sha-256"
    ports:
      - "5432:5432"
    volumes:
      - postgres_data_dev:/var/lib/postgresql/data
      # - ./init-scripts:/docker-entrypoint-initdb.d
    networks:
      - turbo-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sabir -d booklab_db"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: turbo-redis-dev
    restart: unless-stopped
    command: redis-server --requirepass redispw --appendonly yes
    ports:
      - "6379:6379"
    volumes:
      - redis_data_dev:/data
    networks:
      - turbo-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
      start_period: 10s

  # Server API
  server:
    build:
      context: .
      dockerfile: apps/server/Dockerfile
      target: development
    container_name: turbo-server-dev
    restart: unless-stopped
    ports:
      - "4000:4000"
    environment:
      - PORT=4000
      - NODE_ENV=development
      - HOST=0.0.0.0
      - SCHEME=http
      - CORS_ORIGIN=http://localhost:3000,http://localhost:3001,http://localhost:4000
      - SESSION_SECRET=1f3fd74888c842f58d507322785a4861
      - JWT_SECRET=fJq86HD1s7FlTEMd3O85AuIWL1fdrhziD6q5xvEd7fs=
      - JWT_REFRESH_SECRET=DCqJ9pZa75Tz+DT3AJV+Ffcl/5ZvJ/59Ns2Lanjj3cQ=
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_USER=sabir
      - DB_PASSWORD=pw
      - DB_NAME=booklab_db
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - REDIS_PASSWORD=redispw
      - REDIS_DB=0
    volumes:
      - .:/app
      - /app/node_modules
      - /app/apps/server/node_modules
    networks:
      - turbo-network
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    develop:
      watch:
        - action: sync
          path: ./apps/server
          target: /app/apps/server
          ignore:
            - node_modules/
        - action: sync
          path: ./packages
          target: /app/packages
          ignore:
            - node_modules/

  # Web App
  web:
    build:
      context: .
      dockerfile: apps/web/Dockerfile
      target: development
    container_name: turbo-web-dev
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - NODE_ENV=development
      - NEXT_TELEMETRY_DISABLED=1
    volumes:
      - .:/app
      - /app/node_modules
      - /app/apps/web/node_modules
      - /app/apps/web/.next
    networks:
      - turbo-network
    depends_on:
      - server
    develop:
      watch:
        - action: sync
          path: ./apps/web
          target: /app/apps/web
          ignore:
            - node_modules/
            - .next/
        - action: sync
          path: ./packages
          target: /app/packages
          ignore:
            - node_modules/

  # Docs App
  docs:
    build:
      context: .
      dockerfile: apps/docs/Dockerfile
      target: development
    container_name: turbo-docs-dev
    restart: unless-stopped
    ports:
      - "3001:3001"
    environment:
      - PORT=3001
      - NODE_ENV=development
      - NEXT_TELEMETRY_DISABLED=1
    volumes:
      - .:/app
      - /app/node_modules
      - /app/apps/docs/node_modules
      - /app/apps/docs/.next
    networks:
      - turbo-network
    develop:
      watch:
        - action: sync
          path: ./apps/docs
          target: /app/apps/docs
          ignore:
            - node_modules/
            - .next/
        - action: sync
          path: ./packages
          target: /app/packages
          ignore:
            - node_modules/

volumes:
  postgres_data_dev:
    driver: local
  redis_data_dev:
    driver: local

networks:
  turbo-network:
    driver: bridge
```

---

## 🏭 **docker-compose.prod.yml**

```yaml
services:
  # PostgreSQL Database
  postgres:
    image: postgres:16-alpine
    container_name: turbo-postgres-prod
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER:-sabir}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-pw}
      POSTGRES_DB: ${DB_NAME:-booklab_db}
      POSTGRES_INITDB_ARGS: "--auth-host=scram-sha-256 --auth-local=scram-sha-256"
    ports:
      - "${DB_PORT:-5432}:5432"
    volumes:
      - postgres_data_prod:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    networks:
      - turbo-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-sabir} -d ${DB_NAME:-booklab_db}"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: turbo-redis-prod
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD:-redispw} --appendonly yes --maxmemory 256mb --maxmemory-policy allkeys-lru
    ports:
      - "${REDIS_PORT:-6379}:6379"
    volumes:
      - redis_data_prod:/data
    networks:
      - turbo-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M

  # Server API
  server:
    build:
      context: .
      dockerfile: apps/server/Dockerfile
      target: production
    container_name: turbo-server-prod
    restart: unless-stopped
    ports:
      - "${PORT:-4000}:4000"
    environment:
      - PORT=4000
      - NODE_ENV=production
      - HOST=0.0.0.0
      - SCHEME=${SCHEME:-https}
      - CORS_ORIGIN=${CORS_ORIGIN}
      - SESSION_SECRET=${SESSION_SECRET}
      - JWT_SECRET=${JWT_SECRET}
      - JWT_REFRESH_SECRET=${JWT_REFRESH_SECRET}
      - JWT_EXPIRES_IN=${JWT_EXPIRES_IN:-15m}
      - JWT_REFRESH_EXPIRES_IN=${JWT_REFRESH_EXPIRES_IN:-7d}
      - ACCESS_TOKEN_COOKIE_NAME=${ACCESS_TOKEN_COOKIE_NAME:-access_token}
      - REFRESH_TOKEN_COOKIE_NAME=${REFRESH_TOKEN_COOKIE_NAME:-refresh_token}
      - REFRESH_TOKEN_COOKIE_MAX_AGE=${REFRESH_TOKEN_COOKIE_MAX_AGE:-604800000}
      - ACCESS_TOKEN_COOKIE_MAX_AGE=${ACCESS_TOKEN_COOKIE_MAX_AGE:-900000}
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_USER=${DB_USER:-sabir}
      - DB_PASSWORD=${DB_PASSWORD:-pw}
      - DB_NAME=${DB_NAME:-booklab_db}
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - REDIS_PASSWORD=${REDIS_PASSWORD:-redispw}
      - REDIS_DB=${REDIS_DB:-0}
    networks:
      - turbo-network
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M

  # Web App
  web:
    build:
      context: .
      dockerfile: apps/web/Dockerfile
      target: production
    container_name: turbo-web-prod
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - NODE_ENV=production
      - NEXT_TELEMETRY_DISABLED=1
    networks:
      - turbo-network
    depends_on:
      - server
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M

  # Docs App
  docs:
    build:
      context: .
      dockerfile: apps/docs/Dockerfile
      target: production
    container_name: turbo-docs-prod
    restart: unless-stopped
    ports:
      - "3001:3001"
    environment:
      - PORT=3001
      - NODE_ENV=production
      - NEXT_TELEMETRY_DISABLED=1
    networks:
      - turbo-network
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M

volumes:
  postgres_data_prod:
    driver: local
  redis_data_prod:
    driver: local

networks:
  turbo-network:
    driver: bridge
```

---

## 🚫 **Root .dockerignore**

```gitignore
.git
.gitignore
README.md
.env
.env.local
.env.production.local
.env.development.local
Dockerfile*
docker-compose*
.dockerignore
node_modules
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.next
.nuxt
dist
.cache
.parcel-cache
.nyc_output
.vscode
.idea
*.swp
*.swo
*~

# Test files
__tests__
**/*.test.js
**/*.test.ts
**/*.spec.js
**/*.spec.ts
coverage
.coverage

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

---

## 🚫 **apps/web/.dockerignore**

```gitignore
node_modules
.next
.env*
.git
.gitignore
README.md
Dockerfile*
docker-compose*
.dockerignore
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.cache
.parcel-cache
.nyc_output
.vscode
.idea
*.swp
*.swo
*~
__tests__
**/*.test.js
**/*.test.ts
**/*.spec.js
**/*.spec.ts
coverage
.coverage
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

---

## 🚫 **apps/docs/.dockerignore**

```gitignore
node_modules
.next
.env*
.git
.gitignore
README.md
Dockerfile*
docker-compose*
.dockerignore
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.cache
.parcel-cache
.nyc_output
.vscode
.idea
*.swp
*.swo
*~
__tests__
**/*.test.js
**/*.test.ts
**/*.spec.js
**/*.spec.ts
coverage
.coverage
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

---

## 🚫 **apps/server/.dockerignore**

```gitignore
node_modules
dist
.env*
.git
.gitignore
README.md
Dockerfile*
docker-compose*
.dockerignore
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.cache
.parcel-cache
.nyc_output
.vscode
.idea
*.swp
*.swo
*~
__tests__
**/*.test.js
**/*.test.ts
**/*.spec.js
**/*.spec.ts
coverage
.coverage
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

---

## 🌍 **.env.development**

```bash
NODE_ENV=development
PORT=4000
CORS_ORIGIN=http://localhost:3000,http://localhost:3001,http://localhost:4000
HOST=localhost
SCHEME=http
SESSION_SECRET=1f3fd74888c842f58d507322785a4861
JWT_SECRET=fJq86HD1s7FlTEMd3O85AuIWL1fdrhziD6q5xvEd7fs=
JWT_REFRESH_SECRET=DCqJ9pZa75Tz+DT3AJV+Ffcl/5ZvJ/59Ns2Lanjj3cQ=
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
ACCESS_TOKEN_COOKIE_NAME=access_token
REFRESH_TOKEN_COOKIE_NAME=refresh_token
REFRESH_TOKEN_COOKIE_MAX_AGE=604800000
ACCESS_TOKEN_COOKIE_MAX_AGE=900000

# Database settings (will be overridden by docker-compose for container services)
DB_HOST=postgres
DB_PORT=5432
DB_USER=sabir
DB_PASSWORD=pw
DB_NAME=booklab_db

# Redis settings (will be overridden by docker-compose for container services)
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=redispw
REDIS_DB=0
```

---

## 🌍 **.env.production**

```bash
NODE_ENV=production
PORT=4000
CORS_ORIGIN=https://yourdomain.com,https://docs.yourdomain.com
HOST=0.0.0.0
SCHEME=https

# IMPORTANT: Change these secrets in production!
SESSION_SECRET=your_secure_session_secret_here
JWT_SECRET=your_secure_jwt_secret_here
JWT_REFRESH_SECRET=your_secure_jwt_refresh_secret_here
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
ACCESS_TOKEN_COOKIE_NAME=access_token
REFRESH_TOKEN_COOKIE_NAME=refresh_token
REFRESH_TOKEN_COOKIE_MAX_AGE=604800000
ACCESS_TOKEN_COOKIE_MAX_AGE=900000

# Database settings
DB_HOST=postgres
DB_PORT=5432
DB_USER=sabir
DB_PASSWORD=your_secure_db_password_here
DB_NAME=booklab_db

# Redis settings
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=your_secure_redis_password_here
REDIS_DB=0
```

---

## 🌍 **.env.local**

```bash
NODE_ENV=development
PORT=4000
CORS_ORIGIN=http://localhost:3000,http://localhost:3001,http://localhost:4000
HOST=localhost
SCHEME=http
SESSION_SECRET=1f3fd74888c842f58d507322785a4861
JWT_SECRET=fJq86HD1s7FlTEMd3O85AuIWL1fdrhziD6q5xvEd7fs=
JWT_REFRESH_SECRET=DCqJ9pZa75Tz+DT3AJV+Ffcl/5ZvJ/59Ns2Lanjj3cQ=
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
ACCESS_TOKEN_COOKIE_NAME=access_token
REFRESH_TOKEN_COOKIE_NAME=refresh_token
REFRESH_TOKEN_COOKIE_MAX_AGE=604800000
ACCESS_TOKEN_COOKIE_MAX_AGE=900000

# Local database settings
DB_HOST=localhost
DB_PORT=5432
DB_USER=sabir
DB_PASSWORD=pw
DB_NAME=booklab_db

# Local Redis settings
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=redispw
REDIS_DB=0
```

---

## 🚀 **Quick Start Commands**

### Development
```bash
# Setup environment
cp .env.development .env

# Start all services
docker-compose -f docker-compose.dev.yml up --build

# Start only databases
docker-compose -f docker-compose.dev.yml up postgres redis
```

### Production
```bash
# Setup environment
cp .env.production .env
# Edit .env with your production secrets

# Deploy
docker-compose -f docker-compose.prod.yml up -d --build
```

### Cleanup
```bash
# Stop all services
docker-compose -f docker-compose.dev.yml down

# Remove everything including volumes
docker-compose -f docker-compose.dev.yml down -v
```
