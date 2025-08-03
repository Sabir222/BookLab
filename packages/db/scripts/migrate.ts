#!/usr/bin/env node
import { db } from "../src/client.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";

const __dirname = dirname(fileURLToPath(import.meta.url));

async function runMigrations() {
  try {
    console.log("Running database migrations...");

    await db.query(`
      CREATE TABLE IF NOT EXISTS schema_migrations (
        version VARCHAR(255) PRIMARY KEY,
        applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );
    `);

    const appliedResult = await db.query(
      "SELECT version FROM schema_migrations ORDER BY version",
    );
    const appliedMigrations = new Set(
      appliedResult.rows.map((row) => row.version),
    );

    const migrationsDir = path.join(__dirname, "../src/migrations");
    const migrationFiles = fs
      .readdirSync(migrationsDir)
      .filter((file) => file.endsWith(".sql"))
      .sort();

    for (const file of migrationFiles) {
      const version = file.replace(".sql", "");

      if (appliedMigrations.has(version)) {
        console.log(`Skipping ${version} (already applied)`);
        continue;
      }

      console.log(`Running migration ${version}...`);

      const migrationPath = path.join(migrationsDir, file);
      const sql = fs.readFileSync(migrationPath, "utf8");

      await db.query(sql);
      console.log(`Applied migration ${version}`);
    }

    console.log("All migrations completed!");
  } catch (error) {
    console.error("Migration failed:", error);
    process.exit(1);
  } finally {
    await db.end();
  }
}

runMigrations();
