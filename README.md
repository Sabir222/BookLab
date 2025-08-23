# BookLab 📚

**BookLab** is a full-stack web application built for learning purposes. It allows users to:

- 📖 Rent and sell books
- 💬 Comment and discuss books with an upvote system

## 🛠️ Tech Stack

| Category | Technologies |
|---------|--------------|
| **Frontend** | ![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=next.js&logoColor=white) ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white) ![TailwindCSS](https://img.shields.io/badge/TailwindCSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white) |
| **Backend** | ![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white) ![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white) |
| **Database** | ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white) ![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white) |
| **Tools** | ![Turborepo](https://img.shields.io/badge/Turborepo-000000?style=for-the-badge&logo=turborepo&logoColor=white) ![PNPM](https://img.shields.io/badge/PNPM-F69220?style=for-the-badge&logo=pnpm&logoColor=white) ![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white) |

## 🏗️ Architecture

BookLab follows a monorepo architecture powered by [Turborepo](https://turbo.build/repo) with the following structure:

```
├── apps/
│   ├── server/         # Express.js backend API
│   └── web/            # Next.js frontend
├── packages/
│   ├── db/             # Database layer (PostgreSQL & Redis)
│   ├── types/          # Shared TypeScript types
│   ├── eslint-config/  # Shared ESLint configuration
│   └── typescript-config/ # Shared TypeScript configuration
```

### Apps

- [Backend](./apps/server/)
- [Frontend](./apps/web)

### Packages

- [Db](./packages/db)
- [Types](./packages/types)

## ▶️ Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- [PNPM](https://pnpm.io/) (v8 or higher)
- [PostgreSQL](https://www.postgresql.org/)
- [Redis](https://redis.io/)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/BookLab.git
   cd BookLab
   ```

2. Install dependencies:
   ```bash
   pnpm install
   ```

3. Set up environment variables (see individual app READMEs for details)

4. Start the development servers:
   ```bash
   pnpm dev
   ```

This will start both the frontend (port 3000) and backend (port 4000) servers simultaneously.

## 🚀 Purpose

This project is designed as a **learning playground** to:

- Practice full-stack development
- Explore monorepo architecture using [Turborepo](https://turbo.build/)
- Learn how to integrate multiple languages and frameworks together

## 📜 License

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

You are free to use, share, and adapt the code for **non-commercial purposes**.  
For commercial use, please contact the author for permission.
