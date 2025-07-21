import pool from "./db";

const createUserTable = async () => {
  const query = `
CREATE TABLE IF NOT EXISTS users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE,
  email VARCHAR(255) UNIQUE,
  hashed_password VARCHAR(255),
  profile_image_url TEXT,
  credits INT DEFAULT 0,
  loyalty_points INT DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  role VARCHAR(50) DEFAULT 'user',
  last_login TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

 `;
  try {
    await pool.query(query);
    console.log("User Table created");
  } catch (error) {
    console.log("Error creating user table", error);
  }
};

export default createUserTable;
