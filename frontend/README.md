# Private RAG Copilot - Frontend

Next.js 14 frontend application for the Private RAG Copilot system.

## Tech Stack

- **Framework**: Next.js 14 with App Router
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **UI Components**: Custom components with Shadcn UI patterns
- **State Management**: Zustand
- **Data Fetching**: TanStack Query (React Query)
- **HTTP Client**: Axios
- **Markdown Rendering**: react-markdown with remark-gfm

## Project Structure

```
frontend/
├── app/                     # Next.js App Router pages
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Home page
│   ├── globals.css         # Global styles and Tailwind
│   └── (routes)/           # Additional routes (Week 5)
├── components/             # React components
│   ├── ui/                 # Reusable UI components
│   ├── query/              # Query interface components (Week 5)
│   ├── upload/             # Document upload components (Week 5)
│   └── metrics/            # Metrics dashboard components (Week 7)
├── lib/                    # Utility functions and configurations
│   ├── api.ts              # API client setup
│   ├── utils.ts            # Helper functions
│   └── store.ts            # Zustand store (Week 5)
├── styles/                 # Additional stylesheets (if needed)
├── public/                 # Static assets
├── .env.example            # Environment variables template
├── next.config.js          # Next.js configuration
├── tailwind.config.ts      # Tailwind configuration
├── tsconfig.json           # TypeScript configuration
├── package.json            # Dependencies and scripts
└── README.md               # This file
```

## Setup Instructions

### Prerequisites

- Node.js 18 or higher
- npm 9 or higher
- Backend API running (see `../backend/README.md`)

### 1. Install Dependencies

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install
```

### 2. Configure Environment Variables

```bash
# Copy example environment file
cp .env.example .env.local

# Edit .env.local with your actual values
# At minimum, set:
# - NEXT_PUBLIC_API_URL (backend API URL)
```

### 3. Run Development Server

```bash
# Start development server
npm run dev

# Open browser to http://localhost:3000
```

The application will be available at:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000 (should be running separately)

## Development Scripts

```bash
# Development server with hot reload
npm run dev

# Production build
npm run build

# Start production server (requires build first)
npm start

# Run linter
npm run lint

# Type checking
npm run type-check

# Format code with Prettier
npm run format
```

## Environment Variables

All environment variables for the browser must be prefixed with `NEXT_PUBLIC_`.

| Variable | Description | Default |
|----------|-------------|---------|
| `NEXT_PUBLIC_API_URL` | Backend API base URL | `http://localhost:8000` |
| `NEXT_PUBLIC_API_PREFIX` | API route prefix | `/api/v1` |
| `NEXT_PUBLIC_ENABLE_AUTH` | Enable authentication features | `false` |
| `NEXT_PUBLIC_ENABLE_METRICS` | Enable metrics dashboard | `false` |
| `NEXT_PUBLIC_ENABLE_DOCUMENT_UPLOAD` | Enable document upload | `false` |

See [.env.example](.env.example) for all available options.

## Key Features (by Week)

### Week 1: Setup ✅
- Next.js 14 with App Router
- TypeScript configuration
- Tailwind CSS styling
- Project structure and basic layout

### Week 5: Query Interface
- Query input component
- Response display with citations
- Source document viewer
- Loading states and error handling

### Week 5: Document Management
- Document upload interface
- Document list view
- Document preview modal

### Week 6: Authentication
- Login/register forms
- Protected routes
- JWT token management
- User profile

### Week 7: Metrics Dashboard
- Query statistics
- Response time charts
- Retrieval hit rate visualization
- Usage analytics

## Component Guidelines

### Creating New Components

Components should follow these patterns:

```typescript
// components/ui/button.tsx
import { cn } from '@/lib/utils'

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'primary' | 'secondary'
}

export function Button({ className, variant = 'default', ...props }: ButtonProps) {
  return (
    <button
      className={cn(
        'inline-flex items-center justify-center rounded-md text-sm font-medium',
        variant === 'primary' && 'bg-primary text-primary-foreground',
        className
      )}
      {...props}
    />
  )
}
```

### Utility Functions

Use the `cn()` utility from `lib/utils.ts` for conditional class names:

```typescript
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

## Styling Guidelines

### Tailwind CSS

- Use Tailwind utility classes for styling
- Follow mobile-first responsive design
- Use CSS variables for theming (see `app/globals.css`)
- Maintain consistent spacing using Tailwind's spacing scale

### Dark Mode

Dark mode is supported via the `dark` class on the `<html>` element:

```typescript
// Toggle dark mode
document.documentElement.classList.toggle('dark')
```

### Custom Colors

Colors are defined in `tailwind.config.ts` using CSS variables:

```css
:root {
  --primary: 221.2 83.2% 53.3%;
  --foreground: 222.2 84% 4.9%;
  /* ... */
}
```

## API Integration

### Setting Up API Client

```typescript
// lib/api.ts
import axios from 'axios'

const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL + process.env.NEXT_PUBLIC_API_PREFIX,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Add request interceptor for auth token
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export default apiClient
```

### Using React Query

```typescript
'use client'

import { useQuery } from '@tanstack/react-query'
import apiClient from '@/lib/api'

export function useDocuments() {
  return useQuery({
    queryKey: ['documents'],
    queryFn: async () => {
      const { data } = await apiClient.get('/documents')
      return data
    },
  })
}
```

## Testing

```bash
# Run tests (to be set up in Week 7)
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage
```

## Building for Production

```bash
# Create optimized production build
npm run build

# Test production build locally
npm start

# The build output will be in the .next/ directory
```

## Deployment

### Vercel (Recommended)

1. Push code to GitHub
2. Import project in Vercel
3. Configure environment variables
4. Deploy

### Other Platforms

The application can be deployed to any platform that supports Node.js:
- Netlify
- AWS Amplify
- DigitalOcean App Platform
- Docker (see `../infra/Dockerfile`)

## Troubleshooting

### Common Issues

**Module not found errors:**
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

**TypeScript errors:**
```bash
# Run type checking
npm run type-check

# Fix auto-fixable issues
npm run lint -- --fix
```

**Tailwind classes not working:**
- Ensure the path is included in `tailwind.config.ts` content array
- Check that PostCSS is configured correctly
- Clear Next.js cache: `rm -rf .next`

**API connection errors:**
- Verify backend is running on the correct port
- Check `NEXT_PUBLIC_API_URL` in `.env.local`
- Check CORS configuration in backend

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [React Documentation](https://react.dev)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TanStack Query Documentation](https://tanstack.com/query/latest/docs/react)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)

## Weekly Development Progress

- ✅ **Week 1**: Next.js setup, TypeScript, Tailwind configuration
- ⏳ **Week 5**: Query interface and document management UI
- ⏳ **Week 6**: Authentication UI and protected routes
- ⏳ **Week 7**: Metrics dashboard and testing
- ⏳ **Week 8**: Polish, optimization, and final demo

## License

Private and proprietary - Unify Consulting
