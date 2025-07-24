packages/db/
├── src/
│ ├── index.ts # Main exports
│ ├── client.ts # Connection pool
│ ├── schema/ # Schema definitions
│ │ ├── users.sql
│ │ ├── posts.sql
│ │ └── index.ts
│ ├── migrations/ # Versioned changes only
│ │ ├── 001_initial_schema.sql
│ │ └── 002_add_post_tags.sql
│ ├── queries/ # Organized SQL queries
│ │ ├── users.ts
│ │ └── posts.ts
│ ├── seeds/ # Test/dev data
│ │ └── dev-data.sql
│ └── types.ts # TypeScript definitions
├── scripts/
│ ├── reset-db.ts # Full reset (dev only)
│ ├── migrate.ts # Run migrations
│ ├── seed.ts # Seed data
│ └── generate-types.ts # Auto-generate types
└── package.json
