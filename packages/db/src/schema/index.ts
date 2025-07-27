import fs from "fs";
import path from "path";
import { db } from "../client.js";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const createTables = async (): Promise<void> => {
  const schemaDir = __dirname;
  const sqlFiles = [
    "extensions.sql",
    "users.sql",
    "authors.sql",
    "publishers.sql",
  ];

  for (const file of sqlFiles) {
    const filePath = path.join(schemaDir, file);
    const sql = fs.readFileSync(filePath, "utf8");

    try {
      await db.query(sql);
      console.log(`✅ Created tables from ${file}`);
    } catch (error) {
      console.error(`❌ Error creating tables from ${file}:`, error);
      throw error;
    }
  }
};
