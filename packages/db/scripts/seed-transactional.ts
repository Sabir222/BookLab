#!/usr/bin/env node
import { db } from "../src/postgres/client.js";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function seedDatabase() {
  console.log("Starting database seeding...");

  const client = await db.getClient();
  
  try {
    await client.query("BEGIN");
    
    // Get all seed files and sort them numerically
    const seedDirectory = path.join(__dirname, "../src/postgres/seeds");
    const seedFiles = (await fs.readdir(seedDirectory))
      .filter(file => file.endsWith(".sql") && file.startsWith("seed_data_"))
      .sort((a, b) => {
        const numA = parseInt(a.match(/\d+/)?.[0] || "0", 10);
        const numB = parseInt(b.match(/\d+/)?.[0] || "0", 10);
        return numA - numB;
      });
    
    console.log(`Found ${seedFiles.length} seed files`);
    
    for (const file of seedFiles) {
      console.log(`Executing ${file}...`);
      const filePath = path.join(seedDirectory, file);
      const sql = await fs.readFile(filePath, "utf-8");
      
      // Split the SQL file into individual statements
      // This is a simple splitter and might need to be more sophisticated
      // for complex SQL files with semicolons in strings or comments
      const statements = sql
        .split(";")
        .map(stmt => stmt.trim())
        .filter(stmt => stmt.length > 0);
      
      for (const statement of statements) {
        if (statement.toUpperCase().startsWith("SELECT")) {
          // Skip SELECT statements as they don't modify data
          continue;
        }
        // Skip empty statements or comments
        if (statement.trim() === "" || statement.trim().startsWith("--")) {
          continue;
        }
        await client.query(statement);
      }
      
      console.log(`Completed ${file}`);
    }
    
    await client.query("COMMIT");
    console.log("All seeds executed successfully!");
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error occurred during seeding. Transaction rolled back.");
    throw error;
  } finally {
    client.release();
    await db.end();
  }
}

// Run the seeding function
seedDatabase()
  .then(() => {
    console.log("Seeding process finished.");
    process.exit(0);
  })
  .catch((error) => {
    console.error("Seeding process failed:", error);
    process.exit(1);
  });