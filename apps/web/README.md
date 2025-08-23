# BookLab Frontend

A minimal, modern bookstore platform for buying and renting books, built with Next.js 15, TypeScript, and Tailwind CSS.

## Tech Stack

- **Framework**: [Next.js 15](https://nextjs.org/)
- **Language**: [TypeScript](https://www.typescriptlang.org/)
- **Styling**: [Tailwind CSS](https://tailwindcss.com/)
- **UI Components**: [shadcn/ui](https://ui.shadcn.com/)
- **State Management**: [Zustand](https://github.com/pmndrs/zustand)
- **Data Fetching**: [React Query](https://tanstack.com/query/latest)
- **Form Handling**: [React Hook Form](https://react-hook-form.com/)
- **Validation**: [Zod](https://zod.dev/)
- **Icons**: [Lucide React](https://lucide.dev/)

## Features

- 📚 Book browsing for purchase and rental
- 🎨 Minimal design with clean UI components
- ⚡ Server Components for optimal performance
- 📱 Fully responsive design
- 🔍 SEO optimized
- 🔐 Authentication (Login/Signup)
- 🛒 Shopping cart functionality
- 📋 Wishlist management
- 🔍 Advanced book search
- 👤 User profiles
- 📊 Admin dashboard

## Project Structure

```
apps/web/
├── app/                 # Next.js app directory
│   ├── api/             # API utility functions
│   ├── auth/            # Authentication pages
│   ├── books/           # Book-related pages
│   ├── categories/      # Category pages
│   ├── dashboard/       # Admin dashboard
│   └── ...
├── components/          # React components
│   ├── auth/            # Authentication components
│   ├── books/           # Book-related components
│   ├── home/            # Homepage components
│   ├── navbar/          # Navigation components
│   └── ui/              # Reusable UI components
├── lib/                 # Utility functions and helpers
├── public/              # Static assets
└── types/               # TypeScript types
```

## Key Components

### Authentication
- Login and signup forms with validation
- Session management with refresh tokens
- Protected routes

### Book Management
- Book listings with filtering and sorting
- Book detail pages with comprehensive information
- Book search functionality
- Category browsing

### User Features
- Shopping cart
- Wishlist
- User profile management

### Admin Dashboard
- Book management
- User management
- Analytics (coming soon)

## Development

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or higher)
- [PNPM](https://pnpm.io/) (v8 or higher)

### Environment Variables

Create a `.env.local` file in the web directory with the following variables:

```env
NEXT_PUBLIC_API_BASE_URL=http://localhost:4000
```

### Available Scripts

```bash
# Install dependencies
pnpm install

# Run development server
pnpm dev

# Build for production
pnpm build

# Start production server
pnpm start

# Lint code
pnpm lint

# Check TypeScript types
pnpm check-types

# Restart development server (clears cache)
pnpm restart
```

## UI Components

This project uses a custom component library built with shadcn/ui components. Key components include:

- Navbar with responsive design and search functionality
- Book cards with ratings and pricing information
- Category navigation menus
- Form components with validation
- Dashboard components for admin functionality

## Styling

The application uses Tailwind CSS for styling with a custom color palette defined in `tailwind.config.js`:

- Primary: `#2f2c2b` (dark brown)
- Secondary: `#b14446` (red)
- Accent: `#ece8e2` (light beige)
- Muted: `#c2c0bb` (light gray)
- Highlight: `#a2895e` (gold)

## API Integration

The frontend communicates with the backend API through:
- Custom fetch utilities with automatic token refresh
- React Query for data fetching and caching
- TypeScript types for API responses

## Authentication

The application implements JWT-based authentication with:
- Access token and refresh token rotation
- Automatic token refresh in middleware
- Protected route handling
- User session persistence

## Performance Optimizations

- Server Components for critical data fetching
- Code splitting and dynamic imports
- Image optimization with Next.js Image component
- React Query caching and background updates
- Bundle size optimization

## Responsive Design

The application is fully responsive and works on:
- Mobile devices
- Tablets
- Desktop computers

Media queries and Tailwind's responsive utilities are used throughout the application.

## SEO

The application is optimized for search engines with:
- Semantic HTML
- Proper meta tags
- Structured data
- Fast loading times
- Mobile-friendly design

## Deployment

The application can be deployed to any platform that supports Next.js, such as:
- Vercel (recommended)
- Netlify
- Self-hosted Node.js server

For production deployment, make sure to set the appropriate environment variables.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License](https://creativecommons.org/licenses/by-nc/4.0/).

You are free to use, share, and adapt the code for **non-commercial purposes**.
For commercial use, please contact the author for permission.