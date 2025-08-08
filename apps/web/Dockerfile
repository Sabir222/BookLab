FROM node:18-alpine

WORKDIR /usr/src/app

# Install Bun as package manager
RUN npm install -g bun

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001 -G nodejs

# Copy package files
COPY package.json bun.lock* ./
COPY turbo.json ./
COPY apps/web/package.json ./apps/web/
COPY packages/ ./packages/

# Install dependencies using Bun as package manager
RUN bun install

# Copy source code
COPY . .

# Change ownership
RUN chown -R nextjs:nodejs /usr/src/app

# Switch to non-root user
USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV NODE_ENV=development
ENV NEXT_TELEMETRY_DISABLED=1

# Use npx with turbo (Node.js runtime)
CMD ["npx", "turbo", "run", "dev", "--filter=web"]
