import express from "express";
import dotenv from "dotenv";
import cors, { type CorsOptions } from "cors";
import csrf from "csurf";
import helmet from "helmet";
import { authRouter } from "./features/auth/routes";
import cookieParser from "cookie-parser";
import { testConnection } from "@repo/db/database";
import session from "express-session";

dotenv.config();

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
    secret: process.env.SESSION_SECRET || "fallback-secret-key",
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

// Protected routes with csrf add here
app.use("/auth", csrfProtection, authRouter);
/**
 * UNPROTECTED ROUTES (add here if needed)
 * - Routes that don't need CSRF protection
 * - Examples: webhooks, public APIs, health checks
 * - app.use("/webhooks", webhookRouter); // No csrfProtection middleware
 * - app.use("/health", healthRouter);    // No csrfProtection middleware
 */
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
  await testConnection();

  app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${process.env.PORT}`);
  });
};

startServer();
