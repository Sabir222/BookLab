import express from "express";
import dotenv from "dotenv";
import cors, { type CorsOptions } from "cors";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import session from "express-session";
import { healthRouter } from "./utils/checkhealth.js";
import { ensureHealthyStart } from "@repo/db/health";
import { connectRedis, registerRedisShutdownHandlers } from "@repo/db/redis";
import bookPublicRouter from "./features/book/routes/index.js";
import authRouter from "./features/auth/routes/index.js";

dotenv.config();

function validateEnvironment() {
  const requiredVars = ["CORS_ORIGIN"];
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

  if (!process.env.SESSION_SECRET) {
    if (process.env.NODE_ENV === "production") {
      console.error(
        "❌ SESSION_SECRET environment variable must be set in production.",
      );
      process.exit(1);
    } else {
      console.warn(
        "⚠️  Warning: SESSION_SECRET is not set. Using insecure fallback for development only.",
      );
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

  console.log("Environment validation passed");
}

validateEnvironment();

const app = express();

app.get("/", (_req, res) => {
  res.send("Hello from Express with Bun!");
});

const PORT = process.env.PORT || 5000;

const corsOptions: CorsOptions = {
  origin: (origin, callback) => {
    const origins = String(process.env.CORS_ORIGIN).split(",");
    if (!origin || origins.includes(String(origin))) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed."), false);
    }
  },
  credentials: true,
  optionsSuccessStatus: 200,
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
};

app.use(cors(corsOptions));
app.use(cookieParser());
app.use(helmet());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
  session({
    secret: (process.env.SESSION_SECRET as string) || "fallback-secret-key",
    resave: false,
    saveUninitialized: false,
    cookie: {
      secure: process.env.NODE_ENV === "production",
      httpOnly: true,
      maxAge: 24 * 60 * 60 * 1000,
      sameSite: process.env.NODE_ENV === "production" ? "strict" : "lax",
    },
  }),
);

// Routes
app.use("/api/auth", authRouter);
app.use("/api/health", healthRouter);
app.use("/api/books", bookPublicRouter);

const startServer = async () => {
  try {
    await connectRedis();
    await ensureHealthyStart();
    const server = app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
      console.log(`Environment: ${process.env.NODE_ENV || "development"}`);
    });

    server.on("error", (error: NodeJS.ErrnoException) => {
      if (error.code === "EADDRINUSE") {
        console.error(`Port ${PORT} is already in use`);
      } else {
        console.error("Server error:", error);
      }
      process.exit(1);
    });

    registerRedisShutdownHandlers();

    return server;
  } catch (error) {
    console.error("Failed to start server:", error);
    process.exit(1);
  }
};

startServer();
