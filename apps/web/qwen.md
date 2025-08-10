# BookLab Frontend

use tailwindcss
This is the frontend for BookLab, a bookstore platform that allows users to both purchase and rent books.

## Overview

BookLab is built with Next.js, TypeScript, and Tailwind CSS. The interface follows a minimal design philosophy with clean, simple components that prioritize usability and readability.

## Features

- Browse books available for purchase and rental
- Minimal, clean UI components
- Responsive design that works on all devices
- Fast performance with Next.js

## Design Principles

- Minimal styling with Tailwind CSS
- Focus on content and usability
- Clean, uncluttered interfaces
- Consistent component design

## Tech Stack

- [Next.js](https://nextjs.org/) - React framework
- [TypeScript](https://www.typescriptlang.org/) - Typed JavaScript
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- [shadcn/ui](https://ui.shadcn.com/) - Re-usable components built with Radix UI and Tailwind CSS

## Component Development Guidelines

When creating new components, follow these guidelines:

### 1. Check for Existing Components

Before creating a new component, check if a similar component already exists in the `components/ui` directory:

```bash
ls apps/web/components/ui
```

Common components like buttons, cards, alerts, etc. might already be available.

### 2. Using Existing shadcn/ui Components

If you find a component you need already exists (like the `button` component), import and use it directly:

```tsx
import { Button } from "@/components/ui/button";

export function MyComponent() {
  return <Button variant="default">Click me</Button>;
}
```

### 3. Adding New shadcn/ui Components

If you need a component that doesn't exist yet, you can install it using the shadcn/ui CLI:

```bash
npx shadcn-ui@latest add [component-name]
```

For example, to add a card component:

```bash
npx shadcn-ui@latest add card
```

### 4. Custom Component Creation

If you need to create a completely new component that doesn't exist in shadcn/ui:

1. Check if it can be built using existing components
2. Create the component in the appropriate directory:
   - `components/ui` for re-usable UI components
   - `components` for feature-specific components
3. Follow the existing patterns in the codebase
4. Use Tailwind CSS for styling with our minimal design approach

## Development

To run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

