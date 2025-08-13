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

type UnsubscribeRequestBody = {
  email: string;
};

/**
 * Unsubscribes an email from the newsletter.
 * If the email doesn't exist or is already unsubscribed, it will return an error.
 *
 * @param {string} email - The email to unsubscribe.
 * @returns {Promise<NewsletterSubscriber>} - Returns the updated subscriber object.
 *
 * @throws {NewsletterError} - If the email is not found or already unsubscribed.
 */
const unsubscribeFromNewsletter = async (email: string) => {
  // Check if subscriber exists
  const existingSubscriber = await newsletterQueries.findByEmail(email);

  // If subscriber doesn't exist, throw an error
  if (!existingSubscriber) {
    throw new NewsletterError(
      404,
      "Email not found in newsletter subscribers",
      "EMAIL_NOT_FOUND",
    );
  }

  // If subscriber exists but is already unsubscribed, throw an error
  if (!existingSubscriber.is_subscribed) {
    throw new NewsletterError(
      409,
      "Email is already unsubscribed from the newsletter",
      "ALREADY_UNSUBSCRIBED",
    );
  }

  // Update the record to unsubscribe
  return await newsletterQueries.update(email, {
    is_subscribed: false,
    unsubscribed_at: new Date(),
  });
};

/**
 * Controller for handling newsletter unsubscription requests.
 * Validates the request and unsubscribes the email from the newsletter.
 *
 * @param {Request} req - The request object containing the email.
 * @param {Response} res - The response object to send back the result.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 *
 * @throws {NewsletterError} - If unsubscription fails or required fields are missing
 */
export const unsubscribeController = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const { email }: UnsubscribeRequestBody = req.body;

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

    const subscriber = await unsubscribeFromNewsletter(email);

    console.log(`Email unsubscribed from newsletter: ${email}`);

    res.status(200).json({
      message: "Successfully unsubscribed from newsletter",
      subscriber: {
        subscriber_id: subscriber!.subscriber_id,
        email: subscriber!.email,
        is_subscribed: subscriber!.is_subscribed,
        unsubscribed_at: subscriber!.unsubscribed_at,
      },
    });
  } catch (error) {
    console.error("Newsletter unsubscription error:", error);

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