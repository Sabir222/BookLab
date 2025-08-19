import { type Request, type Response } from "express";
import { newsletterQueries } from "@repo/db/postgres";
import { sendCreated, sendError, sendSuccess } from "../../../utils/responseHandler.js";

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
      sendError(res, "Email is required", "MISSING_EMAIL", 400);
      return;
    }

    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      sendError(res, "Invalid email format", "INVALID_EMAIL", 400);
      return;
    }

    const subscriber = await subscribeToNewsletter(email);

    console.log(`Email subscribed to newsletter: ${email}`);

    sendCreated(res, {
      subscriber: {
        subscriber_id: subscriber!.subscriber_id,
        email: subscriber!.email,
        is_subscribed: subscriber!.is_subscribed,
        subscribed_at: subscriber!.subscribed_at,
      },
    }, "Successfully subscribed to newsletter");
  } catch (error) {
    console.error("Newsletter subscription error:", error);

    if (error instanceof NewsletterError) {
      sendError(res, error.message, error.code || "NEWSLETTER_ERROR", error.statusCode);
      return;
    }

    sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};