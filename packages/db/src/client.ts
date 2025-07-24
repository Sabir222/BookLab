import { Pool, PoolClient } from "pg";

const pool = new Pool({
  user: process.env.DB_USER || "sabir",
  host: process.env.DB_HOST || "localhost",
  database: process.env.DB_NAME || "booklab_db",
  password: process.env.DB_PW || "pw",
  port: Number(process.env.DB_PORT) || 5432,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

export const db = {
  query: (text: string, params?: any[]) => pool.query(text, params),
  getClient: () => pool.connect(),
  end: () => pool.end(),
};

export const getConnection = async (): Promise<PoolClient> => {
  return await pool.connect();
};

// Graceful shutdown
process.on("SIGINT", async () => {
  await pool.end();
  process.exit(0);
});
