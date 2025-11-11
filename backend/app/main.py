"""
Main FastAPI application for Private RAG Copilot.

This module initializes the FastAPI application, sets up middleware,
and registers API routes.
"""

from contextlib import asynccontextmanager
from typing import AsyncGenerator

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.config import settings


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator:
    """
    Application lifespan manager.

    Handles startup and shutdown events for the application.
    """
    # Startup
    print(f"🚀 Starting {settings.app_name} v{settings.app_version}")
    print(f"📝 Environment: {settings.environment}")
    print(f"🔧 Debug mode: {settings.debug}")

    # TODO: Initialize vector database connection (Week 2)
    # TODO: Validate OpenAI API key (Week 2)
    # TODO: Load any cached embeddings (Week 3)

    yield

    # Shutdown
    print(f"🛑 Shutting down {settings.app_name}")
    # TODO: Close database connections
    # TODO: Cleanup resources


# Initialize FastAPI application
app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    description="A secure, self-contained RAG assistant for querying internal documentation",
    docs_url="/docs" if settings.debug else None,  # Disable docs in production
    redoc_url="/redoc" if settings.debug else None,
    lifespan=lifespan,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Health check endpoint
@app.get("/health", tags=["System"])
async def health_check():
    """Health check endpoint."""
    return JSONResponse(
        content={
            "status": "healthy",
            "app_name": settings.app_name,
            "version": settings.app_version,
            "environment": settings.environment,
        }
    )


# Root endpoint
@app.get("/", tags=["System"])
async def root():
    """Root endpoint with API information."""
    return JSONResponse(
        content={
            "message": f"Welcome to {settings.app_name}",
            "version": settings.app_version,
            "docs": "/docs" if settings.debug else "Disabled in production",
            "health": "/health",
        }
    )


# TODO: Register API routers (Week 2+)
# from app.api import query, ingest, auth, metrics
# app.include_router(query.router, prefix=settings.api_prefix, tags=["Query"])
# app.include_router(ingest.router, prefix=settings.api_prefix, tags=["Ingestion"])
# app.include_router(auth.router, prefix=settings.api_prefix, tags=["Authentication"])
# app.include_router(metrics.router, prefix=settings.api_prefix, tags=["Metrics"])


# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    """Global exception handler for unhandled errors."""
    print(f"❌ Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "message": str(exc) if settings.debug else "An unexpected error occurred",
        },
    )


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "app.main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.debug,
        log_level=settings.log_level.lower(),
    )
