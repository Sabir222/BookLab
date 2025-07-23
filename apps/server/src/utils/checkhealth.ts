import pool from "@repo/db/db";

const checkDbConnection = async () => {
  try {
    const res = await pool.query("SELECT NOW()");
    console.log("Database connected:", res.rows[0]);
  } catch (err) {
    console.error("Database connection error:", err);
  }
};

export default checkDbConnection;
