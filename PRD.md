# 🧠 Product Requirements Document (PRD)

**Project Name:** Private RAG Copilot for Client Knowledge
**Owner:** Marco Predovic
**Version:** 1.0
**Date:** October 2025

---

## 1. Executive Summary

Organizations struggle to extract insights quickly from their internal, unstructured documentation (policies, meeting notes, strategy decks, wikis). This leads to lost time, duplicated work, and inconsistent decision-making.

The **Private RAG Copilot** solves this by providing a **secure, self-contained Retrieval-Augmented Generation (RAG)** assistant that enables consultants or enterprise users to query their internal documentation and receive **grounded, cited answers**.

This project demonstrates an end-to-end AI solution combining **RAG system design, data ingestion, LLM integration, and secure document retrieval**, fully aligned with Unify Consulting's offerings in **AI Systems & Engineering** and **AI Adoption**.

---

## 2. Problem Statement

- Clients' internal knowledge is fragmented across PDFs, PowerPoints, Confluence pages, and emails.
- Information retrieval depends on tribal knowledge and manual searches.
- Off-the-shelf chatbots lack grounding and security for enterprise use.
- Unify consultants need demonstrable prototypes to show clients how AI can safely augment their decision-making.

**Goal:**
Design and implement a secure, demo-ready RAG system capable of ingesting internal documents and generating cited, high-fidelity answers to natural language questions.

---

## 3. Objectives & Success Metrics

| Objective | Key Results / Metrics |
|-----------|----------------------|
| Build a private RAG pipeline | End-to-end ingestion → retrieval → generation pipeline functional |
| Ensure factual, grounded outputs | Citation accuracy ≥ 90%, hallucination < 10% (manual eval) |
| Optimize retrieval quality | Retrieval hit rate ≥ 80% on test queries |
| Optimize latency | Response time ≤ 4 seconds average |
| Enable reuse for client pilots | Modular architecture, configurable data sources, clear README |

---

## 4. Scope

### In Scope:
- Document ingestion and preprocessing (chunking, embedding, vector storage)
- Retrieval (vector search + optional reranker)
- LLM response generation with grounding and citations
- Basic authentication and role-based access (demo-level)
- Web UI for queries and source visualization
- Monitoring and metrics collection (usage, latency, retrieval stats)

### Out of Scope (MVP):
- Enterprise SSO integration
- Real client data (synthetic data only for demo)
- Advanced multi-modal (image/PDF) parsing beyond text extraction

---

## 5. Target Users

| Persona | Description | Core Need |
|---------|-------------|-----------|
| **Consultant / AI Engineer** | Unify team member demonstrating AI capabilities to clients | Needs a working, interpretable demo |
| **Client Decision Maker** | Business stakeholder exploring AI adoption | Needs proof of value & security |
| **Internal Knowledge Worker** | Analyst seeking internal info quickly | Needs fast, accurate answers |

---

## 6. Solution Overview

### Architecture Diagram (conceptual)

```
[Document Upload/API]
    ↓
[Text Splitter → Embeddings Generator]
    ↓
[Vector DB (Supabase/Pinecone) + Metadata Store]
    ↓
[Retriever + Optional Reranker]
    ↓
[LLM (OpenAI / Local Model)]
    ↓
[Response + Citations]
    ↓
[Frontend (Next.js UI) + Auth Layer]
```

---

## 7. Technical Components

| Component | Description | Tools/Tech |
|-----------|-------------|------------|
| **Ingestion Pipeline** | Converts raw docs (PDF, text, markdown) → chunks → embeddings → vector store | Python, LangChain, OpenAI Embeddings, Supabase/Pinecone |
| **Retriever** | Semantic + keyword hybrid retrieval | LangChain / custom retriever logic |
| **Reranker (Optional)** | Reranks top-k results for relevance | HuggingFace cross-encoder |
| **LLM Orchestrator** | Generates grounded response with citations | OpenAI GPT-4-turbo API or local model (e.g., Llama 3) |
| **Frontend** | Search UI, document upload, response viewer | Next.js + TypeScript |
| **Backend API** | Connects frontend to retrieval/generation | FastAPI or Node Express |
| **Auth & Guardrails** | Token-based demo auth + citation-or-silence rule | JWT / Clerk (for demo) |
| **Metrics Dashboard** | Track latency, hit rate, query volume | Grafana / Supabase Analytics |
| **Infra** | Dockerized local deployment + CI/CD | Docker, GitHub Actions |

---

## 8. Prompt and Generation Design

### System Prompt Template Example:

```
You are an enterprise knowledge assistant.
Use only the provided context to answer the question.
Cite your sources using their titles and page references.
If unsure or missing information, respond with:
"I don't have enough context to answer that confidently."
```

### Grounding Logic:
Top-3 retrieved chunks concatenated → LLM prompt context → response generated with source metadata.

---

## 9. Evaluation Metrics

| Metric | Description | Measurement |
|--------|-------------|-------------|
| **Retrieval Hit Rate** | % of correct documents retrieved | Top-3 accuracy on test set |
| **Citation Precision** | % of cited content actually present in retrieved docs | Manual eval |
| **Answer Fidelity** | Agreement between generated and reference answers | Human eval |
| **Latency** | Avg. response time from query to output | Logging |
| **Adoption Readiness** | Ease of deployment for client demo | Internal peer review |

---

## 10. Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|-----------|
| Hallucination of facts | Medium | Strict grounding prompt + "citation or silence" rule |
| Slow response times | High | Cache embeddings, parallelize retrieval |
| Data leakage | High | Synthetic data only, sanitize uploads |
| Poor search recall | Medium | Hybrid search + tuned embedding model |
| Complexity bloat | Medium | Modular design, clear MVP boundaries |

---

## 11. Deliverables

| Deliverable | Description |
|-------------|-------------|
| **Ingestion Script** | Python-based document processor |
| **Vector DB Schema** | Table definition for metadata and embeddings |
| **Backend API** | REST/GraphQL API for query and retrieval |
| **Frontend Web App** | Interactive search + citations viewer |
| **Slide Deck** | Value proposition + architecture overview |
| **Demo Video (3–5 min)** | End-to-end walkthrough |
| **README + PRD** | Full documentation for reproducibility |

---

## 12. Timeline (8-Week Plan)

| Week | Focus | Key Deliverables |
|------|-------|------------------|
| **Week 1** | Project Setup & Planning | Repo setup, environment, success metrics defined |
| **Week 2** | Ingestion Pipeline | Script for chunking & embedding + sample data |
| **Week 3** | Retrieval System | Retriever + reranker functional |
| **Week 4** | Generation & Prompting | End-to-end API returning grounded answers |
| **Week 5** | Frontend UI | Next.js interface connected to backend |
| **Week 6** | Security & Guardrails | Auth, citation-or-silence, logging |
| **Week 7** | Monitoring & Testing | Metrics dashboard, latency tests, QA |
| **Week 8** | Finalization & Demo | Deck, demo video, polish, presentation-ready build |

---

## 13. Long-Term Vision

After MVP validation, extend to:
- Enterprise connectors (SharePoint, Confluence, Jira)
- Role-based permissions
- Context window optimization
- Multimodal ingestion (audio, image, structured data)
- Offline / on-prem deployment

---

## 14. Business Impact Summary

**Client Value:** Reduces information retrieval time by 80%, increases consistency in client deliverables, and creates an auditable source trail for decisions.

**Unify Value:** Reusable internal IP that can be repackaged for multiple client verticals — finance, healthcare, operations — within Unify's AI Systems & Engineering offering.

---

## 15. Demo Flow (for Unify)

1. Show dashboard with uploaded "client" docs (synthetic).
2. Ask: "What were the 2024 strategic goals for the analytics transformation project?"
3. Copilot retrieves sources, shows concise answer + citations.
4. Demonstrate "citation or silence" rule.
5. Show metrics (response time, retrieval logs).
6. End with slide: measurable business impact + next steps.

---

## 16. Folder Structure

```
/private-rag-copilot/
│
├── /backend/
│   ├── app.py
│   ├── retriever.py
│   ├── reranker.py
│   ├── generator.py
│   ├── vector_store.py
│   ├── auth.py
│   └── config.yaml
│
├── /frontend/
│   ├── pages/
│   ├── components/
│   └── styles/
│
├── /data/
│   └── synthetic_docs/
│
├── /evaluation/
│   ├── test_queries.json
│   ├── metrics_report.ipynb
│
├── /infra/
│   ├── docker-compose.yaml
│   ├── Dockerfile
│   └── CI-CD.yaml
│
├── README.md
├── PRD.md
├── ROADMAP.md
├── DECISIONS.md
└── .gitignore
```

---

## 17. Next Steps

1. Initialize repo and environment (Python + Next.js + Supabase).
2. Start ingestion pipeline development (Week 1–2).
3. Maintain PRD updates as build progresses.
4. Schedule internal review demo after Week 4 milestone (retrieval working).
5. Prepare presentation assets by Week 8.
