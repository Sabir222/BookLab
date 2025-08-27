import express from "express";
import dotenv from "dotenv";
import cors, { type CorsOptions } from "cors";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import session from "express-session";
import swaggerUi from "swagger-ui-express";
import { healthRouter } from "./utils/checkhealth.js";
import { connectRedis, registerRedisShutdownHandlers } from "@repo/db/redis";
import bookPublicRouter from "./features/book/routes/index.js";
import authRouter from "./features/auth/routes/index.js";
import userRouter from "./features/user/routes/index.js";
import { validateEnvironment } from "./utils/validateEnv.js";
import swaggerDocument from "./docs/swagger.json" with { type: "json" };

dotenv.config();

validateEnvironment();

const app = express();
app.set("trust proxy", 1);

app.get("/", (_req, res) => {
  res.send("Hello from Express with Bun!");
});

const PORT = process.env.PORT || 4000;
const corsOptions: CorsOptions = {
  origin: function (origin, callback) {
    const allowedOrigins = [
      "https://book-lab-web-f7jd.vercel.app",
      "https://booklab.ddns.net",
    ];
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  },
  credentials: true,
  optionsSuccessStatus: 200,
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
};
// const corsOptions: CorsOptions = {
//   origin: (origin, callback) => {
//     const origins = String(process.env.CORS_ORIGIN).split(",");
//     if (!origin || origins.includes(String(origin))) {
//       callback(null, true);
//     } else {
//       callback(new Error("Not allowed."), false);
//     }
//   },
//   credentials: true,
//   optionsSuccessStatus: 200,
//   methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
// };

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
      sameSite: process.env.NODE_ENV === "production" ? "none" : "lax",
    },
  }),
);

// Swagger UI documentation route
app.use("/api/docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Routes
app.use("/api/auth", authRouter);
app.use("/api/health", healthRouter);
app.use("/api/books", bookPublicRouter);
app.use("/api/users", userRouter);

const startServer = async () => {
  try {
    await connectRedis();
    // await ensureHealthyStart(); // Commented out to avoid unused variable warning
    const server = app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
      console.log(`Environment: ${process.env.NODE_ENV || "development"}`);
      console.log(`Swagger UI available at http://localhost:${PORT}/api/docs`);
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
