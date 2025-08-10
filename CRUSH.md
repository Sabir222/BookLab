# CRUSH.md - Development Guide

## Build/Lint/Test Commands
- `pnpm run build` - Build all packages
- `pnpm run lint` - Lint all packages
- `pnpm run test` - Run all tests
- `pnpm test -w packages/db` - Run tests for specific package (db in this example)
- `pnpm test packages/db/src/postgres/queries/books.test.ts` - Run a single test file

## Code Style Guidelines
- **Imports**: Group imports by type (external, internal, types) with empty line between groups
- **Formatting**: Prettier is used - run `pnpm run format` to format code
- **Types**: Always use TypeScript types - avoid `any` or untyped responses
- **Naming**:
  - Variables/functions: camelCase
  - Types/Interfaces: PascalCase
  - Constants: UPPER_CASE_SNAKE
- **Error Handling**:
  - Use structured errors with clear error codes
  - Document thrown errors in JSDoc
  - Prefer async/await over callbacks

## Repository Structure
- `/packages` - Shared packages (db, ui, types)
- `/apps` - Main applications (server, web, docs)
- Global commands use Turbo for cross-package operations