import { Router, type Request, type Response } from "express";
import {
  checkSystemHealth,
  quickHealthCheck,
  checkPostgresHealth,
  checkRedisHealth,
} from "@repo/db/health";

export const healthRouter = Router();

healthRouter.get("/", async (_req: Request, res: Response) => {
  try {
    const healthStatus = await checkSystemHealth();
    const httpStatus =
      healthStatus.overall.status === "healthy"
        ? 200
        : healthStatus.overall.status === "degraded"
          ? 207
          : 503;
    res.status(httpStatus).json(healthStatus);
  } catch (error: any) {
    res.status(503).json({
      status: "unhealthy",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      services: {
        postgres: {
          status: "unknown",
          responseTime: 0,
          error: "Health check failed",
        },
        redis: {
          status: "unknown",
          responseTime: 0,
          error: "Health check failed",
        },
      },
      overall: {
        status: "unhealthy",
        message: `Health check system error: ${error.message}`,
      },
    });
  }
});

healthRouter.get("/quick", async (_req: Request, res: Response) => {
  try {
    const quickHealth = await quickHealthCheck();
    res.status(quickHealth.status === "healthy" ? 200 : 503).json({
      status: quickHealth.status,
      timestamp: new Date().toISOString(),
      services: quickHealth.services,
    });
  } catch (error: any) {
    res.status(503).json({
      status: "unhealthy",
      timestamp: new Date().toISOString(),
      services: { postgres: false, redis: false },
      error: error.message,
    });
  }
});

healthRouter.get("/postgres", async (_req: Request, res: Response) => {
  try {
    const postgresHealth = await checkPostgresHealth();
    const httpStatus = postgresHealth.status === "healthy" ? 200 : 503;
    res.status(httpStatus).json({
      service: "postgres",
      timestamp: new Date().toISOString(),
      ...postgresHealth,
    });
  } catch (error: any) {
    res.status(503).json({
      service: "postgres",
      status: "unhealthy",
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});

healthRouter.get("/redis", async (_req: Request, res: Response) => {
  try {
    const redisHealth = await checkRedisHealth();
    const httpStatus = redisHealth.status === "healthy" ? 200 : 503;
    res.status(httpStatus).json({
      service: "redis",
      timestamp: new Date().toISOString(),
      ...redisHealth,
    });
  } catch (error: any) {
    res.status(503).json({
      service: "redis",
      status: "unhealthy",
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});
