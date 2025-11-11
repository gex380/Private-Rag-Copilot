# API Specification - Private RAG Copilot

Version: 1.0
Base URL: `http://localhost:8000/api/v1`
Authentication: JWT Bearer Token (Week 6+)

---

## Table of Contents

1. [Authentication](#authentication)
2. [Document Management](#document-management)
3. [Query & Retrieval](#query--retrieval)
4. [Metrics](#metrics)
5. [Health & System](#health--system)
6. [Error Responses](#error-responses)

---

## Authentication

### POST `/auth/register`
**Week**: 6
**Description**: Register a new user account

**Request Body:**
```json
{
  "email": "user@example.com",
  "username": "johndoe",
  "password": "SecurePass123!",
  "full_name": "John Doe"
}
```

**Response (201 Created):**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "johndoe",
    "full_name": "John Doe",
    "role": "user",
    "created_at": "2025-01-15T10:30:00Z"
  },
  "access_token": "eyJhbGciOiJIUzI1...",
  "token_type": "bearer",
  "expires_in": 86400
}
```

---

### POST `/auth/login`
**Week**: 6
**Description**: Authenticate user and receive JWT token

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1...",
  "token_type": "bearer",
  "expires_in": 86400,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "johndoe",
    "role": "user"
  }
}
```

---

### POST `/auth/refresh`
**Week**: 6
**Description**: Refresh expired JWT token

**Headers:**
```
Authorization: Bearer <old_token>
```

**Response (200 OK):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1...",
  "token_type": "bearer",
  "expires_in": 86400
}
```

---

## Document Management

### POST `/ingest`
**Week**: 2
**Description**: Ingest a new document (PDF, DOCX, TXT, MD)

**Headers:**
```
Content-Type: multipart/form-data
Authorization: Bearer <token>  (Week 6+)
```

**Request Body:**
```
file: <file_upload>
metadata: {
  "title": "Q4 2024 Strategy Document",
  "department": "Operations",
  "tags": ["strategy", "2024", "operations"]
}
```

**Response (202 Accepted):**
```json
{
  "document_id": "uuid",
  "status": "processing",
  "message": "Document queued for ingestion",
  "estimated_chunks": 45
}
```

---

### GET `/documents`
**Week**: 2
**Description**: List all documents with pagination and filtering

**Query Parameters:**
- `page` (integer, default: 1): Page number
- `page_size` (integer, default: 20): Items per page
- `status` (string): Filter by status ('active', 'archived')
- `search` (string): Search in title
- `sort_by` (string, default: 'created_at'): Sort field
- `sort_order` (string, default: 'desc'): 'asc' or 'desc'

**Example:**
```
GET /documents?page=1&page_size=10&search=strategy&sort_by=title
```

**Response (200 OK):**
```json
{
  "documents": [
    {
      "id": "uuid",
      "title": "Q4 2024 Strategy Document",
      "source_type": "pdf",
      "file_size": 1024576,
      "page_count": 15,
      "chunk_count": 45,
      "metadata": {
        "department": "Operations",
        "tags": ["strategy", "2024"]
      },
      "created_at": "2025-01-15T10:30:00Z",
      "status": "active"
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 10,
    "total_items": 156,
    "total_pages": 16
  }
}
```

---

### GET `/documents/{document_id}`
**Week**: 2
**Description**: Get detailed information about a specific document

**Response (200 OK):**
```json
{
  "id": "uuid",
  "title": "Q4 2024 Strategy Document",
  "source_type": "pdf",
  "source_url": "/uploads/strategy_q4_2024.pdf",
  "file_size": 1024576,
  "page_count": 15,
  "metadata": {
    "department": "Operations",
    "author": "Jane Smith",
    "tags": ["strategy", "2024"]
  },
  "chunks": [
    {
      "chunk_index": 0,
      "chunk_text": "Executive Summary: Our Q4 2024 strategy focuses on...",
      "token_count": 245,
      "metadata": {
        "page": 1,
        "section": "Executive Summary"
      }
    }
  ],
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-01-15T10:32:00Z",
  "status": "active"
}
```

---

### DELETE `/documents/{document_id}`
**Week**: 2
**Description**: Delete a document and all its chunks

**Response (200 OK):**
```json
{
  "message": "Document deleted successfully",
  "document_id": "uuid",
  "chunks_deleted": 45
}
```

---

## Query & Retrieval

### POST `/query`
**Week**: 4
**Description**: Submit a query and get a grounded answer with citations

**Request Body:**
```json
{
  "query": "What were the strategic priorities for Q4 2024?",
  "top_k": 20,
  "rerank": true,
  "include_sources": true,
  "stream": false
}
```

**Request Body Parameters:**
- `query` (string, required): The user's question
- `top_k` (integer, default: 20): Number of chunks to retrieve
- `rerank` (boolean, default: false): Enable reranking (Week 3+)
- `include_sources` (boolean, default: true): Include source documents in response
- `stream` (boolean, default: false): Stream response (Week 5)

**Response (200 OK):**
```json
{
  "query_id": "uuid",
  "query": "What were the strategic priorities for Q4 2024?",
  "answer": "Based on the Q4 2024 Strategy Document, the strategic priorities were:\n\n1. **Customer Expansion**: Focus on enterprise clients in the healthcare sector [1]\n2. **Product Innovation**: Launch three new AI-powered features [2]\n3. **Operational Efficiency**: Reduce operational costs by 15% [1]\n\nThese priorities align with the company's goal of achieving 30% revenue growth year-over-year.",
  "citations": [
    {
      "citation_number": 1,
      "document_id": "uuid",
      "document_title": "Q4 2024 Strategy Document",
      "chunk_index": 3,
      "chunk_text": "Our primary focus for Q4 will be customer expansion, particularly targeting enterprise clients in the healthcare sector. Additionally, we aim to reduce operational costs by 15%...",
      "relevance_score": 0.92,
      "page": 2
    },
    {
      "citation_number": 2,
      "document_id": "uuid",
      "document_title": "Q4 2024 Strategy Document",
      "chunk_index": 7,
      "chunk_text": "On the product front, we're committed to launching three new AI-powered features that will differentiate us from competitors...",
      "relevance_score": 0.88,
      "page": 4
    }
  ],
  "metrics": {
    "retrieval_time_ms": 156,
    "generation_time_ms": 2341,
    "total_time_ms": 2497,
    "chunks_retrieved": 20,
    "chunks_used": 3,
    "tokens_used": 856
  },
  "created_at": "2025-01-15T14:23:45Z"
}
```

**Response (No Sufficient Context):**
```json
{
  "query_id": "uuid",
  "query": "What is the weather like today?",
  "answer": "I don't have enough context to answer that confidently. The available documents don't contain information about current weather conditions.",
  "citations": [],
  "metrics": {
    "retrieval_time_ms": 123,
    "generation_time_ms": 0,
    "total_time_ms": 123,
    "chunks_retrieved": 0,
    "chunks_used": 0
  },
  "created_at": "2025-01-15T14:25:00Z"
}
```

---

### GET `/query/{query_id}`
**Week**: 4
**Description**: Retrieve a previous query and its response

**Response (200 OK):**
Same format as POST `/query` response above.

---

### GET `/query/history`
**Week**: 7
**Description**: Get user's query history

**Query Parameters:**
- `page` (integer, default: 1)
- `page_size` (integer, default: 20)
- `start_date` (ISO date): Filter queries after this date
- `end_date` (ISO date): Filter queries before this date

**Response (200 OK):**
```json
{
  "queries": [
    {
      "query_id": "uuid",
      "query": "What were the strategic priorities?",
      "answer_preview": "Based on the Q4 2024 Strategy Document...",
      "citation_count": 3,
      "response_time_ms": 2497,
      "created_at": "2025-01-15T14:23:45Z"
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total_items": 48,
    "total_pages": 3
  }
}
```

---

## Metrics

### GET `/metrics/summary`
**Week**: 7
**Description**: Get aggregated system metrics

**Query Parameters:**
- `time_range` (string, default: '24h'): '1h', '24h', '7d', '30d'

**Response (200 OK):**
```json
{
  "time_range": "24h",
  "metrics": {
    "total_queries": 1247,
    "avg_response_time_ms": 2145,
    "p95_response_time_ms": 3890,
    "avg_retrieval_hit_rate": 0.87,
    "total_documents": 156,
    "total_chunks": 6842,
    "avg_citations_per_query": 2.4,
    "queries_without_answer": 34
  },
  "time_series": [
    {
      "timestamp": "2025-01-15T00:00:00Z",
      "query_count": 52,
      "avg_response_time_ms": 2098
    }
  ]
}
```

---

### GET `/metrics/retrieval`
**Week**: 7
**Description**: Detailed retrieval performance metrics

**Response (200 OK):**
```json
{
  "retrieval_stats": {
    "avg_chunks_retrieved": 18.5,
    "avg_chunks_used": 2.8,
    "hit_rate": 0.87,
    "avg_similarity_score": 0.82,
    "rerank_improvement": 0.15
  },
  "top_retrieved_documents": [
    {
      "document_id": "uuid",
      "document_title": "Q4 2024 Strategy Document",
      "retrieval_count": 234,
      "avg_relevance": 0.89
    }
  ]
}
```

---

## Health & System

### GET `/health`
**Week**: 1
**Description**: Health check endpoint

**Response (200 OK):**
```json
{
  "status": "healthy",
  "app_name": "Private RAG Copilot",
  "version": "1.0.0",
  "environment": "development",
  "timestamp": "2025-01-15T14:30:00Z",
  "dependencies": {
    "database": "connected",
    "vector_store": "connected",
    "openai_api": "available"
  }
}
```

---

### GET `/`
**Week**: 1
**Description**: API root with available endpoints

**Response (200 OK):**
```json
{
  "message": "Welcome to Private RAG Copilot",
  "version": "1.0.0",
  "docs": "/docs",
  "health": "/health",
  "endpoints": {
    "authentication": "/api/v1/auth",
    "documents": "/api/v1/documents",
    "query": "/api/v1/query",
    "metrics": "/api/v1/metrics"
  }
}
```

---

## Error Responses

All error responses follow this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      "field": "Additional context about the error"
    }
  },
  "request_id": "uuid"
}
```

### Common Error Codes

| Status Code | Error Code | Description |
|-------------|------------|-------------|
| 400 | `INVALID_REQUEST` | Invalid request format or parameters |
| 401 | `UNAUTHORIZED` | Missing or invalid authentication token |
| 403 | `FORBIDDEN` | Insufficient permissions |
| 404 | `NOT_FOUND` | Resource not found |
| 409 | `CONFLICT` | Resource already exists |
| 413 | `PAYLOAD_TOO_LARGE` | File upload exceeds limit |
| 422 | `UNPROCESSABLE_ENTITY` | Valid JSON but semantic errors |
| 429 | `RATE_LIMIT_EXCEEDED` | Too many requests |
| 500 | `INTERNAL_ERROR` | Server error |
| 503 | `SERVICE_UNAVAILABLE` | Temporary service unavailability |

### Example Error Response

```json
{
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Query text cannot be empty",
    "details": {
      "field": "query",
      "constraint": "min_length",
      "value": ""
    }
  },
  "request_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

---

## Rate Limiting

**Week**: 6+

Rate limits apply to authenticated requests:

- **Default**: 100 requests per minute
- **Query endpoints**: 20 requests per minute
- **Document ingestion**: 10 requests per minute

Rate limit headers are included in all responses:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1642259400
```

---

## Pagination

All list endpoints support pagination with the following parameters:

- `page` (integer, default: 1): Page number (1-indexed)
- `page_size` (integer, default: 20, max: 100): Items per page

Pagination info is included in the response:

```json
{
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total_items": 156,
    "total_pages": 8,
    "has_next": true,
    "has_previous": false
  }
}
```

---

## Versioning

The API uses URL versioning (`/api/v1`). When breaking changes are introduced, a new version will be released (`/api/v2`) while maintaining backward compatibility for v1.

---

## OpenAPI / Swagger

Interactive API documentation is available at:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI JSON**: http://localhost:8000/openapi.json

*(Disabled in production when `DEBUG=false`)*

---

## Development Timeline

| Week | Endpoints Available |
|------|-------------------|
| 1 | `/health`, `/` |
| 2 | `/ingest`, `/documents/*` |
| 3 | Retrieval with reranking support |
| 4 | `/query`, `/query/{id}` |
| 6 | `/auth/*`, Authentication required |
| 7 | `/metrics/*`, `/query/history` |

---

## Notes

1. All timestamps are in ISO 8601 format with UTC timezone
2. All IDs are UUIDs (v4)
3. Authentication is required for all endpoints starting Week 6 (except `/health` and `/`)
4. File uploads are limited to 50MB
5. Supported document formats: PDF, DOCX, PPTX, TXT, MD
6. Embedding dimension: 1536 (OpenAI text-embedding-3-small)

---

Last Updated: Week 1, January 2025
