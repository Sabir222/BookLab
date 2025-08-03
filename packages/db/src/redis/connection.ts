import { createRedisClient, RedisConfig } from "./config.js";

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

// Graceful shutdown
process.on("SIGINT", async () => {
  await disconnectRedis();
  process.exit(0);
});

process.on("SIGTERM", async () => {
  await disconnectRedis();
  process.exit(0);
});
