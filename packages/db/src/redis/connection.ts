import { createRedisClient, type RedisConfig } from "./config.js";

let redisClient: ReturnType<typeof createRedisClient> | null = null;

export const connectRedis = async (config?: RedisConfig) => {
  if (redisClient) {
    return redisClient;
  }

  redisClient = createRedisClient(config);

  try {
    await redisClient.connect();
    console.log("Redis connected successfully");
    return redisClient;
  } catch (error) {
    console.error("Failed to connect to Redis:", error);
    redisClient = null;
    throw error;
  }
};

export const getRedisClient = () => {
  if (!redisClient) {
    throw new Error("Redis client not initialized. Call connectRedis() first.");
  }
  return redisClient;
};

export const disconnectRedis = async (): Promise<void> => {
  if (redisClient) {
    await redisClient.quit();
    redisClient = null;
    console.log("Redis disconnected");
  }
};

export const registerRedisShutdownHandlers = () => {
  const shutdown = async (signal: string) => {
    try {
      console.log(`Received ${signal}, gracefully shutting down Redis...`);
      await disconnectRedis();
      process.exit(0);
    } catch (error) {
      console.error("Error during Redis shutdown:", error);
      process.exit(1);
    }
  };

  process.on("SIGINT", () => shutdown("SIGINT"));
  process.on("SIGTERM", () => shutdown("SIGTERM"));
};
