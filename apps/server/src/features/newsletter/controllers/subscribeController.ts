import { type Request, type Response } from "express";
import { newsletterQueries } from "@repo/db/postgres";

class NewsletterError extends Error {
  constructor(
    public statusCode: number,
    message: string,
    public code?: string,
  ) {
    super(message);
    this.name = "NewsletterError";
  }
}

type SubscribeRequestBody = {
  email: string;
};

/**
 * Subscribes an email to the newsletter.
 * If the email already exists and is unsubscribed, it will resubscribe it.
 * If the email already exists and is subscribed, it will return a conflict error.
 *
 * @param {string} email - The email to subscribe.
 * @returns {Promise<NewsletterSubscriber>} - Returns the subscriber object.
 *
 * @throws {NewsletterError} - If the email is invalid or already subscribed.
 */
const subscribeToNewsletter = async (email: string) => {
  // Check if subscriber already exists
  const existingSubscriber = await newsletterQueries.findByEmail(email);

  // If subscriber exists and is already subscribed, throw an error
  if (existingSubscriber && existingSubscriber.is_subscribed) {
    throw new NewsletterError(
      409,
      "Email is already subscribed to the newsletter",
      "ALREADY_SUBSCRIBED",
    );
  }

  // If subscriber exists but is unsubscribed, update the record
  if (existingSubscriber && !existingSubscriber.is_subscribed) {
    return await newsletterQueries.update(email, {
      is_subscribed: true,
      unsubscribed_at: null,
    });
  }

  // If subscriber doesn't exist, create a new record
  return await newsletterQueries.create({ email });
};

/**
 * Controller for handling newsletter subscription requests.
 * Validates the request and subscribes the email to the newsletter.
 *
 * @param {Request} req - The request object containing the email.
 * @param {Response} res - The response object to send back the result.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 *
 * @throws {NewsletterError} - If subscription fails or required fields are missing
 */
export const subscribeController = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const { email }: SubscribeRequestBody = req.body;

    if (!email) {
      res.status(400).json({
        error: "Email is required",
        code: "MISSING_EMAIL",
      });
      return;
    }

    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      res.status(400).json({
        error: "Invalid email format",
        code: "INVALID_EMAIL",
      });
      return;
    }

    const subscriber = await subscribeToNewsletter(email);

    console.log(`Email subscribed to newsletter: ${email}`);

    res.status(201).json({
      message: "Successfully subscribed to newsletter",
      subscriber: {
        subscriber_id: subscriber.subscriber_id,
        email: subscriber.email,
        is_subscribed: subscriber.is_subscribed,
        subscribed_at: subscriber.subscribed_at,
      },
    });
  } catch (error) {
    console.error("Newsletter subscription error:", error);

    if (error instanceof NewsletterError) {
      res.status(error.statusCode).json({
        error: error.message,
        code: error.code,
      });
      return;
    }

    res.status(500).json({
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  }
};