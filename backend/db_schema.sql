-- =============================================================================
-- Private RAG Copilot - Vector Database Schema
-- Database: PostgreSQL with pgvector extension (Supabase)
-- Version: 1.0
-- Week: 1-2
-- =============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- DOCUMENTS TABLE
-- Stores metadata about ingested documents
-- =============================================================================
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    source_type VARCHAR(50) NOT NULL,  -- 'pdf', 'docx', 'txt', 'md', etc.
    source_url TEXT,                    -- Original file path or URL
    file_size INTEGER,                  -- File size in bytes
    page_count INTEGER,                 -- Number of pages (if applicable)
    metadata JSONB DEFAULT '{}',        -- Additional metadata (author, date, tags, etc.)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID,                    -- User ID (for Week 6 auth)
    status VARCHAR(20) DEFAULT 'active' -- 'active', 'archived', 'deleted'
);

-- Indexes for documents table
CREATE INDEX idx_documents_status ON documents(status);
CREATE INDEX idx_documents_created_at ON documents(created_at DESC);
CREATE INDEX idx_documents_created_by ON documents(created_by);
CREATE INDEX idx_documents_metadata ON documents USING gin(metadata);

-- =============================================================================
-- DOCUMENT_CHUNKS TABLE
-- Stores chunked text with embeddings for vector search
-- =============================================================================
CREATE TABLE IF NOT EXISTS document_chunks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    chunk_index INTEGER NOT NULL,       -- Sequential index within document
    chunk_text TEXT NOT NULL,           -- The actual text content
    embedding VECTOR(1536),             -- OpenAI text-embedding-3-small is 1536 dimensions
    token_count INTEGER,                -- Number of tokens in chunk
    metadata JSONB DEFAULT '{}',        -- Chunk-specific metadata (page_num, section, etc.)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_document_chunk UNIQUE(document_id, chunk_index)
);

-- Indexes for document_chunks table
CREATE INDEX idx_chunks_document_id ON document_chunks(document_id);
CREATE INDEX idx_chunks_chunk_index ON document_chunks(document_id, chunk_index);

-- Vector similarity search index using IVFFlat
-- This creates an approximate nearest neighbor index for fast vector search
-- lists parameter: number of clusters (rule of thumb: sqrt(num_rows))
-- We'll start with 100 lists, can be tuned later based on data size
CREATE INDEX idx_chunks_embedding_ivfflat ON document_chunks
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- Alternative: HNSW index (more accurate but slower to build)
-- Uncomment if you prefer HNSW over IVFFlat
-- CREATE INDEX idx_chunks_embedding_hnsw ON document_chunks
-- USING hnsw (embedding vector_cosine_ops);

-- =============================================================================
-- QUERIES TABLE
-- Stores user queries for metrics and analysis
-- =============================================================================
CREATE TABLE IF NOT EXISTS queries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID,                       -- User who made the query (Week 6)
    query_text TEXT NOT NULL,
    response_text TEXT,                 -- Generated response
    retrieved_chunk_ids UUID[],         -- Array of chunk IDs retrieved
    response_time_ms INTEGER,           -- Total response time in milliseconds
    retrieval_time_ms INTEGER,          -- Time spent on retrieval
    generation_time_ms INTEGER,         -- Time spent on LLM generation
    citation_count INTEGER,             -- Number of citations in response
    feedback_score INTEGER,             -- User feedback (1-5) - Week 7
    metadata JSONB DEFAULT '{}',        -- Additional query metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for queries table
CREATE INDEX idx_queries_user_id ON queries(user_id);
CREATE INDEX idx_queries_created_at ON queries(created_at DESC);
CREATE INDEX idx_queries_metadata ON queries USING gin(metadata);

-- =============================================================================
-- USERS TABLE
-- For authentication (Week 6)
-- =============================================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) UNIQUE,
    password_hash TEXT NOT NULL,        -- Bcrypt hashed password
    full_name TEXT,
    role VARCHAR(50) DEFAULT 'user',    -- 'user', 'admin', 'viewer'
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);

-- =============================================================================
-- METRICS TABLE
-- Aggregated metrics for dashboard (Week 7)
-- =============================================================================
CREATE TABLE IF NOT EXISTS metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    metric_type VARCHAR(50) NOT NULL,   -- 'query_count', 'avg_latency', 'hit_rate', etc.
    metric_value NUMERIC NOT NULL,
    time_bucket TIMESTAMP WITH TIME ZONE NOT NULL,  -- Hourly or daily buckets
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for metrics table
CREATE INDEX idx_metrics_type_time ON metrics(metric_type, time_bucket DESC);

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Function to update updated_at timestamp automatically
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers to auto-update updated_at
CREATE TRIGGER update_documents_updated_at BEFORE UPDATE ON documents
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- VECTOR SIMILARITY SEARCH FUNCTION
-- Searches for similar chunks using cosine similarity
-- =============================================================================
CREATE OR REPLACE FUNCTION search_similar_chunks(
    query_embedding VECTOR(1536),
    match_threshold FLOAT DEFAULT 0.7,
    match_count INTEGER DEFAULT 10
)
RETURNS TABLE (
    chunk_id UUID,
    document_id UUID,
    document_title TEXT,
    chunk_text TEXT,
    chunk_index INTEGER,
    similarity FLOAT,
    metadata JSONB
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id AS chunk_id,
        c.document_id,
        d.title AS document_title,
        c.chunk_text,
        c.chunk_index,
        1 - (c.embedding <=> query_embedding) AS similarity,
        c.metadata
    FROM document_chunks c
    JOIN documents d ON c.document_id = d.id
    WHERE
        d.status = 'active'
        AND 1 - (c.embedding <=> query_embedding) > match_threshold
    ORDER BY c.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- Enable for production security (Week 6)
-- =============================================================================

-- Uncomment these for production with proper authentication
-- ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE document_chunks ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE queries ENABLE ROW LEVEL SECURITY;

-- Example policy: Users can only see their own documents
-- CREATE POLICY documents_user_policy ON documents
-- FOR ALL
-- USING (auth.uid() = created_by);

-- =============================================================================
-- SAMPLE DATA (for development/testing)
-- =============================================================================

-- Uncomment to insert sample document for testing
-- INSERT INTO documents (title, source_type, metadata)
-- VALUES ('Sample Policy Document', 'pdf', '{"department": "HR", "year": 2024}');

-- =============================================================================
-- HELPFUL QUERIES FOR DEVELOPMENT
-- =============================================================================

-- Check table sizes
-- SELECT
--     schemaname,
--     tablename,
--     pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
-- FROM pg_tables
-- WHERE schemaname = 'public'
-- ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Check vector index status
-- SELECT * FROM pg_indexes WHERE tablename = 'document_chunks';

-- Count embeddings by document
-- SELECT d.title, COUNT(c.id) as chunk_count
-- FROM documents d
-- LEFT JOIN document_chunks c ON d.id = c.document_id
-- GROUP BY d.id, d.title;

-- Test vector similarity search
-- SELECT * FROM search_similar_chunks(
--     (SELECT embedding FROM document_chunks LIMIT 1),
--     0.7,
--     5
-- );

-- =============================================================================
-- NOTES
-- =============================================================================
-- 1. Embedding dimension (1536) matches OpenAI text-embedding-3-small
--    Change to 3072 for text-embedding-3-large
-- 2. IVFFlat index requires ANALYZE after significant data changes
-- 3. For production, enable RLS and create appropriate policies
-- 4. Consider partitioning queries table by date for large datasets
-- 5. Adjust IVFFlat lists parameter based on dataset size (sqrt of rows)
-- 6. Regular VACUUM ANALYZE recommended for optimal vector search performance
