import { Pool, type PoolClient } from "pg";
import dotenv from "dotenv";
dotenv.config();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: Number(process.env.DB_PORT),
  max: 20,

  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

export const db = {
  query: (text: string, params?: any[]) => pool.query(text, params),
  getClient: () => pool.connect(),
  end: () => pool.end(),

  //TODO: better check health  this just tempo
  async isHealthy(): Promise<boolean> {
    try {
      await pool.query("SELECT 1");
      return true;
    } catch (error) {
      console.error("Database health check failed:", error);
      return false;
    }
  },
};

export const getConnection = async (): Promise<PoolClient> => {
  return await pool.connect();
};

export const testConnection = async (): Promise<void> => {
  const isHealthy = await db.isHealthy();
  if (isHealthy) {
    console.log("✅ Database is running");
  } else {
    console.error("❌ Database is not running");
  }
};

process.on("SIGINT", async () => {
  try {
    console.log("Closing database pool...");
    await pool.end();
    console.log("Database pool closed");
    process.exit(0);
  } catch (error) {
    console.error("Error closing database pool:", error);
    process.exit(1);
  }
});
