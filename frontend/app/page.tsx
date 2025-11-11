export default function Home() {
  return (
    <div className="container mx-auto px-4 py-16">
      <div className="flex flex-col items-center justify-center space-y-8 text-center">
        <div className="space-y-4">
          <h1 className="text-4xl font-bold tracking-tighter sm:text-5xl md:text-6xl lg:text-7xl">
            Private RAG Copilot
          </h1>
          <p className="mx-auto max-w-[700px] text-gray-500 md:text-xl dark:text-gray-400">
            A secure, self-contained RAG assistant for querying internal documentation
            with grounded, cited answers.
          </p>
        </div>

        <div className="rounded-lg border bg-card p-8 text-card-foreground shadow-sm">
          <div className="space-y-4">
            <h2 className="text-2xl font-semibold">Week 1: Project Setup</h2>
            <p className="text-sm text-muted-foreground">
              Repository structure and environment configuration complete.
            </p>
            <div className="flex flex-col gap-2 text-left text-sm">
              <div className="flex items-center gap-2">
                <span className="text-green-500">✓</span>
                <span>Backend API structure initialized</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-green-500">✓</span>
                <span>Frontend Next.js app configured</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-gray-400">○</span>
                <span className="text-muted-foreground">
                  Document ingestion pipeline (Week 2)
                </span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-gray-400">○</span>
                <span className="text-muted-foreground">
                  Retrieval system (Week 3)
                </span>
              </div>
              <div className="flex items-center gap-2">
                <span className="text-gray-400">○</span>
                <span className="text-muted-foreground">
                  LLM generation with citations (Week 4)
                </span>
              </div>
            </div>
          </div>
        </div>

        <div className="flex flex-col gap-4 sm:flex-row">
          <a
            href="/docs"
            className="inline-flex h-10 items-center justify-center rounded-md bg-primary px-8 text-sm font-medium text-primary-foreground shadow transition-colors hover:bg-primary/90 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"
          >
            View Documentation
          </a>
          <a
            href="https://github.com/gex380/Private-Rag-Copilot"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex h-10 items-center justify-center rounded-md border border-input bg-background px-8 text-sm font-medium shadow-sm transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50"
          >
            View on GitHub
          </a>
        </div>
      </div>
    </div>
  )
}
