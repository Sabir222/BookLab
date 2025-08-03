export { db, getConnection, testConnection } from "./client.js";
export { createTables } from "./schema/index.js";
export { bookQueries } from "./queries/books.js";
export { userQueries } from "./queries/users.js";
export * from "./types/user-types.js";
export * from "./types/book-types.js";
