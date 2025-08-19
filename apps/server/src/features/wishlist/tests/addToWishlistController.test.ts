// Mock dependencies before importing the controller
vi.mock("@repo/db/postgres", () => ({
  wishlistQueries: {
    isBookInUserWishlist: vi.fn(),
    addItemToWishlist: vi.fn(),
    removeItemFromWishlist: vi.fn(),
    getUserWishlistWithBooks: vi.fn(),
  },
  bookQueries: {
    findById: vi.fn(),
  },
}));

import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { Request, Response } from "express";
import { addToWishlistController } from "../controllers/addToWishlistController.js";
import { bookQueries, wishlistQueries } from "@repo/db/postgres";

describe("addToWishlistController", () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let jsonResponse: any;
  let status: any;

  beforeEach(() => {
    jsonResponse = vi.fn();
    status = vi.fn().mockReturnValue({ json: jsonResponse });

    mockRequest = {
      body: {},
      user: {
        id: "user123",
        email: "test@example.com",
        username: "testuser",
        role: "user",
      },
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

  it("should successfully add a book to the wishlist", async () => {
    const mockWishlistItem = {
      user_id: "user123",
      book_id: "book123",
      added_at: new Date(),
    };

    // Mock the dependencies
    (bookQueries.findById as any).mockResolvedValue({ book_id: "book123" });
    (wishlistQueries.isBookInUserWishlist as any).mockResolvedValue(false);
    (wishlistQueries.addItemToWishlist as any).mockResolvedValue(mockWishlistItem);

    mockRequest.body = {
      book_id: "book123",
    };

    await addToWishlistController(mockRequest as Request, mockResponse as Response);

    expect(bookQueries.findById).toHaveBeenCalledWith("book123");
    expect(wishlistQueries.isBookInUserWishlist).toHaveBeenCalledWith("user123", "book123");
    expect(wishlistQueries.addItemToWishlist).toHaveBeenCalledWith({
      user_id: "user123",
      book_id: "book123",
    });
    expect(status).toHaveBeenCalledWith(201);
    expect(jsonResponse).toHaveBeenCalled();
  });

  it("should return 400 error when book_id is missing", async () => {
    mockRequest.body = {};

    await addToWishlistController(mockRequest as Request, mockResponse as Response);

    expect(status).toHaveBeenCalledWith(400);
    expect(jsonResponse).toHaveBeenCalledWith({
      success: false,
      error: "Book ID is required",
      code: "MISSING_BOOK_ID",
    });
  });

  it("should return 400 error when book_id format is invalid", async () => {
    mockRequest.body = {
      book_id: "invalid-id",
    };

    await addToWishlistController(mockRequest as Request, mockResponse as Response);

    expect(status).toHaveBeenCalledWith(400);
    expect(jsonResponse).toHaveBeenCalledWith({
      success: false,
      error: "Invalid book ID format",
      code: "INVALID_BOOK_ID",
    });
  });

  it("should return 404 error when book is not found", async () => {
    (bookQueries.findById as any).mockResolvedValue(null);

    mockRequest.body = {
      book_id: "book123",
    };

    await addToWishlistController(mockRequest as Request, mockResponse as Response);

    expect(bookQueries.findById).toHaveBeenCalledWith("book123");
    expect(status).toHaveBeenCalledWith(404);
    expect(jsonResponse).toHaveBeenCalledWith({
      success: false,
      error: "Book not found",
      code: "BOOK_NOT_FOUND",
    });
  });

  it("should return 409 error when book is already in wishlist", async () => {
    (bookQueries.findById as any).mockResolvedValue({ book_id: "book123" });
    (wishlistQueries.isBookInUserWishlist as any).mockResolvedValue(true);

    mockRequest.body = {
      book_id: "book123",
    };

    await addToWishlistController(mockRequest as Request, mockResponse as Response);

    expect(bookQueries.findById).toHaveBeenCalledWith("book123");
    expect(wishlistQueries.isBookInUserWishlist).toHaveBeenCalledWith("user123", "book123");
    expect(status).toHaveBeenCalledWith(409);
    expect(jsonResponse).toHaveBeenCalledWith({
      success: false,
      error: "Book is already in your wishlist",
      code: "BOOK_ALREADY_IN_WISHLIST",
    });
  });

  it("should return 401 error when user is not authenticated", async () => {
    mockRequest.user = undefined;
    mockRequest.body = {
      book_id: "book123",
    };

    await addToWishlistController(mockRequest as Request, mockResponse as Response);

    expect(status).toHaveBeenCalledWith(401);
    expect(jsonResponse).toHaveBeenCalledWith({
      success: false,
      error: "Authentication required",
      code: "UNAUTHORIZED",
    });
  });

  it("should return 500 error when an unexpected error occurs", async () => {
    (bookQueries.findById as any).mockRejectedValue(
      new Error("Database error"),
    );

    mockRequest.body = {
      book_id: "book123",
    };

    await addToWishlistController(mockRequest as Request, mockResponse as Response);

    expect(status).toHaveBeenCalledWith(500);
    expect(jsonResponse).toHaveBeenCalledWith({
      success: false,
      error: "Internal server error",
      code: "INTERNAL_ERROR",
    });
  });
});