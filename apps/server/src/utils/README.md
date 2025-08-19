# BookLab API Response Handler

This utility provides standardized response formats for all API endpoints in the BookLab application.

## Installation

The response handler is already included in the project. To use it in your controllers:

```typescript
import { sendSuccess, sendError, sendCreated } from "../utils/responseHandler.js";
```

## Usage

### Success Responses

#### Basic Success
```typescript
return sendSuccess(res, { user: userData });
```

#### Success with Message
```typescript
return sendSuccess(res, { user: userData }, "User profile updated successfully");
```

#### Success with Metadata
```typescript
return sendSuccess(res, { books: bookData }, undefined, 200, { cached: true });
```

### Created Responses
```typescript
return sendCreated(res, { user: newUser }, "User created successfully");
```

### Error Responses
```typescript
return sendError(res, "Invalid email format", "INVALID_EMAIL", 400);
```

## Response Formats

### Success Response Structure
```json
{
  "success": true,
  "message": "Optional success message",
  "data": {...},
  "meta": {...}
}
```

### Error Response Structure
```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE",
  "message": "Optional additional message"
}
```

## Available Functions

### `sendSuccess(res, data, message?, statusCode?, meta?)`
Sends a success response with the specified data.

### `sendCreated(res, data, message?)`
Sends a 201 Created response with the specified data.

### `sendError(res, error, code, statusCode?, message?)`
Sends an error response with the specified error message and code.

### `sendNoContent(res)`
Sends a 204 No Content response.

### `createPaginationMeta(limit, offset, total?)`
Helper function to create pagination metadata.