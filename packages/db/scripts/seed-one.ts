#!/usr/bin/env node
import { db } from "../src/postgres/client.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";

const __dirname = dirname(fileURLToPath(import.meta.url));

async function seedSingleFile(fileName: string) {
  const seedsDir = path.join(__dirname, "../src/postgres/seeds");
  const seedPath = path.join(seedsDir, fileName);

  try {
    console.log(`Seeding database with file: ${fileName}...`);

    // Check if the seeds directory exists
    if (!fs.existsSync(seedsDir)) {
      throw new Error(`Seeds directory not found: ${seedsDir}`);
    }

    // Check if the file exists
    if (!fs.existsSync(seedPath)) {
      throw new Error(`Seed file not found: ${seedPath}`);
    }

    // Check if the file is a .sql file
    if (!fileName.endsWith(".sql")) {
      throw new Error(`File must be a .sql file: ${fileName}`);
    }

    console.log(`Seeding ${fileName}...`);

    try {
      const seedSql = fs.readFileSync(seedPath, "utf8");

      // Extract only the INSERT statements for the books table
      const booksInsertRegex = /INSERT INTO books \([^)]*\) VALUES [\s\S]*?;/g;
      const booksInsertMatches = seedSql.match(booksInsertRegex);

      if (booksInsertMatches) {
        for (const insertStatement of booksInsertMatches) {
          await db.query(insertStatement);
        }
        console.log(`Seeded books from ${fileName} successfully.`);
      } else {
        console.log(`No books INSERT statements found in ${fileName}.`);
      }
    } catch (fileError: any) {
      console.error(`Error seeding ${fileName}:`, fileError.message);
      throw new Error(
        `Seeding failed for file ${fileName}: ${fileError.message}`,
        { cause: fileError },
      );
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

// Get the file name from command line arguments
const args = process.argv.slice(2);
if (args.length === 0) {
  console.error("Please provide a seed file name as an argument.");
  console.error("Usage: tsx seed-one.ts <file-name.sql>");
  process.exit(1);
}

const fileName = args[0];
seedSingleFile(fileName);

