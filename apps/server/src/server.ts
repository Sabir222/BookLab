import express from "express";
import dotenv from "dotenv";
import cors, { type CorsOptions } from "cors";
import csrf from "csurf";
import helmet from "helmet";
import { authRouter } from "./features/auth/routes";
import cookieParser from "cookie-parser";
import session from "express-session";
import { healthRouter } from "./utils/checkhealth";
import { ensureHealthyStart } from "@repo/db/health";
import { connectRedis } from "@repo/db/redis";

// Load environment variables first
dotenv.config();

// Validate environment variables BEFORE any setup
function validateEnvironment() {
  const requiredVars = ["CORS_ORIGIN"]; // Add other required vars here
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

  // SESSION_SECRET validation
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

  // Validate PORT
  const port = process.env.PORT;
  if (
    port &&
    (isNaN(Number(port)) || Number(port) < 1 || Number(port) > 65535)
  ) {
    console.error("❌ PORT must be a valid number between 1 and 65535");
    process.exit(1);
  }

  console.log("✅ Environment validation passed");
}

// Validate environment before any app setup
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

const csrfProtection = csrf({
  cookie: {
    key: "_csrf",
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: process.env.NODE_ENV === "production" ? "strict" : "lax",
  },
  value: (req) => {
    return (
      req.body._csrf ||
      req.query._csrf ||
      req.headers["x-csrf-token"] ||
      req.headers["x-xsrf-token"]
    );
  },
});

app.get("/csrf-token", csrfProtection, (req, res) => {
  res.json({ csrfToken: req.csrfToken() });
});

// Protected routes with csrf  here
app.use("/auth", csrfProtection, authRouter);
// Unprotected routes without csrf here
app.use("/health", healthRouter);


// CSRF error handler
app.use(
  (
    err: any,
    req: express.Request,
    res: express.Response,
    next: express.NextFunction,
  ) => {
    if (err.code === "EBADCSRFTOKEN") {
      console.error("CSRF token validation failed:", {
        ip: req.ip,
        userAgent: req.get("User-Agent"),
        referer: req.get("Referer"),
        timestamp: new Date().toISOString(),
      });
      res.status(403).json({
        error: "Invalid CSRF token",
        message: "Request blocked for security reasons",
      });
    } else {
      next(err);
    }
  },
);

const startServer = async () => {
  await connectRedis();
  await ensureHealthyStart();
  app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${process.env.PORT}`);
  });
};

startServer();
