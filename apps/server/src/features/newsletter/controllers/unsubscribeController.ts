import { type Request, type Response } from "express";
import { newsletterQueries } from "@repo/db/postgres";
import { sendSuccess, sendError } from "../../../utils/responseHandler.js";

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
  const existingSubscriber = await newsletterQueries.findByEmail(email);

  if (!existingSubscriber) {
    throw new NewsletterError(
      404,
      "Email not found in newsletter subscribers",
      "EMAIL_NOT_FOUND",
    );
  }

  if (!existingSubscriber.is_subscribed) {
    throw new NewsletterError(
      409,
      "Email is already unsubscribed from the newsletter",
      "ALREADY_UNSUBSCRIBED",
    );
  }

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
      sendError(res, "Email is required", "MISSING_EMAIL", 400);
      return;
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      sendError(res, "Invalid email format", "INVALID_EMAIL", 400);
      return;
    }

    const subscriber = await unsubscribeFromNewsletter(email);

    console.log(`Email unsubscribed from newsletter: ${email}`);

    sendSuccess(
      res,
      {
        subscriber: {
          subscriber_id: subscriber!.subscriber_id,
          email: subscriber!.email,
          is_subscribed: subscriber!.is_subscribed,
          unsubscribed_at: subscriber!.unsubscribed_at,
        },
      },
      "Successfully unsubscribed from newsletter",
    );
  } catch (error) {
    console.error("Newsletter unsubscription error:", error);

    if (error instanceof NewsletterError) {
      sendError(
        res,
        error.message,
        error.code || "NEWSLETTER_ERROR",
        error.statusCode,
      );
      return;
    }

    sendError(res, "Internal server error", "INTERNAL_ERROR", 500);
  }
};

