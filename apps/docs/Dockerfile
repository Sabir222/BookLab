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
COPY packages/ ./packages/

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
COPY --from=builder --chown=nextjs:nodejs /app/apps/docs/.next ./apps/docs/.next
COPY --from=builder --chown=nextjs:nodejs /app/apps/docs/public ./apps/docs/public
COPY --from=builder --chown=nextjs:nodejs /app/apps/docs/package.json ./apps/docs/
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
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
