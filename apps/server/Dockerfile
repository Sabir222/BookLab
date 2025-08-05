FROM oven/bun:1.1.38-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Copy root package.json and lockfile
COPY package.json bun.lock ./
COPY turbo.json ./

# Copy package.json files from all workspaces
COPY apps/server/package.json ./apps/server/
COPY packages/ ./packages/

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
