# ADR-0001: AGENTS.md is the canonical agent-instruction file

- **Date:** 2026-07-20
- **Status:** accepted

## Context

Multiple agent-instruction formats exist: CLAUDE.md (Claude Code), AGENTS.md (open standard
backed by OpenAI/Google/Cursor/Factory, stewarded by the Linux Foundation, read by 20+ tools),
.cursor/rules, .github/copilot-instructions.md. Duplicating rules across them drifts.
Claude Code does NOT read AGENTS.md natively (open feature request as of mid-2026), but its
CLAUDE.md supports `@path` imports.

## Decision

AGENTS.md is the single source of truth for all shared agent rules. CLAUDE.md is a thin
bridge: `@AGENTS.md` on line 1, plus only genuinely Claude-specific behavior (subagents,
memory protocol, workflow preferences).

## Alternatives considered

- CLAUDE.md-only: matches current 100%-Claude-Code usage, but locks the repo to one tool for zero savings.
- Symlink CLAUDE.md → AGENTS.md: single physical file, but breaks on Windows checkouts and leaves no room for Claude-only additions.
- Duplicate content in both: guaranteed drift.

## Consequences

- Any agent tool added later (Codex, Cursor, Copilot) works with zero config.
- Shared rules get edited in exactly one place; the pruning test is applied to AGENTS.md.
- Claude-only features must be kept OUT of AGENTS.md to stay tool-neutral.
