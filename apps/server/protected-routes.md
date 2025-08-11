# Protected Routes in BookLab API

This document lists all the routes in the BookLab API that require authentication middleware protection.

## Authentication Routes

These routes are related to user authentication but don't necessarily require protection themselves:

- `POST /api/auth/signup` - Public route for user registration
- `POST /api/auth/login` - Public route for user login
- `GET /api/auth/me` - **Requires authentication** - Get current user info
- `GET /api/auth/logout` - **Requires authentication** - Log out current user
- `GET /api/auth/refresh` - **Requires authentication** - Refresh tokens

## User Management Routes

All user management routes except getting a user by ID require authentication:

- `GET /api/users/:id` - Public route to get user by ID
- `GET /api/users/me` - **Requires authentication** - Get current user profile
- `PUT /api/users/me` - **Requires authentication** - Update current user profile
- `PUT /api/users/me/password` - **Requires authentication** - Change password
- `DELETE /api/users/me` - **Requires authentication** - Delete user account
- `GET /api/users/` - **Requires authentication** - List users (admin)
- `PUT /api/users/:id` - **Requires authentication** - Admin update user
- `DELETE /api/users/:id` - **Requires authentication** - Admin delete user

## Book Management Routes

All book management routes require authentication as they modify data:

- `POST /api/books/` - **Requires authentication** - Create a new book
- `PUT /api/books/:id` - **Requires authentication** - Update a book
- `DELETE /api/books/:id` - **Requires authentication** - Delete a book
- `PATCH /api/books/:id/soft-delete` - **Requires authentication** - Soft delete a book
- `PATCH /api/books/:id/restore` - **Requires authentication** - Restore a book
- `PATCH /api/books/:id/stock` - **Requires authentication** - Update book stock
- `PATCH /api/books/:id/stock/add` - **Requires authentication** - Add to book stock
- `PATCH /api/books/:id/stock/reserve` - **Requires authentication** - Reserve books
- `PATCH /api/books/:id/stock/release` - **Requires authentication** - Release reserved books
- `PATCH /api/books/:id/ratings` - **Requires authentication** - Update book ratings

## Public Book Routes

These routes are public and don't require authentication:

- `GET /api/books/:id` - Get book by ID
- `GET /api/books/` - Get all books
- `GET /api/books/search` - Search books by name
- `GET /api/books/search/author` - Search books by author
- `GET /api/books/search/category` - Search books by category
- `GET /api/books/search/isbn` - Search books by ISBN
- `GET /api/books/new-releases` - Get new releases
- `GET /api/books/:id/related` - Get related books
- `GET /api/books/filter` - Filter books
- `GET /api/books/slug/:slug` - Get book by slug
- `GET /api/books/:id/exists` - Check if book exists

## Summary

Routes that require authentication middleware:
1. `GET /api/auth/me`
2. `GET /api/auth/logout`
3. `GET /api/auth/refresh`
4. All routes under `/api/users/` except `GET /api/users/:id`
5. All routes under `/api/books/` that modify data (POST, PUT, DELETE, PATCH)

When implementing the authentication middleware, you should:
1. Apply it to the protected routes listed above
2. Extract user information from the JWT token
3. Attach the user information to the request object for use in controllers
4. Handle expired or invalid tokens appropriately