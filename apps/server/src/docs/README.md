# BookLab API Documentation

## Accessing API Documentation

The BookLab API documentation is available through Swagger UI. After starting the server, you can access the documentation at:

```
http://localhost:4000/api/docs
```

## Starting the Server

To start the server in development mode:

```bash
pnpm dev
```

To start the server in production mode:

```bash
pnpm build
pnpm start
```

## API Endpoints

All API endpoints are prefixed with `/api`. The available endpoint categories are:

- `/api/auth` - Authentication endpoints
- `/api/books` - Book management endpoints
- `/api/users` - User management endpoints
- `/api/newsletter` - Newsletter subscription endpoints
- `/api/wishlist` - Wishlist management endpoints
- `/api/health` - Health check endpoints

## Authentication

Most endpoints require authentication using JWT tokens. After logging in, you'll receive an access token that should be included in the `Authorization` header as a Bearer token:

```
Authorization: Bearer <your-access-token>
```