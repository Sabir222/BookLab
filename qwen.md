# Qwen Code Customization for BookLab

## Development Environment

### API Testing
- Use Postman to test API routes.
- Base URL for testing: `http://localhost:4000`
- Example test URL: `http://localhost:4000/api/books/new-releases?days=365&limit=10`

### cURL Testing
When creating new routes, always test them using cURL before considering them complete. Here's the standard format:

```bash
curl -X GET "http://localhost:4000/api/books/new-releases?days=365&limit=10" \
  -H "Accept: application/json"
```

Replace the method, URL, and headers as needed for each specific route.

## Build Commands

### Server (Express App)
To build the Express server located in `./apps/server/`:
```bash
pnpm build --filter=server
```

### Database Package
To build the database package located in `./packages/db/`:
```bash
pnpm build --filter=db
```

## Code Quality Guidelines

### Comments
- Minimize comments and only add them when absolutely necessary
- Add `// TODO:` for future improvements
- Add `// WARNING:` for potential issues
- Add `// PERF:` for performance considerations
- Add `// NOTE:` for important information

### Validation
- Use Zod for request validation
- Apply validation middleware in route definitions
- Example pattern: `router.post("/login", validate(schema), controller);`

## Future Improvements
- Continuously update this file with useful information discovered during development