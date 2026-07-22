# ADR-0002: Files first; SQLite knowledge base only past a measured threshold

- **Date:** 2026-07-23
- **Status:** accepted

## Context

For projects with a large knowledge base, a Claude ambassador (Olivier Legris) recommends
a small SQL database with query tools instead of markdown files. Anthropic's evidence cuts
both ways: Claude Code dropped its RAG/vector pipeline because plain agentic search over
files "outperformed everything" (Boris Cherny), and Anthropic's entire memory system is
file-based — but the memory-tool docs explicitly support database backends, and this dev's
own repos show the file failure mode: 116-148KB append-only knowledge files that became
consultation burdens accumulating unresolved contradictions.

## Decision

Markdown files (MEMORY.md / ERRORS.md, two-layer distilled+log pattern) are the default.
Graduate structured facts and incidents to a SQLite kb (via the `knowledge-base` skill)
only when a measured threshold is hit: MEMORY.md can't hold its ~200-line cap despite
pruning, ERRORS.md exceeds ~50KB, or cross-cutting queries are needed. Prose never
graduates — SQL is for what you query, files are for what you read.

## Alternatives considered

- SQL from day one: infrastructure and schema maintenance for every project, against
  Anthropic's own grep-beats-RAG finding at small scale. Violates simplest-solution-first.
- Files forever: proven to break in this dev's own trading repos at ~100KB+.
- Vector/RAG search: Claude Code's abandoned approach; staleness and infra cost without
  a precision win at repo scale.

## Consequences

- Zero cost until a threshold is hit; the graduation recipe (schema, CLI, git strategy)
  is ready in `.claude/skills/knowledge-base/`.
- The threshold is objective (line/size caps already enforced by the memory protocol),
  so the decision to graduate is observable, not a matter of taste.
- Committed artifact is a diffable `kb.sql` dump, not a binary — git stays reviewable.
