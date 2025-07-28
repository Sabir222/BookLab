```sql
1. users           ← No dependencies
2. authors         ← No dependencies
3. publishers      ← No dependencies
4. categories      ← Self-referencing (can be empty initially)
5. genres          ← Self-referencing (can be empty initially)
6. book_series     ← No dependencies
7. books           ← References: users, publishers, categories
8. book_authors    ← References: books, authors
9. book_categories ← References: books, categories
10. book_genres    ← References: books, genres
11. book_series_entries ← References: books, book_series
12. book_reviews   ← References: books, users
```

## Users Table Relationships:

- **users → books (as owner)** — One user owns many books
- **users → books (as creator)** — One user creates many book records
- **users → books (as modifier)** — One user modifies many books
- **users → books (as deleter)** — One user deletes many books
- **users → book_reviews** — One user writes many reviews

## Books Table Relationships:

- **publishers → books** — One publisher publishes many books
- **categories → books (primary)** — One category is primary for many books
- **books → book_reviews** — One book receives many reviews
- **books ↔ authors (via book_authors)** — Many-to-many
- **books ↔ categories (via book_categories)** — Many-to-many
- **books ↔ genres (via book_genres)** — Many-to-many
- **books ↔ book_series (via book_series_entries)** — Many-to-many

## Self-Referencing Relationships:

- **categories → categories** (parent-child hierarchy)
- **genres → genres** (parent-child hierarchy)

### self-referencing table example:

```text
Fiction (parent_category_id: NULL)
├── Mystery & Thriller (parent_category_id: Fiction ID)
├── Romance (parent_category_id: Fiction ID)
├── Science Fiction & Fantasy (parent_category_id: Fiction ID)
│ ├── Epic Fantasy (parent_category_id: Science Fiction & Fantasy ID)
│ ├── Space Opera (parent_category_id: Science Fiction & Fantasy ID)
│ └── Urban Fantasy (parent_category_id: Science Fiction & Fantasy ID)
└── Historical Fiction (parent_category_id: Fiction ID)
```

### Database-Docker:

```bash
docker run --name booklab-db \
 -e POSTGRES_USER=sabir \
 -e POSTGRES_PASSWORD=pw \
 -e POSTGRES_DB=booklab_db \
 -p 5432:5432 \
 -v booklab_pgdata:/var/lib/postgresql/data \
 -d postgres
```
