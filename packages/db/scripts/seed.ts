#!/usr/bin/env node
import { db } from "../src/postgres/client.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";

const __dirname = dirname(fileURLToPath(import.meta.url));

async function seedDatabase() {
  const seedsDir = path.join(__dirname, "../src/postgres/seeds");
  
  try {
    console.log("Seeding database...");
    
    // Check if the seeds directory exists
    if (!fs.existsSync(seedsDir)) {
      throw new Error(`Seeds directory not found: ${seedsDir}`);
    }

    // Get all .sql files from the seeds directory
    const seedFiles = fs.readdirSync(seedsDir)
      .filter(file => file.endsWith('.sql'))
      .sort(); // Sorting ensures consistent order (e.g., authors.sql before books.sql if that matters)
      
    console.log(`Found ${seedFiles.length} seed files.`);

    // Execute each seed file
    for (const file of seedFiles) {
      const seedPath = path.join(seedsDir, file);
      console.log(`Seeding ${file}...`);
      
      try {
        const seedSql = fs.readFileSync(seedPath, "utf8");
        // Split by semicolon to handle multiple statements if needed, though pg-query-stream might be better for large files
        // For simplicity, we'll execute the whole file content. If issues arise with large files, we can split by ';'.
        await db.query(seedSql);
        console.log(`Seeded ${file} successfully.`);
      } catch (fileError: any) {
        console.error(`Error seeding ${file}:`, fileError.message);
        throw new Error(`Seeding failed for file ${file}: ${fileError.message}`, { cause: fileError });
      }
    }
    
    console.log("Database seeded successfully!");
  } catch (error: any) {
    console.error("Seeding failed:", error.message);
    console.error("Details:", error.cause?.message || "No additional details");
    process.exit(1);
  } finally {
    await db.end();
  }
}

seedDatabase();