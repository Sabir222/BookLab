FROM oven/bun:1-alpine

WORKDIR /usr/src/app

# Create a non-root user for security and permission compatibility
# This prevents permission issues with volume mounts
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001 -G nodejs

# Copy package files first for better layer caching
# This allows Docker to cache the dependency installation step
COPY package.json bun.lock* ./
COPY turbo.json ./
COPY apps/server/package.json ./apps/server/
COPY packages/ ./packages/

# Install dependencies as root (needed for system-level installs)
RUN bun install

# Copy the rest of the application code
# For development, this gets overridden by volume mount
COPY . .

# Change ownership of all files to the nodejs user
# This is CRITICAL - ensures the non-root user can read/write files
RUN chown -R nextjs:nodejs /usr/src/app

# Switch to non-root user BEFORE running the application
# This prevents permission errors when turbo tries to access files
USER nextjs

# Expose the port the app runs on
EXPOSE 4000

# Set environment variables
ENV PORT=4000
ENV NODE_ENV=development

# Start the development server
# The non-root user will now have proper permissions to run turbo
CMD ["bunx", "turbo", "run", "dev", "--filter=server"]
