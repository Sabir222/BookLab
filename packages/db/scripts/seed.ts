#!/usr/bin/env node
import { db } from "../src/client.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";

const __dirname = dirname(fileURLToPath(import.meta.url));

async function seedDatabase() {
  try {
    console.log("🌱 Seeding database...");

    const seedPath = path.join(__dirname, "../src/seeds/dev-data2.sql");
    const seedSql = fs.readFileSync(seedPath, "utf8");

    await db.query(seedSql);
    console.log("✅ Database seeded successfully!");
  } catch (error) {
    console.error("❌ Seeding failed:", error);
    process.exit(1);
  } finally {
    await db.end();
  }
}

seedDatabase();
