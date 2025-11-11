# Architectural Decision Log

> A record of significant technical and architectural decisions made during the development of the Private RAG Copilot.

This document uses the **Architecture Decision Record (ADR)** format to capture key decisions, context, and rationale. Each decision is numbered sequentially for easy reference.

---

## Template

```
## ADR-XXX: [Decision Title]

**Date**: YYYY-MM-DD
**Status**: [Proposed | Accepted | Deprecated | Superseded]
**Deciders**: [Names or roles]
**Context**: What is the issue we're trying to address?
**Decision**: What did we decide?
**Consequences**: What are the trade-offs and implications?
**Alternatives Considered**: What other options did we evaluate?
```

---

## ADR-001: Technology Stack Selection

**Date**: 2025-10-XX (Week 1)
**Status**: Accepted
**Deciders**: Marco Predovic, Development Team

### Context
We need to select a technology stack that:
- Supports rapid RAG system development
- Provides strong LLM and vector database integrations
- Enables production-ready deployment
- Is familiar to the development team

### Decision
**Backend**: Python with FastAPI + LangChain
**Frontend**: Next.js with TypeScript
**Vector DB**: Supabase (PostgreSQL with pgvector) as primary option, Pinecone as alternative
**LLM**: OpenAI GPT-4-turbo for generation, with path for local models (Llama 3)
**Embeddings**: OpenAI text-embedding-3-small

### Consequences
**Positive**:
- Python + LangChain provides extensive RAG tooling
- FastAPI enables high-performance async APIs
- Next.js offers excellent developer experience and SEO
- Supabase provides integrated vector DB + auth + storage
- OpenAI models offer state-of-the-art quality

**Negative**:
- OpenAI dependency creates vendor lock-in
- Supabase may have scaling limitations vs dedicated vector DBs
- Python requires careful async handling for performance

### Alternatives Considered
- **Node.js backend**: Rejected due to weaker LLM/RAG ecosystem
- **Chroma/Weaviate**: Considered but Supabase offers more integrated features
- **React (vanilla)**: Next.js preferred for SSR and routing capabilities

---

## ADR-002: Vector Database Schema Design

**Date**: 2025-10-XX (Week 1)
**Status**: Proposed
**Deciders**: Development Team

### Context
We need to design a vector database schema that supports:
- Document metadata storage
- Chunk-level embeddings
- Efficient similarity search
- Source attribution for citations

### Decision
Primary table structure:
```sql
CREATE TABLE document_chunks (
    id UUID PRIMARY KEY,
    document_id UUID NOT NULL,
    document_title TEXT NOT NULL,
    chunk_text TEXT NOT NULL,
    chunk_index INTEGER NOT NULL,
    embedding VECTOR(1536),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX ON document_chunks USING ivfflat (embedding vector_cosine_ops);
```

### Consequences
**Positive**:
- Clear separation of documents and chunks
- Flexible metadata storage with JSONB
- Efficient vector search with IVFFlat index
- Source attribution via document_id

**Negative**:
- Denormalized structure may lead to data duplication
- JSONB queries can be slower than typed columns

### Alternatives Considered
- **Separate documents table**: May implement in Phase 2 for normalization
- **Flat structure without chunks**: Rejected, limits chunking flexibility

---

## ADR-003: Chunking Strategy

**Date**: 2025-10-XX (Week 1-2)
**Status**: Proposed
**Deciders**: Development Team

### Context
Documents need to be split into manageable chunks for:
- Efficient embedding generation
- Relevant retrieval
- Context window management

### Decision
**Strategy**: Recursive character-based splitting with overlap
**Parameters**:
- Chunk size: 1000 characters
- Overlap: 200 characters
- Respect sentence boundaries when possible

**Implementation**: LangChain `RecursiveCharacterTextSplitter`

### Consequences
**Positive**:
- Maintains semantic coherence within chunks
- Overlap prevents context loss at boundaries
- Configurable for different document types

**Negative**:
- Fixed character count may split mid-sentence
- Overlap increases storage requirements
- May need tuning per document type

### Alternatives Considered
- **Semantic chunking**: More complex, deferred to Phase 2
- **Fixed token chunks**: Less human-readable, harder to debug
- **Paragraph-based**: Too variable in size

---

## ADR-004: Retrieval Strategy

**Date**: 2025-10-XX (Week 3)
**Status**: Proposed
**Deciders**: Development Team

### Context
We need a retrieval strategy that maximizes relevance while maintaining performance.

### Decision
**Hybrid retrieval approach**:
1. Vector similarity search (cosine similarity) - top 20 results
2. BM25 keyword search - top 20 results
3. Merge and deduplicate
4. Rerank using cross-encoder - return top 3

**Reranker**: HuggingFace `cross-encoder/ms-marco-MiniLM-L-6-v2`

### Consequences
**Positive**:
- Combines semantic and keyword matching strengths
- Reranker improves final relevance
- Handles both conceptual and exact-match queries

**Negative**:
- Increased latency due to multiple search passes
- Reranker adds compute overhead
- More complex to debug and tune

### Alternatives Considered
- **Vector-only search**: Simpler but misses exact matches
- **Keyword-only (BM25)**: Misses semantic similarity
- **Skip reranker**: Faster but lower quality results

---

## ADR-005: Prompt Engineering and Grounding

**Date**: 2025-10-XX (Week 4)
**Status**: Proposed
**Deciders**: Development Team

### Context
LLM responses must be grounded in retrieved context to prevent hallucination and ensure citation accuracy.

### Decision
**System Prompt Template**:
```
You are an enterprise knowledge assistant. Your role is to answer questions
based ONLY on the provided context documents.

Rules:
1. Use ONLY information from the provided context
2. Cite your sources using [Source: Document Title, Chunk #]
3. If the context doesn't contain enough information, respond with:
   "I don't have enough context to answer that confidently."
4. Never make up information or use external knowledge
5. Be concise and direct in your answers

Context:
{retrieved_chunks}

Question: {user_query}

Answer:
```

**Guardrail**: Post-generation validation that all facts have citations

### Consequences
**Positive**:
- Clear grounding instructions
- "Citation or silence" rule reduces hallucination
- Explicit instruction to avoid external knowledge

**Negative**:
- May produce "I don't know" responses even when tangentially related info exists
- Citation format needs consistent parsing
- Longer prompts increase token usage

### Alternatives Considered
- **Implicit grounding**: Less reliable, more hallucination risk
- **Fact verification pass**: Too slow and expensive
- **Fine-tuned model**: Out of scope for MVP

---

## ADR-006: Authentication Strategy

**Date**: 2025-10-XX (Week 6)
**Status**: Proposed
**Deciders**: Development Team

### Context
Demo system needs basic authentication to show enterprise readiness, but doesn't require full production security.

### Decision
**Demo authentication approach**:
- JWT-based token authentication
- Simple email/password registration and login
- Token expiry: 24 hours
- No SSO integration (deferred to post-MVP)

**Implementation**: Custom JWT with `pyjwt` library

### Consequences
**Positive**:
- Demonstrates auth capability for clients
- Simple implementation
- Stateless token design

**Negative**:
- Not production-grade security
- No password reset flow
- No MFA support

### Alternatives Considered
- **Clerk/Auth0**: More features but overkill for demo
- **No authentication**: Doesn't demonstrate enterprise readiness
- **API key only**: Less user-friendly for demo

---

## ADR-007: Frontend Framework and Styling

**Date**: 2025-10-XX (Week 5)
**Status**: Proposed
**Deciders**: Development Team

### Context
Need a modern, responsive UI that can be built quickly and looks professional for client demos.

### Decision
**Framework**: Next.js 14 with App Router
**Language**: TypeScript
**Styling**: Tailwind CSS
**Component Library**: Shadcn UI (headless components)
**State Management**: React hooks + Context API (no Redux for MVP)

### Consequences
**Positive**:
- Fast development with Tailwind utility classes
- Type safety with TypeScript
- Professional appearance with Shadcn components
- Good developer experience

**Negative**:
- Learning curve for Tailwind if team unfamiliar
- Less custom styling control with component library
- App Router is newer, less documentation

### Alternatives Considered
- **Material UI**: More opinionated, heavier bundle
- **Vanilla CSS**: Too slow for MVP timeline
- **Vue.js**: Team less familiar

---

## ADR-008: Monitoring and Observability

**Date**: 2025-10-XX (Week 7)
**Status**: Proposed
**Deciders**: Development Team

### Context
Need visibility into system performance, user behavior, and error patterns for demo and debugging.

### Decision
**Metrics Collection**:
- Application-level logging with `structlog` (JSON format)
- Custom metrics: query count, latency, retrieval hit rate, citation accuracy
- Store metrics in Supabase for simplicity

**Dashboard**: Custom React dashboard integrated in frontend
- Real-time query volume
- Average response time
- Retrieval statistics
- Recent queries log

### Consequences
**Positive**:
- All data in one place (Supabase)
- Custom dashboard tailored to demo needs
- Simple implementation

**Negative**:
- Not production-grade monitoring
- No alerting capability
- Limited historical data retention

### Alternatives Considered
- **Grafana + Prometheus**: Overkill for MVP scope
- **Datadog/New Relic**: Expensive for demo
- **No monitoring**: Doesn't demonstrate operational maturity

---

## ADR-009: Deployment Strategy

**Date**: 2025-10-XX (Week 8)
**Status**: Proposed
**Deciders**: Development Team

### Context
System needs to be easily deployable for demos and client pilots.

### Decision
**Primary deployment**: Docker Compose for local/single-server deployment
**Components**:
- Backend container (FastAPI)
- Frontend container (Next.js)
- Supabase (cloud-hosted)

**CI/CD**: GitHub Actions for automated testing
**Documentation**: Detailed deployment guide in README

### Consequences
**Positive**:
- Easy to spin up complete system
- Reproducible environments
- Platform-agnostic (Windows, Mac, Linux)

**Negative**:
- Not cloud-native (no Kubernetes)
- Manual scaling
- Single point of failure

### Alternatives Considered
- **Kubernetes**: Too complex for MVP
- **Serverless (Vercel + AWS Lambda)**: Harder to control costs for demo
- **Manual deployment**: Not reproducible enough

---

## Future Decisions (To Be Documented)

- **ADR-010**: Multi-tenancy architecture (Phase 2)
- **ADR-011**: Enterprise connector design (SharePoint, Confluence)
- **ADR-012**: Model fine-tuning approach
- **ADR-013**: On-premise deployment architecture
- **ADR-014**: Advanced security features (SSO, audit logs)

---

## Decision Review Process

### When to Create an ADR
- Selecting technologies or frameworks
- Designing system architecture
- Making significant implementation choices
- Changing existing architectural patterns

### Review Schedule
- ADRs reviewed weekly during team meetings
- Status updated as decisions are implemented
- Superseded ADRs kept for historical context

### Template Usage
Copy the template at the top of this document when creating new ADRs. Number them sequentially (ADR-XXX).

---

**Last Updated**: Week 1, October 2025
**Next Review**: Weekly during team meetings
