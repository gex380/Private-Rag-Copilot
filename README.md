# Private RAG Copilot for Client Knowledge

> A secure, self-contained Retrieval-Augmented Generation (RAG) assistant for querying internal documentation with grounded, cited answers.

## Overview

The Private RAG Copilot enables organizations to extract insights quickly from internal, unstructured documentation (policies, meeting notes, strategy decks, wikis) through a secure AI-powered assistant. By combining RAG system design, data ingestion, LLM integration, and secure document retrieval, it provides consultants and enterprise users with fast, accurate, and auditable answers.

**Owner:** Marco Predovic
**Version:** 1.0
**Status:** Week 1 Complete ✅ | Ready for Week 2 - Ingestion Pipeline

---

## Project Goals

### Primary Objectives
- **Build a private RAG pipeline**: End-to-end ingestion → retrieval → generation pipeline
- **Ensure factual, grounded outputs**: Citation accuracy ≥ 90%, hallucination < 10%
- **Optimize retrieval quality**: Retrieval hit rate ≥ 80% on test queries
- **Optimize latency**: Response time ≤ 4 seconds average
- **Enable reuse for client pilots**: Modular architecture, configurable data sources

### Business Impact
- **Client Value**: Reduces information retrieval time by 80%, increases consistency in deliverables
- **Reusable IP**: Can be repackaged for multiple client verticals (finance, healthcare, operations)

---

## Architecture

```
Document Upload → Text Splitter → Embeddings → Vector DB
                                                    ↓
                                              Retriever + Reranker
                                                    ↓
                                              LLM Generation
                                                    ↓
                                          Response + Citations
```

---

## Tech Stack

- **Backend**: Python, FastAPI, LangChain
- **Frontend**: Next.js, TypeScript
- **Vector DB**: Supabase/Pinecone
- **LLM**: OpenAI GPT-4-turbo / Llama 3
- **Embeddings**: OpenAI Embeddings
- **Auth**: JWT / Clerk
- **Infra**: Docker, GitHub Actions

---

## Project Structure

```
/private-rag-copilot/
├── backend/          # Python API, retrieval, and generation logic
├── frontend/         # Next.js web interface
├── data/             # Synthetic documents for demo
│   └── synthetic_docs/
├── evaluation/       # Test queries and metrics
├── infra/            # Docker, CI/CD configuration
├── README.md         # This file
├── PRD.md            # Full product requirements
├── ROADMAP.md        # 8-week development timeline
└── DECISIONS.md      # Architectural decision log
```

---

## Week 1 Checklist ✅ COMPLETE

### Repository Setup
- [x] Initialize Git repository
- [x] Create folder structure
- [x] Add core documentation (README, PRD, ROADMAP, DECISIONS)
- [x] Set up .gitignore for Python/Node.js
- [x] Create initial commit
- [x] Push to GitHub

### Environment Setup
- [x] Set up Python backend structure and modules
- [x] Create requirements.txt with core dependencies (LangChain, FastAPI, OpenAI)
- [x] Set up Next.js/TypeScript frontend project
- [x] Configure environment variables template (.env.example for both backend and frontend)
- [x] Document setup instructions (comprehensive READMEs)

### Planning & Design
- [x] Define success metrics and tracking method (in PRD and ROADMAP)
- [x] Create initial synthetic document dataset (3 realistic documents)
- [x] Design vector DB schema (PostgreSQL with pgvector)
- [x] Define API endpoints structure (30+ endpoints documented)
- [x] Document architectural decisions (9 ADRs in DECISIONS.md)

### Technical Foundation
- [x] FastAPI application with health check endpoints
- [x] Pydantic Settings configuration system (50+ typed settings)
- [x] Next.js 14 App Router with Tailwind CSS
- [x] Database schema with tables for documents, chunks, queries, users, metrics
- [x] Complete API specification document

---

## Week 2 Next Steps - Ingestion Pipeline

Ready to start **Week 2: Document Ingestion Pipeline**

### Key Objectives
1. Build document processing pipeline
2. Implement chunking and embedding generation
3. Set up vector database storage
4. Test with synthetic documents

### Tasks to Pick Up
- [ ] Set up Supabase account and run `backend/db_schema.sql`
- [ ] Configure OpenAI API key in `backend/.env`
- [ ] Create virtual environment and install dependencies
- [ ] Implement document loaders (`backend/app/ingestion/loader.py`)
- [ ] Implement text chunking (`backend/app/ingestion/chunker.py`)
- [ ] Implement embedding generation (`backend/app/core/embeddings.py`)
- [ ] Implement vector storage (`backend/app/db/vector_store.py`)
- [ ] Create ingestion API endpoint (`backend/app/api/ingest.py`)
- [ ] Test ingestion with synthetic documents from `data/synthetic_docs/`
- [ ] Verify embeddings are stored correctly in Supabase

### Success Criteria for Week 2
- ✅ Successfully ingest 10+ synthetic documents
- ✅ Embeddings stored in vector DB with proper metadata
- ✅ Processing time < 2 seconds per document
- ✅ Chunk quality validated manually

See [ROADMAP.md](ROADMAP.md#week-2-ingestion-pipeline) for detailed Week 2 plan.

---

## Getting Started

### Prerequisites
- Python 3.10+
- Node.js 18+
- Git
- Docker (optional, for containerized deployment)

### Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd Private-Rag-Copilot

# Backend setup
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Frontend setup
cd ../frontend
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your API keys
```

---

## Development Timeline

| Week | Focus | Status |
|------|-------|--------|
| Week 1 | Project Setup & Planning | ✅ Complete |
| Week 2 | Ingestion Pipeline | 🎯 **Next Up** |
| Week 3 | Retrieval System | ⏳ Pending |
| Week 4 | Generation & Prompting | ⏳ Pending |
| Week 5 | Frontend UI | ⏳ Pending |
| Week 6 | Security & Guardrails | ⏳ Pending |
| Week 7 | Monitoring & Testing | ⏳ Pending |
| Week 8 | Finalization & Demo | ⏳ Pending |

See [ROADMAP.md](ROADMAP.md) for detailed milestones.

---

## Documentation

- [PRD.md](PRD.md) - Complete Product Requirements Document
- [ROADMAP.md](ROADMAP.md) - Detailed 8-week development plan
- [DECISIONS.md](DECISIONS.md) - Architectural decisions and rationale

---

## Contributing

This is currently a private project for Unify Consulting demonstration purposes. If you're part of the team:

1. Create a feature branch from `main`
2. Make your changes
3. Submit a pull request with clear description
4. Ensure all tests pass before merging

---

## License

Private and proprietary - Unify Consulting

---

## Contact

**Project Owner**: Marco Predovic
**Organization**: Unify Consulting
**Purpose**: AI Systems & Engineering Demonstration

For questions or access requests, please contact the project owner.
