import fs from "fs";
import path from "path";
import { db } from "../client.js";

export const createTables = async (): Promise<void> => {
  const schemaDir = __dirname;
  const sqlFiles = ["users.sql"];

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
