import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { DevToolbar } from '@/components/DevToolbar'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Private RAG Copilot',
  description: 'A secure, self-contained RAG assistant for querying internal documentation',
  keywords: ['RAG', 'AI', 'Knowledge Management', 'Enterprise Search'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <DevToolbar />
        <div className="relative flex min-h-screen flex-col">
          <main className="flex-1">{children}</main>
        </div>
      </body>
    </html>
  )
}
