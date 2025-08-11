import { type Request, type Response } from "express";

const logoutController = async (req: Request, res: Response) => {
  if (req.user) {
    console.log(`User ${req.user.username} (ID: ${req.user.id}) logged out`);
  }

  res
    .clearCookie(process.env.REFRESH_TOKEN_COOKIE_NAME!)
    .clearCookie(process.env.ACCESS_TOKEN_COOKIE_NAME!)
    .status(200)
    .json({
      success: true,
      message: "Successfully logged out",
    });
};

export default logoutController;
