export interface HealthStatus {
  status: "healthy" | "unhealthy" | "degraded";
  timestamp: string;
  uptime: number;
  services: {
    postgres: ServiceHealth;
    redis: ServiceHealth;
  };
  overall: {
    status: "healthy" | "unhealthy" | "degraded";
    message: string;
  };
}
export interface StartupConfig {
  maxRetries?: number;
  retryDelay?: number;
  allowDegraded?: boolean;
  exitOnFailure?: boolean;
}
export interface ServiceHealth {
  status: "healthy" | "unhealthy" | "degraded";
  responseTime: number;
  error?: string;
  details?: Record<string, any>;
}

export const checkPostgresHealth = async (): Promise<ServiceHealth> => {
  const startTime = Date.now();

  try {
    const { db } = await import("../postgres/database.js");
    const isHealthy = await db.isHealthy();

    const responseTime = Date.now() - startTime;

    if (isHealthy) {
      return {
        status: "healthy",
        responseTime,
        details: {
          query: "SELECT 1",
          connection: "active",
          pool: "connected",
        },
      };
    } else {
      return {
        status: "unhealthy",
        responseTime,
        error: "Database health check returned false",
        details: {
          query: "SELECT 1",
          connection: "failed",
          pool: "disconnected",
        },
      };
    }
  } catch (error: any) {
    const responseTime = Date.now() - startTime;

    return {
      status: "unhealthy",
      responseTime,
      error: error.message,
      details: {
        connection: "failed",
        pool: "error",
      },
    };
  }
};

export const checkRedisHealth = async (): Promise<ServiceHealth> => {
  const startTime = Date.now();

  try {
    const { getRedisClient, connectRedis } = await import(
      "../redis/connection.js"
    );

    const client = getRedisClient();

    const pingResult = await client.ping();
    await client.set("health_check", Date.now().toString(), { EX: 10 });
    const getValue = await client.get("health_check");

    const responseTime = Date.now() - startTime;

    return {
      status: "healthy",
      responseTime,
      details: {
        ping: pingResult,
        setGet: getValue ? "success" : "failed",
        connection: "active",
      },
    };
  } catch (error: any) {
    const responseTime = Date.now() - startTime;

    return {
      status: "unhealthy",
      responseTime,
      error: error.message,
      details: {
        connection: "failed",
      },
    };
  }
};

export const checkSystemHealth = async (): Promise<HealthStatus> => {
  const timestamp = new Date().toISOString();
  const uptime = process.uptime();

  const [postgresHealth, redisHealth] = await Promise.all([
    checkPostgresHealth(),
    checkRedisHealth(),
  ]);

  const services = { postgres: postgresHealth, redis: redisHealth };
  const serviceStatuses = Object.values(services).map((s) => s.status);

  let overallStatus: "healthy" | "unhealthy" | "degraded";
  let overallMessage: string;

  if (serviceStatuses.every((status) => status === "healthy")) {
    overallStatus = "healthy";
    overallMessage = "All services are operational";
  } else if (serviceStatuses.every((status) => status === "unhealthy")) {
    overallStatus = "unhealthy";
    overallMessage = "All services are down";
  } else {
    overallStatus = "degraded";
    overallMessage = "Some services are experiencing issues";
  }

  return {
    status: overallStatus,
    timestamp,
    uptime,
    services,
    overall: {
      status: overallStatus,
      message: overallMessage,
    },
  };
};

export const quickHealthCheck = async (): Promise<{
  status: "healthy" | "unhealthy";
  services: { postgres: boolean; redis: boolean };
}> => {
  try {
    const [postgresResult, redisResult] = await Promise.allSettled([
      checkPostgresHealth(),
      checkRedisHealth(),
    ]);

    const postgres =
      postgresResult.status === "fulfilled" &&
      postgresResult.value.status === "healthy";
    const redis =
      redisResult.status === "fulfilled" &&
      redisResult.value.status === "healthy";

    return {
      status: postgres && redis ? "healthy" : "unhealthy",
      services: { postgres, redis },
    };
  } catch (error) {
    return {
      status: "unhealthy",
      services: { postgres: false, redis: false },
    };
  }
};

export const ensureHealthyStart = async (
  config: StartupConfig = {},
): Promise<void> => {
  const {
    maxRetries = 3,
    retryDelay = 2000,
    allowDegraded = false,
    exitOnFailure = true,
  } = config;

  console.log("🔍 Checking system health before startup...");

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const health = await checkSystemHealth();

      if (health.overall.status === "healthy") {
        console.log("✅ All services healthy - proceeding with startup");
        return;
      }

      if (health.overall.status === "degraded" && allowDegraded) {
        console.warn("⚠️  Some services degraded but continuing startup");
        return;
      }

      if (attempt < maxRetries) {
        console.error(
          `❌ Health check failed (${attempt}/${maxRetries}): ${health.overall.message}`,
        );
        console.log(`   Retrying in ${retryDelay}ms...`);
        await new Promise((resolve) => setTimeout(resolve, retryDelay));
        continue;
      }

      console.error(`🚨 Health check failed after ${maxRetries} attempts`);
      console.error(`   Status: ${health.overall.status}`);
      console.error(`   Message: ${health.overall.message}`);

      Object.entries(health.services).forEach(([service, status]) => {
        const icon = status.status === "healthy" ? "✅" : "❌";
        console.error(
          `   ${icon} ${service}: ${status.status} (${status.responseTime}ms)${status.error ? ` - ${status.error}` : ""}`,
        );
      });

      if (exitOnFailure) {
        console.error("🛑 Exiting due to health check failure");
        process.exit(1);
      }

      throw new Error(`Health check failed: ${health.overall.message}`);
    } catch (error: any) {
      if (attempt < maxRetries) {
        console.error(
          `💥 Health check error (${attempt}/${maxRetries}): ${error.message}`,
        );
        console.log(`   Retrying in ${retryDelay}ms...`);
        await new Promise((resolve) => setTimeout(resolve, retryDelay));
        continue;
      }

      console.error("🚨 Health check failed with error:", error.message);

      if (exitOnFailure) {
        console.error("🛑 Exiting due to health check error");
        process.exit(1);
      }

      throw error;
    }
  }
};
