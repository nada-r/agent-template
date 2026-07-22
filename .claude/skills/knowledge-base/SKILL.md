---
name: knowledge-base
description: Graduate project memory from markdown files to a queryable SQLite knowledge base. Use when MEMORY.md exceeds its ~200-line cap despite pruning, ERRORS.md grows past grep-friendliness (~50KB), or cross-cutting queries are needed ("all facts about X since date Y").
---

# SQLite knowledge base (the scale path)

Files first — this repo's default. Anthropic's own agentic-search finding (grep beat RAG
"by a lot") holds while files stay small and pruned. Graduate when a THRESHOLD is hit:

- MEMORY.md can't stay under ~200 lines despite pruning, or
- ERRORS.md exceeds ~50KB (grep returns noise, contradictions accumulate), or
- You need filtered queries: by provider, by date range, by tag.

Do NOT graduate speculatively. If no threshold is hit, stop here.

## Setup (once, when graduating)

1. Create `scripts/kb.ts` using `node:sqlite` (built-in; Node 22.5+ needs
   `--experimental-sqlite`, stable on Node 24+ — check `node --version` first;
   fall back to `better-sqlite3` only if needed, respecting the 48h cooldown).
2. Schema — two tables mirroring the markdown structure they replace:

```sql
CREATE TABLE facts (
  id INTEGER PRIMARY KEY,
  date TEXT NOT NULL,            -- ISO 8601
  subject TEXT NOT NULL,         -- e.g. 'birdeye', 'drift', 'railway'
  fact TEXT NOT NULL,
  source TEXT NOT NULL,          -- URL, doc section, or 'measured'
  verified_how TEXT NOT NULL,    -- 'doc-checked' | 'measured' | 'on-chain' | ...
  stale INTEGER DEFAULT 0        -- mark superseded facts; never delete
);
CREATE TABLE incidents (
  id INTEGER PRIMARY KEY,
  date TEXT NOT NULL,
  status TEXT NOT NULL,          -- INCIDENT | ROOT_CAUSE | FIXED | REFUTED
  symptom TEXT NOT NULL,         -- the grep/search key
  root_cause TEXT,
  fix TEXT,
  earlier_catch TEXT,
  dead_ends TEXT
);
```

3. CLI commands (namespaced, consolidated — Anthropic tool-design rules):
   - `kb add-fact --subject X --fact "..." --source "..." --how measured`
   - `kb search <term>` (LIKE over fact+symptom+root_cause, newest first)
   - `kb facts --subject X [--since DATE]`
   - `kb dump` → regenerates `kb/kb.sql` (the git-committed, diffable artifact)
   - `kb init` → rebuilds `kb/kb.db` from `kb/kb.sql`
4. Git: commit `kb/kb.sql` (diffable dump); gitignore `kb/kb.db` (binary). `kb dump`
   runs in the pre-commit flow or `/commit-push-pr`.
5. Allowlist in `.claude/settings.json`: `"Bash(npx tsx scripts/kb.ts *)"`.
6. Migrate: move MEMORY.md "Verified facts" rows and ERRORS.md entries into the DB.
   MEMORY.md keeps: Current focus, architecture sketch, stack rationale, and a pointer:
   "Facts and incidents live in the kb — `kb search <term>` before assuming anything."

## Rules after graduation

- Same provenance bar: no fact without date + source + verified_how.
- Mark superseded facts `stale=1` — never delete (the trail stays searchable).
- CLAUDE.md memory protocol still applies; `/update-memory` writes to the kb instead.
- The kb is for FACTS and INCIDENTS. Prose (lessons, focus, rationale) stays in markdown —
  SQL is for what you query, files are for what you read.
