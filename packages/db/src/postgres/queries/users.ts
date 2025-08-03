import { db } from "../client.js";
import {
  type User,
  type CreateUserData,
  type UpdateUserData,
} from "../types.js";

export const userQueries = {
  async findById(userId: string): Promise<User | null> {
    const result = await db.query("SELECT * FROM users WHERE user_id = $1", [
      userId,
    ]);
    return result.rows[0] || null;
  },

  async findByEmail(email: string): Promise<User | null> {
    const result = await db.query("SELECT * FROM users WHERE email = $1", [
      email,
    ]);
    return result.rows[0] || null;
  },

  async findByUsername(username: string): Promise<User | null> {
    const result = await db.query("SELECT * FROM users WHERE username = $1", [
      username,
    ]);
    return result.rows[0] || null;
  },

  async create(userData: CreateUserData): Promise<User> {
    const result = await db.query(
      `INSERT INTO users (username, email, hashed_password, profile_image_url, credits, loyalty_points, role)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [
        userData.username,
        userData.email,
        userData.hashedPassword,
        userData.profileImageUrl,
        userData.credits || 0,
        userData.loyaltyPoints || 0,
        userData.role || "user",
      ],
    );
    return result.rows[0];
  },

  async update(userId: string, userData: UpdateUserData): Promise<User | null> {
    const fields: string[] = [];
    const values: any[] = [];
    let paramCount = 1;

    const fieldMap: Record<string, string> = {
      username: "username",
      email: "email",
      hashedPassword: "hashed_password",
      profileImageUrl: "profile_image_url",
      credits: "credits",
      loyaltyPoints: "loyalty_points",
      isVerified: "is_verified",
      role: "role",
      lastLogin: "last_login",
    };

    Object.entries(userData).forEach(([key, value]) => {
      if (value !== undefined && fieldMap[key]) {
        fields.push(`${fieldMap[key]} = $${paramCount}`);
        values.push(value);
        paramCount++;
      }
    });

    if (fields.length === 0) return null;

    values.push(userId);

    const result = await db.query(
      `UPDATE users SET ${fields.join(", ")} WHERE user_id = $${paramCount} RETURNING *`,
      values,
    );
    return result.rows[0] || null;
  },

  async delete(userId: string): Promise<boolean> {
    const result = await db.query("DELETE FROM users WHERE user_id = $1", [
      userId,
    ]);
    return (result.rowCount ?? 0) > 0;
  },

  async list(limit = 50, offset = 0): Promise<User[]> {
    const result = await db.query(
      "SELECT * FROM users ORDER BY created_at DESC LIMIT $1 OFFSET $2",
      [limit, offset],
    );
    return result.rows;
  },

  async updateCredits(userId: string, credits: number): Promise<User | null> {
    const result = await db.query(
      "UPDATE users SET credits = $1 WHERE user_id = $2 RETURNING *",
      [credits, userId],
    );
    return result.rows[0] || null;
  },

  async addCredits(userId: string, amount: number): Promise<User | null> {
    const result = await db.query(
      "UPDATE users SET credits = credits + $1 WHERE user_id = $2 RETURNING *",
      [amount, userId],
    );
    return result.rows[0] || null;
  },

  async updateLoyaltyPoints(
    userId: string,
    points: number,
  ): Promise<User | null> {
    const result = await db.query(
      "UPDATE users SET loyalty_points = $1 WHERE user_id = $2 RETURNING *",
      [points, userId],
    );
    return result.rows[0] || null;
  },

  async addLoyaltyPoints(userId: string, points: number): Promise<User | null> {
    const result = await db.query(
      "UPDATE users SET loyalty_points = loyalty_points + $1 WHERE user_id = $2 RETURNING *",
      [points, userId],
    );
    return result.rows[0] || null;
  },

  async verifyUser(userId: string): Promise<User | null> {
    const result = await db.query(
      "UPDATE users SET is_verified = true WHERE user_id = $1 RETURNING *",
      [userId],
    );
    return result.rows[0] || null;
  },

  async updateLastLogin(userId: string): Promise<void> {
    await db.query("UPDATE users SET last_login = NOW() WHERE user_id = $1", [
      userId,
    ]);
  },
};
