import jwt from "jsonwebtoken";
export type JWTPayload = {
  id: string;
  email: string;
  username: string;
};

/**
 * Generates JWT access (15m) and refresh (7d) tokens
 * @param payload User data to encode
 * @returns Object with accessToken and refreshToken
 */

const generateToken = (payload: JWTPayload) => {
  const jwtSecret = process.env.JWT_SECRET!;
  const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET!;

  const accessToken = jwt.sign(payload, jwtSecret, {
    expiresIn: "15m",
  });

  const refreshToken = jwt.sign({ id: payload.id }, jwtRefreshSecret, {
    expiresIn: "7d",
  });

  return { accessToken, refreshToken };
};

export default generateToken;
