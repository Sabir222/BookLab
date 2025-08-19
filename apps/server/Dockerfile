# Use the official Node.js runtime as the base image
FROM node:18-alpine

# Install pnpm
RUN npm install -g pnpm

# Set the working directory inside the container
WORKDIR /app

# Copy package files and workspace configuration
COPY package.json pnpm-workspace.yaml ./

# Copy all packages and apps
COPY packages/ ./packages/
COPY apps/ ./apps/

# Install all dependencies
RUN pnpm install

# Build all packages and apps
RUN pnpm run build

# Remove dev dependencies for production
RUN pnpm install --prod

# Expose the port the app runs on
EXPOSE 4000

# Set environment variables
ENV PORT=4000
ENV NODE_ENV=production

# Create a non-root user and switch to it
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001 -G nodejs
USER nextjs

# Start the server application
WORKDIR /app/apps/server
CMD ["pnpm", "start"]