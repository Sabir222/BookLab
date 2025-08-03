// import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
// import { db } from "@repo/db/postgres";
// import { signUpController } from "../signupController";
// import type { Request, Response } from "express";
// import { hashPassword } from "../../../../utils/hashPassword";
//
// vi.mock("@repo/db/db");
// vi.mock("../../../../utils/hashPassword");
//
// describe("signUpController", () => {
//   let mockRequest: Partial<Request>;
//   let mockResponse: Partial<Response>;
//   let mockDbClient: any;
//
//   beforeEach(() => {
//     mockRequest = {
//       body: {
//         email: "test@example.com",
//         username: "testuser",
//         password: "password123",
//       },
//     };
//
//     mockResponse = {
//       status: vi.fn().mockReturnThis(),
//       json: vi.fn().mockReturnThis(),
//       cookie: vi.fn().mockReturnThis(),
//     };
//
//     mockDbClient = {
//       query: vi.fn(),
//       release: vi.fn(),
//     };
//     vi.mocked(db.connect).mockResolvedValue(mockDbClient);
//
//     vi.mocked(hashPassword).mockReturnValue("hashed_password");
//
//     process.env.JWT_SECRET = "test-secret";
//     process.env.JWT_REFRESH_SECRET = "test-refresh-secret";
//     process.env.REFRESH_TOKEN_COOKIE_NAME = "refreshToken";
//     process.env.ACCESS_TOKEN_COOKIE_NAME = "accessToken";
//     process.env.REFRESH_TOKEN_COOKIE_MAX_AGE = "604800000";
//     process.env.ACCESS_TOKEN_COOKIE_MAX_AGE = "900000";
//     process.env.NODE_ENV = "test";
//
//     vi.spyOn(console, "log").mockImplementation(() => {});
//     vi.spyOn(console, "error").mockImplementation(() => {});
//   });
//
//   afterEach(() => {
//     vi.restoreAllMocks();
//   });
//
//   it("should create a new user and return 201 on successful signup", async () => {
//     // Mock the sequence of queries for successful signup:
//     // 1. BEGIN transaction
//     mockDbClient.query.mockResolvedValueOnce({});
//     // 2. Check existing user (returns empty)
//     mockDbClient.query.mockResolvedValueOnce({ rows: [] });
//     // 3. Insert new user
//     mockDbClient.query.mockResolvedValueOnce({
//       rows: [{ user_id: 1, email: "test@example.com", username: "testuser" }],
//     });
//     // 4. COMMIT transaction
//     mockDbClient.query.mockResolvedValueOnce({});
//
//     await signUpController(mockRequest as Request, mockResponse as Response);
//
//     expect(mockResponse.status).toHaveBeenCalledWith(201);
//     expect(mockResponse.json).toHaveBeenCalledWith(
//       expect.objectContaining({
//         message: "User created successfully",
//         user: { id: 1, email: "test@example.com", username: "testuser" },
//       }),
//     );
//   });
//
//   it("should return 400 if email, username, or password is missing", async () => {
//     mockRequest.body.password = "";
//
//     await signUpController(mockRequest as Request, mockResponse as Response);
//
//     expect(mockResponse.status).toHaveBeenCalledWith(400);
//     expect(mockResponse.json).toHaveBeenCalledWith({
//       error: "Data missing try again please!",
//       code: "MISSING_FIELDS",
//     });
//   });
//
//   it("should return 409 if the user already exists", async () => {
//     mockDbClient.query.mockResolvedValueOnce({});
//     mockDbClient.query.mockResolvedValueOnce({ rows: [{ user_id: 99 }] });
//     mockDbClient.query.mockResolvedValueOnce({});
//
//     await signUpController(mockRequest as Request, mockResponse as Response);
//
//     expect(mockResponse.status).toHaveBeenCalledWith(409);
//     expect(mockResponse.json).toHaveBeenCalledWith({
//       error: "User with this email or username already exists",
//       code: "USER_EXISTS",
//     });
//   });
// });
