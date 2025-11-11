# Private RAG Copilot - Backend

Python FastAPI backend for the Private RAG Copilot system.

## Tech Stack

- **Framework**: FastAPI 0.109+
- **Python**: 3.10+
- **LLM Integration**: LangChain + OpenAI
- **Vector Store**: Supabase (pgvector) / Pinecone
- **Authentication**: JWT
- **Logging**: Structlog

## Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI application entry point
│   ├── config.py            # Configuration management
│   ├── api/                 # API route handlers
│   │   ├── query.py         # Query endpoints (Week 4)
│   │   ├── ingest.py        # Document ingestion (Week 2)
│   │   ├── auth.py          # Authentication (Week 6)
│   │   └── metrics.py       # Metrics endpoints (Week 7)
│   ├── core/                # Core business logic
│   │   ├── retriever.py     # Retrieval logic (Week 3)
│   │   ├── generator.py     # LLM generation (Week 4)
│   │   ├── embeddings.py    # Embedding generation (Week 2)
│   │   └── reranker.py      # Reranking logic (Week 3)
│   ├── ingestion/           # Document processing
│   │   ├── loader.py        # Document loaders (Week 2)
│   │   ├── chunker.py       # Text chunking (Week 2)
│   │   └── processor.py     # Processing pipeline (Week 2)
│   ├── db/                  # Database interactions
│   │   ├── vector_store.py  # Vector DB operations (Week 2)
│   │   └── models.py        # Data models (Week 2)
│   ├── auth/                # Authentication
│   │   ├── jwt.py           # JWT handling (Week 6)
│   │   └── security.py      # Security utilities (Week 6)
│   └── utils/               # Utilities
│       ├── logger.py        # Logging setup (Week 1)
│       └── metrics.py       # Metrics collection (Week 7)
├── tests/                   # Test suite (Week 7)
├── requirements.txt         # Production dependencies
├── requirements-dev.txt     # Development dependencies
├── .env.example            # Environment variables template
└── README.md               # This file
```

## Setup Instructions

### Prerequisites

- Python 3.10 or higher
- pip and venv
- OpenAI API key
- Supabase account (or Pinecone)

### 1. Create Virtual Environment

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate
```

### 2. Install Dependencies

```bash
# Install production dependencies
pip install -r requirements.txt

# For development (includes testing and linting tools)
pip install -r requirements-dev.txt
```

### 3. Configure Environment Variables

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your actual values
# At minimum, you need:
# - OPENAI_API_KEY
# - SUPABASE_URL and SUPABASE_KEY (or Pinecone credentials)
```

**Required Environment Variables:**
- `OPENAI_API_KEY`: Your OpenAI API key (get from https://platform.openai.com/)
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_KEY`: Your Supabase API key
- `JWT_SECRET_KEY`: Change from default for production

See [.env.example](.env.example) for all available configuration options.

### 4. Set Up Vector Database

#### Option A: Supabase (Recommended)

1. Create a Supabase project at https://supabase.com
2. Enable the pgvector extension:
   ```sql
   CREATE EXTENSION IF NOT EXISTS vector;
   ```
3. Run the database schema setup (Week 2)
4. Update `.env` with your Supabase credentials

#### Option B: Pinecone

1. Create a Pinecone account at https://www.pinecone.io
2. Create a new index with:
   - Dimensions: 1536 (for OpenAI text-embedding-3-small)
   - Metric: cosine
3. Update `.env` with:
   ```
   USE_PINECONE=true
   USE_SUPABASE=false
   PINECONE_API_KEY=your-key
   PINECONE_ENVIRONMENT=your-environment
   ```

### 5. Run the Application

```bash
# Development mode (with auto-reload)
python -m app.main

# Or using uvicorn directly
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at:
- **API**: http://localhost:8000
- **Docs**: http://localhost:8000/docs (Swagger UI)
- **ReDoc**: http://localhost:8000/redoc
- **Health**: http://localhost:8000/health

## Development

### Code Style

We use the following tools for code quality:

```bash
# Format code with Black
black app/ tests/

# Sort imports with isort
isort app/ tests/

# Lint with Ruff
ruff check app/ tests/

# Type check with mypy
mypy app/
```

### Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run specific test file
pytest tests/test_retriever.py

# Run in watch mode
pytest-watch
```

### Project Configuration Files

- **pyproject.toml**: Black, isort, mypy configuration (to be created in Week 2)
- **pytest.ini**: Pytest configuration (to be created in Week 7)
- **.env**: Local environment variables (not committed)

## API Endpoints (Planned)

### Week 1-2: Health & Setup
- `GET /health` - Health check ✅
- `GET /` - API information ✅

### Week 2: Document Ingestion
- `POST /api/v1/ingest` - Ingest document
- `GET /api/v1/documents` - List documents
- `DELETE /api/v1/documents/{id}` - Delete document

### Week 4: Query & Generation
- `POST /api/v1/query` - Submit query and get answer
- `GET /api/v1/query/{id}` - Get query result

### Week 6: Authentication
- `POST /api/v1/auth/register` - Register user
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/auth/refresh` - Refresh token

### Week 7: Metrics
- `GET /api/v1/metrics` - Get system metrics
- `GET /api/v1/metrics/queries` - Get query history

## Configuration

The application uses Pydantic Settings for configuration management. All settings can be configured via environment variables. See [app/config.py](app/config.py) for all available settings.

### Key Configuration Areas

1. **OpenAI Settings**: Model selection, temperature, token limits
2. **Vector Database**: Connection strings and settings
3. **Document Processing**: Chunk size and overlap
4. **Retrieval**: Top-K, similarity threshold, reranking
5. **Authentication**: JWT settings
6. **Logging**: Level and format

## Troubleshooting

### Common Issues

**Import errors after installing dependencies:**
```bash
# Ensure you're in the virtual environment
# Check with:
which python  # macOS/Linux
where python  # Windows

# Should point to venv/bin/python or venv\Scripts\python
```

**OpenAI API errors:**
- Verify your API key is correct
- Check you have credits available
- Ensure no rate limiting issues

**Database connection errors:**
- Verify Supabase URL and key are correct
- Check network connectivity
- Ensure pgvector extension is enabled

**Port already in use:**
```bash
# Change port in .env or run with different port
uvicorn app.main:app --port 8001
```

## Weekly Development Progress

- ✅ **Week 1**: Project setup, configuration, basic API structure
- ⏳ **Week 2**: Document ingestion and embedding generation
- ⏳ **Week 3**: Retrieval system and reranking
- ⏳ **Week 4**: LLM generation with grounding and citations
- ⏳ **Week 5**: Frontend integration
- ⏳ **Week 6**: Authentication and security
- ⏳ **Week 7**: Testing and metrics
- ⏳ **Week 8**: Polish and demo preparation

## Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [LangChain Documentation](https://python.langchain.com/)
- [OpenAI API Reference](https://platform.openai.com/docs/api-reference)
- [Supabase Documentation](https://supabase.com/docs)
- [Pinecone Documentation](https://docs.pinecone.io/)

## License

Private and proprietary - Unify Consulting
