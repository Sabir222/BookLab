# BookLab API Documentation

This document provides detailed information about all available API endpoints for the BookLab application.

## Base URL

All endpoints are relative to: `http://localhost:4000/api`

## Authentication Endpoints

### 1. Sign Up

**POST** `/api/auth/signup`

Create a new user account.

#### Request

- **Body Parameters**:
  - `email` (string, required): User's email address
  - `username` (string, required): Desired username
  - `password` (string, required): Password (min 8 characters)

#### Response

- **201 Created**: Returns user information and auth tokens
- **400 Bad Request**: Invalid request data
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X POST "http://localhost:4000/api/auth/signup" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "username": "testuser",
    "password": "SecurePass123!"
  }'
```

### 2. Login

**POST** `/api/auth/login`

Authenticate a user and receive access tokens.

#### Request

- **Body Parameters**:
  - `email` (string, required): User's email address
  - `password` (string, required): User's password

#### Response

- **200 OK**: Returns user information and auth tokens
- **400 Bad Request**: Invalid credentials
- **401 Unauthorized**: Authentication failed
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X POST "http://localhost:4000/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePass123!"
  }'
```

### 3. Get Current User

**GET** `/api/auth/me`

Retrieve information about the currently authenticated user.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token

#### Response

- **200 OK**: Returns current user information
- **401 Unauthorized**: Not authenticated
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/auth/me" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Logout

**GET** `/api/auth/logout`

Invalidate the current user's session.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token

#### Response

- **200 OK**: Successfully logged out
- **401 Unauthorized**: Not authenticated
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/auth/logout" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 5. Refresh Token

**GET** `/api/auth/refresh`

Refresh the authentication tokens.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer refresh token

#### Response

- **200 OK**: Returns new access and refresh tokens
- **401 Unauthorized**: Invalid or expired refresh token
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/auth/refresh" \
  -H "Authorization: Bearer YOUR_REFRESH_TOKEN"
```

## Public Book Endpoints

### 1. Get Book by ID

**GET** `/api/books/:id`

Retrieve a specific book by its unique ID.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book

#### Response

- **200 OK**: Returns the book details
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000"
```

### 2. Get All Books

**GET** `/api/books/`

Retrieve a list of all books with optional limit.

#### Request

- **Query Parameters**:
  - `limit` (integer, optional): Number of books to return (1-100, default: 50)

#### Response

- **200 OK**: Returns array of books
- **400 Bad Request**: Invalid limit parameter
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/?limit=20"
```

### 3. Search Books by Name

**GET** `/api/books/search`

Search for books by title using fuzzy matching.

#### Request

- **Query Parameters**:
  - `q` (string, required): Search query

#### Response

- **200 OK**: Returns matching books
- **400 Bad Request**: Missing or invalid search query
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/search?q=harry%20potter"
```

### 4. Search Books by Author

**GET** `/api/books/search/author`

Search for books by author name using fuzzy matching.

#### Request

- **Query Parameters**:
  - `q` (string, required): Author search query

#### Response

- **200 OK**: Returns books by matching authors
- **400 Bad Request**: Missing or invalid author search query
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/search/author?q=tolkien"
```

### 5. Search Books by Category

**GET** `/api/books/search/category`

Search for books by category name using fuzzy matching.

#### Request

- **Query Parameters**:
  - `q` (string, required): Category search query

#### Response

- **200 OK**: Returns books in matching categories
- **400 Bad Request**: Missing or invalid category search query
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/search/category?q=fiction"
```

### 6. Search Books by ISBN

**GET** `/api/books/search/isbn`

Search for books by ISBN using fuzzy matching.

#### Request

- **Query Parameters**:
  - `q` (string, required): ISBN search query

#### Response

- **200 OK**: Returns books with matching ISBNs
- **400 Bad Request**: Missing or invalid ISBN search query
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/search/isbn?q=9780545010221"
```

### 7. Get New Releases

**GET** `/api/books/new-releases`

Retrieve recently released books.

#### Request

- **Query Parameters**:
  - `days` (integer, optional): Number of days to look back (1-365, default: 30)
  - `limit` (integer, optional): Number of books to return (1-100, default: 20)

#### Response

- **200 OK**: Returns new release books
- **400 Bad Request**: Invalid days or limit parameter
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/new-releases?days=30&limit=10"
```

### 8. Get Related Books

**GET** `/api/books/:id/related`

Retrieve books related to a specific book based on categories.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the reference book

#### Response

- **200 OK**: Returns related books
- **400 Bad Request**: Missing book ID
- **404 Not Found**: Reference book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/related"
```

### 9. Filter Books

**GET** `/api/books/filter`

Filter books based on multiple criteria.

#### Request

- **Query Parameters**:
  - `title` (string, optional): Filter by title
  - `authorName` (string, optional): Filter by author name
  - `categoryName` (string, optional): Filter by category name
  - `minRating` (number, optional): Minimum average rating (0-5)
  - `maxPrice` (number, optional): Maximum sale price
  - `format` (string, optional): Filter by book format
  - `inStock` (boolean, optional): Filter by stock availability
  - `forSale` (boolean, optional): Filter by sale availability
  - `forRent` (boolean, optional): Filter by rent availability
  - `language` (string, optional): Filter by language
  - `publisherId` (string, optional): Filter by publisher ID
  - `publishedAfter` (string, optional): Filter by publication date (ISO format)
  - `publishedBefore` (string, optional): Filter by publication date (ISO format)
  - `limit` (integer, optional): Number of books to return (1-100, default: 20)
  - `offset` (integer, optional): Pagination offset (>= 0, default: 0)

#### Response

- **200 OK**: Returns filtered books
- **400 Bad Request**: Invalid filter parameters
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/filter?categoryName=fiction&minRating=4&limit=10"
```

### 10. Get Book by Slug

**GET** `/api/books/slug/:slug`

Retrieve a specific book by its slug.

#### Request

- **Path Parameters**:
  - `slug` (string, required): Unique slug of the book

#### Response

- **200 OK**: Returns the book details
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/slug/harry-potter-and-the-philosophers-stone"
```

### 11. Check if Book Exists

**GET** `/api/books/:id/exists`

Check if a book with the given ID exists.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book

#### Response

- **200 OK**: Returns existence status
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/exists"
```

## Book Management Endpoints

### 12. Create Book

**POST** `/api/books/`

Create a new book.

#### Request

- **Body Parameters**:
  - `title` (string, required): Book title
  - `bookFormat` (string, required): Format (hardcover, paperback, ebook, audiobook)
  - `forSale` (boolean, required): Available for sale
  - `forRent` (boolean, required): Available for rent
  - `priceSale` (number, required): Sale price
  - `stockQuantity` (integer, required): Available stock
  - `slug` (string, required): Unique slug for the book
  - Other optional fields as defined in the Book type

#### Response

- **201 Created**: Returns the created book
- **400 Bad Request**: Invalid request data
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X POST "http://localhost:4000/api/books/" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "The Great Gatsby",
    "bookFormat": "paperback",
    "forSale": true,
    "forRent": false,
    "priceSale": 12.99,
    "stockQuantity": 50,
    "slug": "the-great-gatsby"
  }'
```

### 13. Update Book

**PUT** `/api/books/:id`

Update an existing book.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book
- **Body Parameters**:
  - Any book fields that need to be updated

#### Response

- **200 OK**: Returns the updated book
- **400 Bad Request**: Invalid request data
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PUT "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000" \
  -H "Content-Type: application/json" \
  -d '{
    "priceSale": 14.99,
    "stockQuantity": 30
  }'
```

### 14. Delete Book

**DELETE** `/api/books/:id`

Permanently delete a book.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book

#### Response

- **200 OK**: Book deleted successfully
- **400 Bad Request**: Invalid book ID
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X DELETE "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000"
```

### 15. Soft Delete Book

**PATCH** `/api/books/:id/soft-delete`

Mark a book as deleted without removing it from the database.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book
- **Body Parameters**:
  - `deletedBy` (string, optional): UUID of the user who deleted the book

#### Response

- **200 OK**: Returns the soft-deleted book
- **400 Bad Request**: Invalid request data
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PATCH "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/soft-delete" \
  -H "Content-Type: application/json" \
  -d '{
    "deletedBy": "user-uuid"
  }'
```

### 16. Restore Book

**PATCH** `/api/books/:id/restore`

Restore a soft-deleted book.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book

#### Response

- **200 OK**: Returns the restored book
- **400 Bad Request**: Invalid book ID
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PATCH "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/restore"
```

### 17. Update Book Stock

**PATCH** `/api/books/:id/stock`

Update the stock quantity of a book.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book
- **Body Parameters**:
  - `newStock` (integer, required): New stock quantity (>= 0)
  - `reservedQuantity` (integer, optional): New reserved quantity

#### Response

- **200 OK**: Returns the updated book
- **400 Bad Request**: Invalid request data
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PATCH "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/stock" \
  -H "Content-Type: application/json" \
  -d '{
    "newStock": 25,
    "reservedQuantity": 5
  }'
```

### 18. Add to Book Stock

**PATCH** `/api/books/:id/stock/add`

Increase the stock quantity of a book.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book
- **Body Parameters**:
  - `quantity` (integer, required): Quantity to add (>= 1)

#### Response

- **200 OK**: Returns the updated book
- **400 Bad Request**: Invalid request data
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PATCH "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/stock/add" \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 10
  }'
```

### 19. Reserve Books

**PATCH** `/api/books/:id/stock/reserve`

Reserve a quantity of books.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book
- **Body Parameters**:
  - `quantity` (integer, required): Quantity to reserve (>= 1)

#### Response

- **200 OK**: Returns the updated book
- **400 Bad Request**: Invalid request data
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PATCH "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/stock/reserve" \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 3
  }'
```

### 20. Release Reserved Books

**PATCH** `/api/books/:id/stock/release`

Release a quantity of reserved books.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book
- **Body Parameters**:
  - `quantity` (integer, required): Quantity to release (>= 1)

#### Response

- **200 OK**: Returns the updated book
- **400 Bad Request**: Invalid request data
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PATCH "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/stock/release" \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 2
  }'
```

### 21. Update Book Ratings

**PATCH** `/api/books/:id/ratings`

Update the ratings of a book.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the book
- **Body Parameters**:
  - `averageRating` (number, required): New average rating (0-5)
  - `totalRatings` (integer, required): New total ratings count (>= 0)

#### Response

- **200 OK**: Returns the updated book
- **400 Bad Request**: Invalid request data
- **404 Not Found**: Book not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PATCH "http://localhost:4000/api/books/123e4567-e89b-12d3-a456-426614174000/ratings" \
  -H "Content-Type: application/json" \
  -d '{
    "averageRating": 4.5,
    "totalRatings": 120
  }'
```

## User Management Endpoints

### 22. Get User by ID

**GET** `/api/users/:id`

Retrieve a user's public profile by their ID.

#### Request

- **Path Parameters**:
  - `id` (string, required): UUID of the user

#### Response

- **200 OK**: Returns the user's public profile
- **404 Not Found**: User not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/users/123e4567-e89b-12d3-a456-426614174000"
```

### 23. Get Current User Profile

**GET** `/api/users/me`

Retrieve the current authenticated user's profile.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token

#### Response

- **200 OK**: Returns the current user's profile
- **401 Unauthorized**: Not authenticated
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/users/me" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 24. Update User Profile

**PUT** `/api/users/me`

Update the current user's profile information.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token
- **Body Parameters**:
  - `username` (string, optional): New username (3-30 characters)
  - `email` (string, optional): New email address
  - `profileImageUrl` (string, optional): URL to profile image

#### Response

- **200 OK**: Returns the updated user profile
- **400 Bad Request**: Invalid request data
- **401 Unauthorized**: Not authenticated
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PUT "http://localhost:4000/api/users/me" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newusername",
    "email": "newemail@example.com"
  }'
```

### 25. Change Password

**PUT** `/api/users/me/password`

Change the current user's password.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token
- **Body Parameters**:
  - `currentPassword` (string, required): Current password
  - `newPassword` (string, required): New password (min 8 characters, with complexity)
  - `confirmNewPassword` (string, required): Confirmation of new password

#### Response

- **200 OK**: Password updated successfully
- **400 Bad Request**: Invalid request data or password mismatch
- **401 Unauthorized**: Not authenticated
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PUT "http://localhost:4000/api/users/me/password" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "currentPassword": "oldpassword123",
    "newPassword": "NewPassword123!",
    "confirmNewPassword": "NewPassword123!"
  }'
```

### 26. Delete User Account

**DELETE** `/api/users/me`

Delete the current user's account.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token
- **Body Parameters**:
  - `password` (string, required): Current password for confirmation

#### Response

- **200 OK**: Account deleted successfully
- **400 Bad Request**: Invalid password
- **401 Unauthorized**: Not authenticated
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X DELETE "http://localhost:4000/api/users/me" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "password": "currentpassword123"
  }'
```

### 27. List Users (Admin)

**GET** `/api/users/`

List all users (admin only).

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token (admin)
- **Query Parameters**:
  - `limit` (integer, optional): Number of users to return (1-100, default: 50)
  - `offset` (integer, optional): Pagination offset (>= 0, default: 0)
  - `role` (string, optional): Filter by user role

#### Response

- **200 OK**: Returns list of users
- **401 Unauthorized**: Not authenticated
- **403 Forbidden**: Insufficient permissions
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/users/?limit=20&offset=0" \
  -H "Authorization: Bearer YOUR_ADMIN_ACCESS_TOKEN"
```

### 28. Admin Update User

**PUT** `/api/users/:id`

Update any user's information (admin only).

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token (admin)
- **Path Parameters**:
  - `id` (string, required): UUID of the user to update
- **Body Parameters**:
  - `username` (string, optional): New username (3-30 characters)
  - `email` (string, optional): New email address
  - `profileImageUrl` (string, optional): URL to profile image
  - `role` (string, optional): New role (user, admin, moderator)
  - `isVerified` (boolean, optional): Verification status
  - `credits` (number, optional): User credits
  - `loyaltyPoints` (number, optional): User loyalty points

#### Response

- **200 OK**: Returns the updated user profile
- **400 Bad Request**: Invalid request data
- **401 Unauthorized**: Not authenticated
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: User not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X PUT "http://localhost:4000/api/users/123e4567-e89b-12d3-a456-426614174000" \
  -H "Authorization: Bearer YOUR_ADMIN_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "role": "moderator",
    "isVerified": true
  }'
```

### 29. Admin Delete User

**DELETE** `/api/users/:id`

Delete any user's account (admin only).

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token (admin)
- **Path Parameters**:
  - `id` (string, required): UUID of the user to delete

#### Response

- **200 OK**: User deleted successfully
- **401 Unauthorized**: Not authenticated
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: User not found
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X DELETE "http://localhost:4000/api/users/123e4567-e89b-12d3-a456-426614174000" \
  -H "Authorization: Bearer YOUR_ADMIN_ACCESS_TOKEN"
```

## Newsletter Endpoints

### 30. Subscribe to Newsletter

**POST** `/api/newsletter/subscribe`

Subscribe an email address to the newsletter.

#### Request

- **Body Parameters**:
  - `email` (string, required): Email address to subscribe

#### Response

- **201 Created**: Successfully subscribed to newsletter
- **400 Bad Request**: Invalid email format or missing email
- **409 Conflict**: Email already subscribed
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X POST "http://localhost:4000/api/newsletter/subscribe" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "subscriber@example.com"
  }'
```

### 31. Unsubscribe from Newsletter

**POST** `/api/newsletter/unsubscribe`

Unsubscribe an email address from the newsletter.

#### Request

- **Body Parameters**:
  - `email` (string, required): Email address to unsubscribe

#### Response

- **200 OK**: Successfully unsubscribed from newsletter
- **400 Bad Request**: Invalid email format or missing email
- **404 Not Found**: Email not found in subscribers
- **409 Conflict**: Email already unsubscribed
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X POST "http://localhost:4000/api/newsletter/unsubscribe" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "subscriber@example.com"
  }'
```

## Wishlist Endpoints

### 32. Add Book to Wishlist

**POST** `/api/wishlist/add`

Add a book to the authenticated user's wishlist.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token
- **Body Parameters**:
  - `book_id` (string, required): UUID of the book to add

#### Response

- **201 Created**: Book added to wishlist successfully
- **400 Bad Request**: Invalid book ID format or missing book ID
- **401 Unauthorized**: Not authenticated
- **404 Not Found**: Book not found
- **409 Conflict**: Book already in wishlist
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X POST "http://localhost:4000/api/wishlist/add" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "book_id": "123e4567-e89b-12d3-a456-426614174000"
  }'
```

### 33. Remove Book from Wishlist

**POST** `/api/wishlist/remove`

Remove a book from the authenticated user's wishlist.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token
- **Body Parameters**:
  - `book_id` (string, required): UUID of the book to remove

#### Response

- **200 OK**: Book removed from wishlist successfully
- **400 Bad Request**: Invalid book ID format or missing book ID
- **401 Unauthorized**: Not authenticated
- **404 Not Found**: Book not in wishlist
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X POST "http://localhost:4000/api/wishlist/remove" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "book_id": "123e4567-e89b-12d3-a456-426614174000"
  }'
```

### 34. Get User's Wishlist

**GET** `/api/wishlist/`

Retrieve all books in the authenticated user's wishlist.

#### Request

- **Headers**:
  - `Authorization` (string, required): Bearer token

#### Response

- **200 OK**: Returns user's wishlist
- **401 Unauthorized**: Not authenticated
- **500 Internal Server Error**: Server error

#### Example

```bash
curl -X GET "http://localhost:4000/api/wishlist/" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Common Response Formats

### Success Response

```json
{
  "success": true,
  "data": {...}
}
```

### Error Response

```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

## Error Codes

- `BOOK_NOT_FOUND`: The requested book was not found
- `INVALID_LIMIT`: Invalid limit parameter
- `INVALID_SEARCH_QUERY`: Invalid search query
- `INVALID_AUTHOR_QUERY`: Invalid author search query
- `INVALID_CATEGORY_QUERY`: Invalid category search query
- `INVALID_ISBN_QUERY`: Invalid ISBN search query
- `INVALID_DAYS`: Invalid days parameter
- `INVALID_OFFSET`: Invalid offset parameter
- `INTERNAL_SERVER_ERROR`: Generic server error
- `CREATE_BOOK_ERROR`: Error creating book
- `UPDATE_BOOK_ERROR`: Error updating book
- `DELETE_BOOK_ERROR`: Error deleting book
- `SOFT_DELETE_BOOK_ERROR`: Error soft deleting book
- `RESTORE_BOOK_ERROR`: Error restoring book
- `BOOK_EXISTS_ERROR`: Error checking book existence
- `GET_BOOK_BY_SLUG_ERROR`: Error getting book by slug
- `UPDATE_BOOK_STOCK_ERROR`: Error updating book stock
- `ADD_TO_BOOK_STOCK_ERROR`: Error adding to book stock
- `RESERVE_BOOKS_ERROR`: Error reserving books
- `RELEASE_RESERVED_BOOKS_ERROR`: Error releasing reserved books
- `UPDATE_BOOK_RATINGS_ERROR`: Error updating book ratings
- `UNAUTHORIZED`: Authentication required
- `USER_NOT_FOUND`: The requested user was not found
- `GET_USER_ERROR`: Error getting user
- `UPDATE_USER_ERROR`: Error updating user profile
- `CHANGE_PASSWORD_ERROR`: Error changing password
- `DELETE_USER_ERROR`: Error deleting user account
- `LIST_USERS_ERROR`: Error listing users
- `ADMIN_UPDATE_USER_ERROR`: Error updating user (admin)
- `ADMIN_DELETE_USER_ERROR`: Error deleting user (admin)
- `MISSING_EMAIL`: Email is required for newsletter subscription
- `INVALID_EMAIL`: Invalid email format
- `ALREADY_SUBSCRIBED`: Email is already subscribed to the newsletter
- `EMAIL_NOT_FOUND`: Email not found in newsletter subscribers
- `ALREADY_UNSUBSCRIBED`: Email is already unsubscribed from the newsletter
- `MISSING_BOOK_ID`: Book ID is required for wishlist operations
- `INVALID_BOOK_ID`: Invalid book ID format
- `BOOK_ALREADY_IN_WISHLIST`: Book is already in the user's wishlist
- `BOOK_NOT_IN_WISHLIST`: Book is not in the user's wishlist
- `REMOVE_FROM_WISHLIST_FAILED`: Failed to remove book from wishlist

## Rate Limiting

All endpoints are subject to rate limiting to prevent abuse. Excessive requests may result in temporary blocking.

