import dotenv from "dotenv";

dotenv.config();

export function validateEnvironment(): void {
  const requiredVars = [
    "CORS_ORIGIN",
    "SESSION_SECRET",
    "JWT_SECRET",
    "JWT_REFRESH_SECRET",
    "ACCESS_TOKEN_COOKIE_NAME",
    "REFRESH_TOKEN_COOKIE_NAME",
    "ACCESS_TOKEN_COOKIE_MAX_AGE",
    "REFRESH_TOKEN_COOKIE_MAX_AGE",
  ];

  const missingVars = [];

  for (const varName of requiredVars) {
    if (!process.env[varName]) {
      missingVars.push(varName);
    }
  }

  if (missingVars.length > 0) {
    console.error(
      `❌ Missing required environment variables: ${missingVars.join(", ")}`,
    );
    if (process.env.NODE_ENV === "production") {
      process.exit(1);
    }
  }

  if (process.env.SESSION_SECRET && process.env.SESSION_SECRET.length < 32) {
    console.warn(
      "⚠️  Warning: SESSION_SECRET should be at least 32 characters long for security.",
    );
  }

  const port = process.env.PORT;
  if (
    port &&
    (isNaN(Number(port)) || Number(port) < 1 || Number(port) > 65535)
  ) {
    console.error("PORT must be a valid number between 1 and 65535");
    process.exit(1);
  }

  const accessTokenMaxAge = process.env.ACCESS_TOKEN_COOKIE_MAX_AGE;
  if (accessTokenMaxAge && isNaN(Number(accessTokenMaxAge))) {
    console.error("ACCESS_TOKEN_COOKIE_MAX_AGE must be a valid number");
    process.exit(1);
  }

  const refreshTokenMaxAge = process.env.REFRESH_TOKEN_COOKIE_MAX_AGE;
  if (refreshTokenMaxAge && isNaN(Number(refreshTokenMaxAge))) {
    console.error("REFRESH_TOKEN_COOKIE_MAX_AGE must be a valid number");
    process.exit(1);
  }

  console.log("Environment validation passed");
}
