# BookLab API Documentation

This document provides detailed information about all available API endpoints for the BookLab application.

## Base URL

All endpoints are relative to: `http://localhost:4000/api/books`

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
  - `bookFormat` (string, required): Format (hardcover, paperback, ebook, audiobook, other)
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

## Rate Limiting

All endpoints are subject to rate limiting to prevent abuse. Excessive requests may result in temporary blocking.