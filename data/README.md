# Data Directory

This directory contains synthetic documents for development, testing, and demonstration of the Private RAG Copilot system.

## Structure

```
data/
├── synthetic_docs/     # Synthetic company documents for demo
├── raw_documents/      # Uploaded documents (not tracked in git)
├── processed/          # Processed chunks and embeddings (not tracked)
└── README.md          # This file
```

## Synthetic Documents

The `synthetic_docs/` folder contains realistic examples of internal company documentation created specifically for demonstrating the RAG Copilot system.

### Current Documents

1. **01_q4_2024_strategy.md** - Quarterly strategic plan
   - Document type: Strategic Planning
   - Content: Market expansion, financial targets, key initiatives
   - Use case: Test strategic queries about company direction

2. **02_weekly_leadership_meeting_notes.md** - Leadership meeting minutes
   - Document type: Meeting Notes
   - Content: Team updates, decisions, action items
   - Use case: Test retrieval of specific decisions and action items

3. **03_remote_work_policy.md** - Company policy document
   - Document type: HR Policy
   - Content: Remote work guidelines, requirements, procedures
   - Use case: Test policy-related queries and compliance questions

### Document Characteristics

- **Realistic Content**: Documents simulate actual internal company documentation
- **Variety**: Multiple document types (strategy, meetings, policies)
- **Citation-Friendly**: Structured with clear sections for accurate citation
- **Factual**: Contains specific facts, numbers, and dates for grounding tests
- **Interconnected**: Documents reference each other (e.g., meeting notes reference strategy)

## Usage

### Week 2: Document Ingestion
These documents will be used to test and validate the document ingestion pipeline:
- File parsing (Markdown initially, PDF/DOCX later)
- Text chunking
- Embedding generation
- Vector storage

### Week 3-4: Retrieval and Generation
Documents serve as the knowledge base for testing:
- Semantic search quality
- Keyword + vector hybrid retrieval
- Reranking effectiveness
- Citation accuracy
- Grounding quality

### Week 5+: Demo and Client Pilots
Synthetic docs provide safe, non-confidential content for:
- Client demonstrations
- Sales presentations
- Training materials
- User documentation

## Adding New Documents

When creating new synthetic documents:

1. **Use Realistic Scenarios**: Base on common business document types
2. **Include Specific Facts**: Numbers, dates, names for citation testing
3. **Clear Structure**: Use headers and sections for easier chunking
4. **Variety**: Mix document lengths, formats, and complexity
5. **Interconnections**: Reference other documents when appropriate
6. **Metadata-Rich**: Include document metadata (dates, authors, departments)

## File Formats

### Supported Formats (by Week)

**Week 1-2:**
- ✅ Markdown (.md) - Simple text documents
- ✅ Plain text (.txt)

**Week 2-3:**
- ⏳ PDF (.pdf) - Most common business document format
- ⏳ Word (.docx) - Microsoft Word documents
- ⏳ PowerPoint (.pptx) - Presentation slides

**Future:**
- HTML web pages
- Excel spreadsheets
- Audio transcripts
- Images with OCR

## Data Privacy and Security

### Important Notes

1. **No Real Data**: Synthetic docs directory contains only fictional data
2. **No Client Data**: Never commit actual client information
3. **No PII**: No personally identifiable information
4. **Git Ignored**: `raw_documents/` and `processed/` are in .gitignore
5. **Demo Only**: Synthetic docs are for demonstration purposes only

### For Production Use

- Store uploaded documents in secure cloud storage (S3, Azure Blob)
- Implement access controls and encryption
- Enable audit logging for document access
- Follow data retention and deletion policies

## Testing Scenarios

### Sample Test Queries

Use these queries to test the RAG system with synthetic documents:

**Strategic Questions:**
- "What are the Q4 2024 strategic priorities?"
- "What is the revenue target for Q4?"
- "Which verticals is the company targeting?"

**Policy Questions:**
- "What is the remote work policy?"
- "How many days can I work from home?"
- "What equipment does the company provide for remote work?"

**Meeting & Decision Questions:**
- "What was decided in the October 14 leadership meeting?"
- "What are the action items from the last leadership meeting?"
- "When is the RAG Copilot being deployed internally?"

**Cross-Document Questions:**
- "How does the remote work policy support the Q4 hiring goals?"
- "What decisions in the leadership meeting relate to the strategic plan?"

## Evaluation Metrics

Track these metrics using the synthetic document set:

### Retrieval Quality
- **Hit Rate**: % of queries that retrieve relevant documents
- **Top-3 Accuracy**: Relevant document in top 3 results
- **Mean Reciprocal Rank (MRR)**: Position of first relevant result

### Generation Quality
- **Citation Accuracy**: % of cited content present in retrieved docs
- **Hallucination Rate**: % of statements not supported by context
- **Answer Completeness**: % of questions fully answered
- **Response Time**: Average time from query to response

### Expected Performance (MVP)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Hit Rate | ≥ 80% | Manual evaluation |
| Citation Accuracy | ≥ 90% | Automated + manual |
| Hallucination Rate | < 10% | Manual evaluation |
| Response Time | ≤ 4 sec | Automated logging |

## Maintenance

### Regular Updates

- Add new synthetic documents monthly
- Update existing docs to reflect "current" dates
- Expand document variety (technical specs, reports, etc.)
- Create adversarial examples to test edge cases

### Quality Checks

- Ensure factual consistency across documents
- Verify all cross-references are valid
- Check that document dates align logically
- Test that all documents are ingested successfully

## Resources

- Document templates: See `docs/templates/` (to be created Week 2)
- Ingestion scripts: See `backend/app/ingestion/`
- Evaluation scripts: See `evaluation/`

---

**Last Updated**: Week 1, October 2025
**Maintained By**: Engineering Team
**Questions**: Contact david.lee@unifyconsulting.com
