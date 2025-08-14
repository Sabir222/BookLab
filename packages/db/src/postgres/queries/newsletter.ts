import { db } from "../client.js";
import {
  type NewsletterSubscriber,
  type CreateNewsletterSubscriberData,
  type UpdateNewsletterSubscriberData,
} from "../types/newsletter-types.js";

export const newsletterQueries = {
  async findByEmail(email: string): Promise<NewsletterSubscriber | null> {
    const result = await db.query(
      "SELECT * FROM newsletter_subscribers WHERE email = $1",
      [email],
    );
    return result.rows[0] || null;
  },

  async create(
    subscriberData: CreateNewsletterSubscriberData,
  ): Promise<NewsletterSubscriber> {
    const result = await db.query(
      `INSERT INTO newsletter_subscribers (email)
       VALUES ($1)
       RETURNING *`,
      [subscriberData.email],
    );
    return result.rows[0];
  },

  async update(
    email: string,
    subscriberData: UpdateNewsletterSubscriberData,
  ): Promise<NewsletterSubscriber | null> {
    const fields: string[] = [];
    const values: any[] = [];
    let paramCount = 1;

    const fieldMap: Record<string, string> = {
      is_subscribed: "is_subscribed",
      unsubscribed_at: "unsubscribed_at",
    };

    Object.entries(subscriberData).forEach(([key, value]) => {
      if (value !== undefined && fieldMap[key]) {
        fields.push(`${fieldMap[key]} = $${paramCount}`);
        values.push(value);
        paramCount++;
      }
    });

    if (fields.length === 0) return null;

    values.push(email);

    const result = await db.query(
      `UPDATE newsletter_subscribers SET ${fields.join(", ")} WHERE email = $${paramCount} RETURNING *`,
      values,
    );
    return result.rows[0] || null;
  },

  async delete(email: string): Promise<boolean> {
    const result = await db.query(
      "DELETE FROM newsletter_subscribers WHERE email = $1",
      [email],
    );
    return (result.rowCount ?? 0) > 0;
  },

  async list(limit = 50, offset = 0): Promise<NewsletterSubscriber[]> {
    const result = await db.query(
      "SELECT * FROM newsletter_subscribers ORDER BY subscribed_at DESC LIMIT $1 OFFSET $2",
      [limit, offset],
    );
    return result.rows;
  },

  async count(): Promise<number> {
    const result = await db.query(
      "SELECT COUNT(*) as count FROM newsletter_subscribers",
    );
    return parseInt(result.rows[0].count, 10);
  },
};

