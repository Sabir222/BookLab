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
import userRouter from "./features/user/routes/index.js";
import newsletterRouter from "./features/newsletter/routes/index.js";
import { validateEnvironment } from "./utils/validateEnv.js";

dotenv.config();

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
app.use("/api/users", userRouter);
app.use("/api/newsletter", newsletterRouter);

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
