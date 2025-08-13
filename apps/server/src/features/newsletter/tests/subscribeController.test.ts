// Mock dependencies before importing the controller
vi.mock("@repo/db/postgres", () => ({
  newsletterQueries: {
    findByEmail: vi.fn(),
    create: vi.fn(),
    update: vi.fn(),
  },
}));

import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { Request, Response } from "express";
import { subscribeController } from "../subscribeController.js";

describe("subscribeController", () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let jsonResponse: any;
  let status: any;

  beforeEach(() => {
    jsonResponse = vi.fn();
    status = vi.fn().mockReturnValue({ json: jsonResponse });

    mockRequest = {
      body: {},
    };

    mockResponse = {
      status,
      json: jsonResponse,
    };

    // Clear all mocks before each test
    vi.clearAllMocks();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("should successfully subscribe a new email", async () => {
    const mockSubscriberData = {
      subscriber_id: "123",
      email: "test@example.com",
      is_subscribed: true,
      subscribed_at: new Date(),
      unsubscribed_at: null,
      created_at: new Date(),
      updated_at: new Date(),
    };

    // Mock the dependencies
    const { newsletterQueries } = await import("@repo/db/postgres");
    (newsletterQueries.findByEmail as any).mockResolvedValue(null);
    (newsletterQueries.create as any).mockResolvedValue(mockSubscriberData);

    mockRequest.body = {
      email: "test@example.com",
    };

    await subscribeController(mockRequest as Request, mockResponse as Response);

    expect(newsletterQueries.findByEmail).toHaveBeenCalledWith("test@example.com");
    expect(newsletterQueries.create).toHaveBeenCalledWith({ email: "test@example.com" });
    expect(status).toHaveBeenCalledWith(201);
    expect(jsonResponse).toHaveBeenCalled();
  });

  it("should return 400 error when email is missing", async () => {
    mockRequest.body = {};

    await subscribeController(mockRequest as Request, mockResponse as Response);

    expect(status).toHaveBeenCalledWith(400);
    expect(jsonResponse).toHaveBeenCalledWith({
      error: "Email is required",
      code: "MISSING_EMAIL",
    });
  });

  it("should return 400 error when email format is invalid", async () => {
    mockRequest.body = {
      email: "invalid-email",
    };

    await subscribeController(mockRequest as Request, mockResponse as Response);

    expect(status).toHaveBeenCalledWith(400);
    expect(jsonResponse).toHaveBeenCalledWith({
      error: "Invalid email format",
      code: "INVALID_EMAIL",
    });
  });

  it("should return 409 error when email is already subscribed", async () => {
    const existingSubscriber = {
      subscriber_id: "456",
      email: "existing@example.com",
      is_subscribed: true,
      subscribed_at: new Date(),
      unsubscribed_at: null,
      created_at: new Date(),
      updated_at: new Date(),
    };

    const { newsletterQueries } = await import("@repo/db/postgres");
    (newsletterQueries.findByEmail as any).mockResolvedValue(existingSubscriber);

    mockRequest.body = {
      email: "existing@example.com",
    };

    await subscribeController(mockRequest as Request, mockResponse as Response);

    expect(newsletterQueries.findByEmail).toHaveBeenCalledWith("existing@example.com");
    expect(status).toHaveBeenCalledWith(409);
    expect(jsonResponse).toHaveBeenCalledWith({
      error: "Email is already subscribed to the newsletter",
      code: "ALREADY_SUBSCRIBED",
    });
  });

  it("should successfully resubscribe an unsubscribed email", async () => {
    const existingSubscriber = {
      subscriber_id: "789",
      email: "unsubscribed@example.com",
      is_subscribed: false,
      subscribed_at: new Date(),
      unsubscribed_at: new Date(),
      created_at: new Date(),
      updated_at: new Date(),
    };

    const updatedSubscriber = {
      ...existingSubscriber,
      is_subscribed: true,
      unsubscribed_at: null,
    };

    const { newsletterQueries } = await import("@repo/db/postgres");
    (newsletterQueries.findByEmail as any).mockResolvedValue(existingSubscriber);
    (newsletterQueries.update as any).mockResolvedValue(updatedSubscriber);

    mockRequest.body = {
      email: "unsubscribed@example.com",
    };

    await subscribeController(mockRequest as Request, mockResponse as Response);

    expect(newsletterQueries.findByEmail).toHaveBeenCalledWith("unsubscribed@example.com");
    expect(newsletterQueries.update).toHaveBeenCalledWith("unsubscribed@example.com", {
      is_subscribed: true,
      unsubscribed_at: null,
    });
    expect(status).toHaveBeenCalledWith(201);
    expect(jsonResponse).toHaveBeenCalled();
  });

  it("should return 500 error when an unexpected error occurs", async () => {
    const { newsletterQueries } = await import("@repo/db/postgres");
    (newsletterQueries.findByEmail as any).mockRejectedValue(
      new Error("Database error"),
    );

    mockRequest.body = {
      email: "test@example.com",
    };

    await subscribeController(mockRequest as Request, mockResponse as Response);

    expect(status).toHaveBeenCalledWith(500);
    expect(jsonResponse).toHaveBeenCalledWith({
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  });
});