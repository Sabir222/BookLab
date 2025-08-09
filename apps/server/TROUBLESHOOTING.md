# BookLab Server Troubleshooting Guide

This guide helps you diagnose and resolve common issues with the BookLab Express server.

## Table of Contents

- [Quick Diagnostics](#quick-diagnostics)
- [Server Issues](#server-issues)
- [Database Issues](#database-issues)
- [Redis Issues](#redis-issues)
- [Authentication Issues](#authentication-issues)
- [Performance Issues](#performance-issues)
- [Docker Issues](#docker-issues)
- [Environment Issues](#environment-issues)
- [Debugging Tools](#debugging-tools)

## Quick Diagnostics

### Health Check Commands

```bash
# Check overall system health
curl http://localhost:5000/api/health | jq

# Quick health check
curl http://localhost:5000/api/health/quick | jq

# Check specific services
curl http://localhost:5000/api/health/postgres | jq
curl http://localhost:5000/api/health/redis | jq
```

### Server Status Commands

```bash
# Check if server is running
curl -I http://localhost:5000/

# Check server logs
pnpm run dev  # Watch logs in development
docker logs booklab-server  # Docker logs

# Check process
ps aux | grep node
lsof -ti:5000  # Check what's using port 5000
```

## Server Issues

### Server Won't Start

#### Problem: Port Already in Use
```bash
Error: listen EADDRINUSE: address already in use :::5000
```

**Solution:**
```bash
# Find process using port 5000
lsof -ti:5000

# Kill the process
lsof -ti:5000 | xargs kill -9

# Or use a different port
export PORT=5001
pnpm run dev
```

#### Problem: Missing Environment Variables
```bash
❌ Missing required environment variables: CORS_ORIGIN
```

**Solution:**
```bash
# Copy environment template
cp .env.example .env

# Edit .env file with required values
nano .env

# Verify environment variables
node -e "console.log(process.env.CORS_ORIGIN)"
```

#### Problem: Permission Denied
```bash
Error: EACCES: permission denied
```

**Solution:**
```bash
# Check file permissions
ls -la src/

# Fix permissions
chmod -R 755 src/
chown -R $USER:$USER src/

# For Docker
sudo chown -R $USER:$USER /home/sabir/Projects/BookLab
```

### Server Crashes

#### Problem: Out of Memory
```bash
FATAL ERROR: Ineffective mark-compacts near heap limit
```

**Solution:**
```bash
# Increase Node.js memory limit
export NODE_OPTIONS="--max-old-space-size=4096"

# Check memory usage
free -h
docker stats booklab-server

# Monitor memory leaks
node --inspect src/server.ts
```

#### Problem: Unhandled Promise Rejection
```bash
UnhandledPromiseRejectionWarning: Error: Connection terminated
```

**Solution:**
```bash
# Add proper error handling in code
try {
  await database.query();
} catch (error) {
  console.error('Database error:', error);
  // Handle gracefully
}

# Check for async/await issues
# Ensure all promises are properly handled
```

## Database Issues

### Connection Problems

#### Problem: Connection Refused
```bash
Error: connect ECONNREFUSED 127.0.0.1:5432
```

**Solution:**
```bash
# Check if PostgreSQL is running
pg_isready -h localhost -p 5432

# Start PostgreSQL
sudo systemctl start postgresql  # Linux
brew services start postgresql   # macOS

# Check connection string
echo $DATABASE_URL
psql $DATABASE_URL
```

#### Problem: Authentication Failed
```bash
Error: password authentication failed for user "booklab_user"
```

**Solution:**
```bash
# Verify credentials
psql -h localhost -U booklab_user -d booklab_db

# Reset password
sudo -u postgres psql
ALTER USER booklab_user PASSWORD 'newpassword';

# Check .env file
grep DATABASE_URL .env
```

#### Problem: Database Does Not Exist
```bash
Error: database "booklab_db" does not exist
```

**Solution:**
```bash
# Create database
createdb booklab_db

# Or using psql
sudo -u postgres psql
CREATE DATABASE booklab_db;
GRANT ALL PRIVILEGES ON DATABASE booklab_db TO booklab_user;

# Run migrations
pnpm run migrate
```

### Query Issues

#### Problem: Too Many Connections
```bash
Error: sorry, too many clients already
```

**Solution:**
```bash
# Check active connections
SELECT count(*) FROM pg_stat_activity;

# Kill idle connections
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE state = 'idle' AND query_start < now() - interval '5 minutes';

# Configure connection pooling
# Adjust max_connections in postgresql.conf
```

#### Problem: Slow Queries
```bash
# Query takes > 5 seconds
```

**Solution:**
```bash
# Enable query logging
echo "log_statement = 'all'" >> postgresql.conf
echo "log_min_duration_statement = 1000" >> postgresql.conf

# Analyze slow queries
EXPLAIN ANALYZE SELECT * FROM books WHERE title ILIKE '%query%';

# Add indexes
CREATE INDEX idx_books_title ON books USING gin(to_tsvector('english', title));

# Check query plans
\d+ books  # Show table structure and indexes
```

## Redis Issues

### Connection Problems

#### Problem: Redis Connection Refused
```bash
Error: connect ECONNREFUSED 127.0.0.1:6379
```

**Solution:**
```bash
# Check if Redis is running
redis-cli ping

# Start Redis
sudo systemctl start redis  # Linux
brew services start redis   # macOS

# Check Redis configuration
redis-cli info server
```

#### Problem: Redis Authentication Failed
```bash
Error: NOAUTH Authentication required
```

**Solution:**
```bash
# Check Redis password
redis-cli -a yourpassword ping

# Update .env file
REDIS_URL=redis://:password@localhost:6379

# Or disable auth in development
# Comment out requirepass in redis.conf
```

### Performance Issues

#### Problem: High Memory Usage
```bash
# Redis using too much memory
```

**Solution:**
```bash
# Check memory usage
redis-cli info memory

# Set memory limit
redis-cli config set maxmemory 1gb
redis-cli config set maxmemory-policy allkeys-lru

# Clear cache if needed
redis-cli flushall

# Monitor cache hit rate
redis-cli info stats | grep keyspace
```

#### Problem: Cache Misses
```bash
# Low cache hit rate
```

**Solution:**
```bash
# Check cache statistics
redis-cli info stats

# Increase TTL for stable data
const CACHE_TTL = 300; // 5 minutes instead of 60 seconds

# Monitor cache patterns
redis-cli monitor

# Optimize cache keys
// Use consistent naming patterns
const cacheKey = `books:search:${query.toLowerCase()}`;
```

## Authentication Issues

### JWT Token Problems

#### Problem: Token Expired
```bash
Error: jwt expired
```

**Solution:**
```javascript
// Client-side: Refresh token
const refreshToken = async () => {
  const response = await fetch('/api/auth/refresh');
  const { accessToken } = await response.json();
  // Store new token
};

// Server-side: Check token expiration
const isTokenExpired = (token) => {
  const decoded = jwt.decode(token);
  return Date.now() >= decoded.exp * 1000;
};
```

#### Problem: Invalid Token
```bash
Error: invalid token
```

**Solution:**
```bash
# Check JWT secrets match
echo $JWT_ACCESS_SECRET
echo $JWT_REFRESH_SECRET

# Verify token format
node -e "console.log(require('jsonwebtoken').decode('your-token'))"

# Clear cookies and login again
curl -b cookies.txt -c cookies.txt http://localhost:5000/api/auth/logout
```

### Session Issues

#### Problem: Session Not Persisting
```bash
# User logged out after browser refresh
```

**Solution:**
```javascript
// Check session configuration
app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production', // Only HTTPS in prod
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));

// Verify cookies are being set
// Check browser developer tools > Application > Cookies
```

## Performance Issues

### Slow Response Times

#### Problem: API Responses > 2 seconds
```bash
# Slow API responses
```

**Solution:**
```bash
# Enable response time logging
const responseTime = require('response-time');
app.use(responseTime());

# Profile with curl
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:5000/api/books

# Create curl-format.txt:
echo '     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n' > curl-format.txt
```

**Optimization strategies:**
```javascript
// Add caching
const cache = new Map();
const getCachedData = (key) => {
  if (cache.has(key)) {
    return cache.get(key);
  }
  // Fetch and cache data
};

// Optimize database queries
// Add indexes, use LIMIT, avoid N+1 queries

// Use compression
app.use(compression());

// Enable HTTP/2
// Use HTTPS with HTTP/2 support
```

### High Memory Usage

#### Problem: Memory usage > 1GB
```bash
# High memory consumption
```

**Solution:**
```bash
# Monitor memory usage
node --inspect src/server.ts
# Open chrome://inspect in Chrome

# Check for memory leaks
const v8 = require('v8');
console.log(v8.getHeapStatistics());

# Optimize code
// Avoid global variables
// Clear timers and intervals
// Remove event listeners
// Close database connections
```

## Docker Issues

### Build Problems

#### Problem: Docker Build Fails
```bash
Error: COPY failed: no source files were specified
```

**Solution:**
```bash
# Check Dockerfile paths
COPY package*.json ./  # Ensure files exist
COPY src/ ./src/       # Check directory structure

# Build with verbose output
docker build --progress=plain -t booklab-server .

# Check .dockerignore
cat .dockerignore
```

#### Problem: Permission Issues in Container
```bash
Error: EACCES: permission denied, open '/app/dist/server.js'
```

**Solution:**
```dockerfile
# Fix in Dockerfile
RUN chown -R nextjs:nodejs /usr/src/app
USER nextjs

# Or run as root temporarily
USER root
RUN chown -R nextjs:nodejs /usr/src/app
USER nextjs
```

### Runtime Problems

#### Problem: Container Exits Immediately
```bash
# Container stops right after starting
```

**Solution:**
```bash
# Check logs
docker logs booklab-server

# Run interactively
docker run -it booklab-server sh

# Check entrypoint
docker inspect booklab-server | grep -A5 -B5 Entrypoint

# Verify command
CMD ["node", "dist/server.js"]  # Ensure correct path
```

## Environment Issues

### Development vs Production

#### Problem: Works in Development, Fails in Production
```bash
# Code works locally but not in production
```

**Solution:**
```bash
# Check environment differences
echo $NODE_ENV
printenv | grep -E "(DATABASE|REDIS|JWT)"

# Test production build locally
NODE_ENV=production pnpm run build
NODE_ENV=production pnpm run start

# Check production-specific code
if (process.env.NODE_ENV === 'production') {
  // Production-only logic
}
```

### Configuration Issues

#### Problem: Environment Variables Not Loading
```bash
# Variables in .env not available
```

**Solution:**
```bash
# Check .env file location
ls -la .env

# Verify dotenv is loaded
require('dotenv').config();
console.log(process.env.DATABASE_URL);

# Check for syntax errors in .env
# No spaces around = sign
DATABASE_URL=postgresql://user:pass@host:port/db
```

## Debugging Tools

### Logging

```javascript
// Enhanced logging setup
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    new winston.transports.Console({
      format: winston.format.simple()
    })
  ]
});
```

### Request Debugging

```javascript
// Debug middleware
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);
  next();
});

// Response debugging
app.use((req, res, next) => {
  const originalSend = res.send;
  res.send = function(data) {
    console.log('Response:', data);
    originalSend.call(this, data);
  };
  next();
});
```

### Database Query Debugging

```javascript
// Log all database queries
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  log: (msg) => console.log('DB:', msg)
});

// Or use debug module
const debug = require('debug')('app:db');
debug('Executing query:', query);
```

## Getting Help

### Before Asking for Help

1. **Check logs** - Always include relevant log output
2. **Reproduce the issue** - Provide steps to reproduce
3. **Check environment** - Include environment details
4. **Try basic fixes** - Restart services, clear cache
5. **Search existing issues** - Check GitHub issues and Stack Overflow

### Information to Include

- **Environment**: OS, Node.js version, dependencies
- **Configuration**: Relevant environment variables (sanitized)
- **Logs**: Error messages and stack traces
- **Steps**: What you were trying to do
- **Expected vs Actual**: What should happen vs what happens

### Support Channels

- **GitHub Issues**: For bugs and feature requests
- **Stack Overflow**: For general programming questions
- **Discord/Slack**: For real-time help (if available)
- **Documentation**: Check README and API docs first

---

For more information, see:
- [README.md](./README.md) - Setup and usage
- [API_DOCUMENTATION.md](./API_DOCUMENTATION.md) - API reference
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Production deployment
