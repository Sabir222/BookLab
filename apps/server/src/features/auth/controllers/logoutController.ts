import { type Request, type Response } from "express";

/**
 * Controller for handling user logout requests.
 * It clears the authentication cookies and responds with a 200 status.
 *
 * @param {Request} _req - The request object (not used in this controller).
 * @param {Response} res - The response object to send back the logout response.
 * @returns {Promise<void>} - A promise that resolves when the response is sent.
 */
const logoutController = async (_req: Request, res: Response) => {
  res
    .clearCookie(process.env.REFRESH_TOKEN_COOKIE_NAME!)
    .clearCookie(process.env.ACCESS_TOKEN_COOKIE_NAME!)
    .status(200)
    .end();
};

export default logoutController;
