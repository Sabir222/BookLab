import { createClient, RedisClientType } from "redis";

export interface RedisConfig {
  url?: string;
  host?: string;
  port?: number;
  password?: string;
  database?: number;
}

const defaultConfig: RedisConfig = {
  host: process.env.REDIS_HOST || "localhost",
  port: parseInt(process.env.REDIS_PORT || "6379"),
  password: process.env.REDIS_PASSWORD,
  database: parseInt(process.env.REDIS_DB || "0"),
};

export const createRedisClient = (
  config: RedisConfig = {},
): RedisClientType => {
  const clientConfig = { ...defaultConfig, ...config };

  const client = createClient({
    url:
      clientConfig.url || `redis://${clientConfig.host}:${clientConfig.port}`,
    password: clientConfig.password,
    database: clientConfig.database,
  });

  client.on("error", (err) => {
    console.error("Redis Client Error:", err);
  });

  client.on("connect", () => {
    console.log("Redis client connected");
  });

  client.on("ready", () => {
    console.log("Redis client ready");
  });

  return client as RedisClientType;
};
