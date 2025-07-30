/**
 * @file validateEnv.ts
 * @description Validates that required environment variables are set.
 * Throws an error if any required variable is missing.
 */
const validateEnv = () => {
  const required = ["JWT_SECRET", "JWT_REFRESH_SECRET"];
  const missing = required.filter((key) => !process.env[key]);
  if (missing.length > 0) {
    throw new Error(
      `Missing required environment variables: ${missing.join(", ")}`,
    );
  }
};

export default validateEnv;
