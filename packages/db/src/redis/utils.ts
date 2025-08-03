import type { RedisClientType } from "redis";

export const setCache = async (
  client: RedisClientType,
  key: string,
  value: string | object,
  ttlSeconds?: number,
): Promise<void> => {
  try {
    const serializedValue =
      typeof value === "string" ? value : JSON.stringify(value);
    if (ttlSeconds) {
      await client.setEx(key, ttlSeconds, serializedValue);
    } else {
      await client.set(key, serializedValue);
    }
  } catch (error) {
    throw new Error(
      `Failed to set cache for key "${key}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

// Overloaded function signatures for better type safety
export async function getCache<T = string>(
  client: RedisClientType,
  key: string,
): Promise<T | null>;
export async function getCache<T = object>(
  client: RedisClientType,
  key: string,
  parseJson: true,
): Promise<T | null>;
export async function getCache<T = string>(
  client: RedisClientType,
  key: string,
  parseJson: false,
): Promise<T | null>;
export async function getCache<T = string>(
  client: RedisClientType,
  key: string,
  parseJson?: boolean,
): Promise<T | null> {
  try {
    const value = await client.get(key);
    if (!value) return null;

    if (parseJson) {
      try {
        return JSON.parse(value) as T;
      } catch {
        return value as T;
      }
    }
    return value as T;
  } catch (error) {
    throw new Error(
      `Failed to get cache for key "${key}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
}

export const deleteCache = async (
  client: RedisClientType,
  key: string | string[],
): Promise<number> => {
  try {
    return await client.del(key);
  } catch (error) {
    const keyStr = Array.isArray(key) ? key.join(", ") : key;
    throw new Error(
      `Failed to delete cache for key(s) "${keyStr}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const existsCache = async (
  client: RedisClientType,
  key: string,
): Promise<boolean> => {
  try {
    const result = await client.exists(key);
    return result === 1;
  } catch (error) {
    throw new Error(
      `Failed to check existence for key "${key}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const incrementCache = async (
  client: RedisClientType,
  key: string,
  increment = 1,
  ttlSeconds?: number,
): Promise<number> => {
  try {
    const result = await client.incrBy(key, increment);
    if (ttlSeconds && result === increment) {
      // Only set TTL if this is a new key (first increment)
      await client.expire(key, ttlSeconds);
    }
    return result;
  } catch (error) {
    throw new Error(
      `Failed to increment cache for key "${key}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const getCacheWithTTL = async <T = string>(
  client: RedisClientType,
  key: string,
  parseJson = false,
): Promise<{ value: T | null; ttl: number }> => {
  try {
    const [value, ttl] = await Promise.all([client.get(key), client.ttl(key)]);

    if (!value) return { value: null, ttl };

    let parsedValue: T;
    if (parseJson) {
      try {
        parsedValue = JSON.parse(value) as T;
      } catch {
        parsedValue = value as T;
      }
    } else {
      parsedValue = value as T;
    }

    return { value: parsedValue, ttl };
  } catch (error) {
    throw new Error(
      `Failed to get cache with TTL for key "${key}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const batchGetCache = async <T = string>(
  client: RedisClientType,
  keys: string[],
  parseJson = false,
): Promise<Record<string, T | null>> => {
  try {
    if (keys.length === 0) return {};

    const values = await client.mGet(keys);
    const result: Record<string, T | null> = {};

    keys.forEach((key, index) => {
      const value = values[index];
      if (!value) {
        result[key] = null;
        return;
      }

      if (parseJson) {
        try {
          result[key] = JSON.parse(value) as T;
        } catch {
          result[key] = value as T;
        }
      } else {
        result[key] = value as T;
      }
    });

    return result;
  } catch (error) {
    throw new Error(
      `Failed to batch get cache for keys "${keys.join(", ")}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const batchSetCache = async (
  client: RedisClientType,
  keyValuePairs: Record<string, string | object>,
  ttlSeconds?: number,
): Promise<void> => {
  try {
    const serializedPairs: Record<string, string> = {};

    for (const [key, value] of Object.entries(keyValuePairs)) {
      serializedPairs[key] =
        typeof value === "string" ? value : JSON.stringify(value);
    }

    await client.mSet(serializedPairs);

    if (ttlSeconds) {
      const keys = Object.keys(serializedPairs);
      await Promise.all(keys.map((key) => client.expire(key, ttlSeconds)));
    }
  } catch (error) {
    throw new Error(
      `Failed to batch set cache: ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

/**
 * Helper function to scan and collect all keys matching a pattern using SCAN.
 */
const scanKeys = async (
  client: RedisClientType,
  pattern: string,
  scanCount = 1000,
): Promise<string[]> => {
  let cursor = "0";
  let keys: string[] = [];
  do {
    const reply = await client.scan(cursor, {
      MATCH: pattern,
      COUNT: scanCount,
    });
    cursor = reply.cursor;
    keys = keys.concat(reply.keys);
  } while (cursor !== "0");
  return keys;
};

export const invalidateCachePattern = async (
  client: RedisClientType,
  pattern: string,
): Promise<number> => {
  try {
    const keys = await scanKeys(client, pattern);
    if (keys.length === 0) return 0;
    return await client.del(keys);
  } catch (error) {
    throw new Error(
      `Failed to invalidate cache pattern "${pattern}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const setSession = async (
  client: RedisClientType,
  sessionId: string,
  sessionData: object,
  ttlSeconds = 3600, // 1 hour default
): Promise<void> => {
  try {
    const key = `session:${sessionId}`;
    await setCache(client, key, sessionData, ttlSeconds);
  } catch (error) {
    throw new Error(
      `Failed to set session "${sessionId}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const getSession = async <T = object>(
  client: RedisClientType,
  sessionId: string,
): Promise<T | null> => {
  try {
    const key = `session:${sessionId}`;
    return await getCache<T>(client, key, true);
  } catch (error) {
    throw new Error(
      `Failed to get session "${sessionId}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const deleteSession = async (
  client: RedisClientType,
  sessionId: string,
): Promise<number> => {
  try {
    const key = `session:${sessionId}`;
    return await deleteCache(client, key);
  } catch (error) {
    throw new Error(
      `Failed to delete session "${sessionId}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const extendSession = async (
  client: RedisClientType,
  sessionId: string,
  ttlSeconds = 3600,
): Promise<boolean> => {
  try {
    const key = `session:${sessionId}`;
    const result = await client.expire(key, ttlSeconds);
    return result === 1;
  } catch (error) {
    throw new Error(
      `Failed to extend session "${sessionId}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const checkRateLimit = async (
  client: RedisClientType,
  identifier: string,
  maxRequests: number,
  windowSeconds: number,
): Promise<{ allowed: boolean; remaining: number; resetTime: number }> => {
  try {
    const key = `rate_limit:${identifier}`;
    const now = Date.now();
    const windowStart = now - windowSeconds * 1000;

    // Remove old entries
    await client.zRemRangeByScore(key, 0, windowStart);

    // Count current requests
    const currentCount = await client.zCard(key);

    if (currentCount >= maxRequests) {
      const oldestRequests = await client.zRangeWithScores(key, 0, 0);
      const resetTime =
        oldestRequests.length > 0 && oldestRequests[0]?.score
          ? oldestRequests[0].score + windowSeconds * 1000
          : now + windowSeconds * 1000;

      return {
        allowed: false,
        remaining: 0,
        resetTime,
      };
    }

    // Add current request
    await client.zAdd(key, { score: now, value: `${now}-${Math.random()}` });
    await client.expire(key, windowSeconds);

    return {
      allowed: true,
      remaining: maxRequests - currentCount - 1,
      resetTime: now + windowSeconds * 1000,
    };
  } catch (error) {
    throw new Error(
      `Failed to check rate limit for "${identifier}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const publishMessage = async (
  client: RedisClientType,
  channel: string,
  message: string | object,
): Promise<number> => {
  try {
    const serializedMessage =
      typeof message === "string" ? message : JSON.stringify(message);
    return await client.publish(channel, serializedMessage);
  } catch (error) {
    throw new Error(
      `Failed to publish message to channel "${channel}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};

export const subscribeToChannel = async (
  client: RedisClientType,
  channel: string,
  callback: (message: string, channel: string) => void,
): Promise<void> => {
  try {
    await client.subscribe(channel, callback);
  } catch (error) {
    throw new Error(
      `Failed to subscribe to channel "${channel}": ${error instanceof Error ? error.message : "Unknown error"}`,
    );
  }
};
