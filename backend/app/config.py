"""
Configuration management for Private RAG Copilot.

Uses Pydantic Settings for type-safe configuration from environment variables.
"""

from typing import Optional, List
from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore"
    )

    # Application Settings
    app_name: str = "Private RAG Copilot"
    app_version: str = "1.0.0"
    debug: bool = Field(default=False, description="Enable debug mode")
    environment: str = Field(default="development", description="Environment: development, staging, production")

    # API Settings
    api_host: str = Field(default="0.0.0.0", description="API host")
    api_port: int = Field(default=8000, description="API port")
    api_prefix: str = Field(default="/api/v1", description="API route prefix")

    # CORS Settings
    cors_origins: List[str] = Field(
        default=["http://localhost:3000", "http://localhost:8000"],
        description="Allowed CORS origins"
    )

    # OpenAI Settings
    openai_api_key: str = Field(..., description="OpenAI API key (required)")
    openai_model: str = Field(
        default="gpt-4-turbo-preview",
        description="OpenAI model for generation"
    )
    openai_embedding_model: str = Field(
        default="text-embedding-3-small",
        description="OpenAI embedding model"
    )
    openai_temperature: float = Field(
        default=0.1,
        ge=0.0,
        le=2.0,
        description="Temperature for LLM generation"
    )
    openai_max_tokens: int = Field(
        default=1000,
        ge=1,
        description="Max tokens for LLM response"
    )

    # Vector Database Settings (Supabase)
    use_supabase: bool = Field(default=True, description="Use Supabase as vector store")
    supabase_url: Optional[str] = Field(default=None, description="Supabase project URL")
    supabase_key: Optional[str] = Field(default=None, description="Supabase anon/service key")

    # Vector Database Settings (Pinecone - alternative)
    use_pinecone: bool = Field(default=False, description="Use Pinecone as vector store")
    pinecone_api_key: Optional[str] = Field(default=None, description="Pinecone API key")
    pinecone_environment: Optional[str] = Field(default=None, description="Pinecone environment")
    pinecone_index_name: str = Field(default="rag-copilot", description="Pinecone index name")

    # PostgreSQL Settings (for Supabase/pgvector)
    postgres_host: Optional[str] = Field(default=None, description="PostgreSQL host")
    postgres_port: int = Field(default=5432, description="PostgreSQL port")
    postgres_user: Optional[str] = Field(default=None, description="PostgreSQL user")
    postgres_password: Optional[str] = Field(default=None, description="PostgreSQL password")
    postgres_db: Optional[str] = Field(default="postgres", description="PostgreSQL database name")

    @property
    def postgres_url(self) -> Optional[str]:
        """Construct PostgreSQL connection URL."""
        if all([self.postgres_host, self.postgres_user, self.postgres_password]):
            return (
                f"postgresql://{self.postgres_user}:{self.postgres_password}"
                f"@{self.postgres_host}:{self.postgres_port}/{self.postgres_db}"
            )
        return None

    # Document Processing Settings
    chunk_size: int = Field(
        default=1000,
        ge=100,
        le=4000,
        description="Character count per chunk"
    )
    chunk_overlap: int = Field(
        default=200,
        ge=0,
        le=1000,
        description="Character overlap between chunks"
    )

    # Retrieval Settings
    retrieval_top_k: int = Field(
        default=20,
        ge=1,
        le=100,
        description="Number of documents to retrieve initially"
    )
    rerank_top_k: int = Field(
        default=3,
        ge=1,
        le=20,
        description="Number of documents after reranking"
    )
    enable_reranking: bool = Field(
        default=False,
        description="Enable reranking (Week 3 feature)"
    )
    similarity_threshold: float = Field(
        default=0.7,
        ge=0.0,
        le=1.0,
        description="Minimum similarity score for retrieval"
    )

    # Authentication Settings
    jwt_secret_key: str = Field(
        default="CHANGE_ME_IN_PRODUCTION",
        description="JWT secret key (MUST change in production)"
    )
    jwt_algorithm: str = Field(default="HS256", description="JWT algorithm")
    jwt_expiry_minutes: int = Field(
        default=1440,  # 24 hours
        ge=1,
        description="JWT token expiry in minutes"
    )

    # Logging Settings
    log_level: str = Field(
        default="INFO",
        description="Logging level: DEBUG, INFO, WARNING, ERROR, CRITICAL"
    )
    log_format: str = Field(
        default="json",
        description="Log format: json or console"
    )

    # Rate Limiting (Week 6)
    rate_limit_enabled: bool = Field(default=False, description="Enable rate limiting")
    rate_limit_requests: int = Field(default=100, description="Max requests per window")
    rate_limit_window_seconds: int = Field(default=60, description="Rate limit window in seconds")

    # Metrics Settings
    enable_metrics: bool = Field(default=True, description="Enable metrics collection")
    metrics_log_queries: bool = Field(default=True, description="Log all queries for analysis")

    @field_validator("log_level")
    @classmethod
    def validate_log_level(cls, v: str) -> str:
        """Validate log level is valid."""
        valid_levels = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        v_upper = v.upper()
        if v_upper not in valid_levels:
            raise ValueError(f"log_level must be one of {valid_levels}")
        return v_upper

    @field_validator("environment")
    @classmethod
    def validate_environment(cls, v: str) -> str:
        """Validate environment is valid."""
        valid_envs = ["development", "staging", "production"]
        v_lower = v.lower()
        if v_lower not in valid_envs:
            raise ValueError(f"environment must be one of {valid_envs}")
        return v_lower

    def __repr__(self) -> str:
        """Safe representation that doesn't expose secrets."""
        return (
            f"Settings(app_name='{self.app_name}', "
            f"environment='{self.environment}', "
            f"debug={self.debug})"
        )


# Global settings instance
settings = Settings()
