# AGENTS.md

<!-- Single source of truth for ALL coding agents (Codex, Cursor, Copilot, …).
     Claude Code reads it via the @AGENTS.md import in CLAUDE.md.
     Keep under ~150 lines. Pruning test for every line:
     "Would removing this cause the agent to make a mistake?" If not, cut it. -->

## Project overview

Fastify API server in strict TypeScript (ESM). Zod validates every external boundary.
Entry point `src/server.ts` → routes in `src/routes/`. Tests use `app.inject()` (no live server).

> This repo is a template. After scaffolding a real project, follow the
> "After scaffolding" checklist in README.md — starting with rewriting this overview.

## Setup commands

- First time: `make setup` (installs deps + wires git hooks)
- Dev server: `make dev` (hot reload, port 3000)
- All targets: `make help`

## Verification — the definition of done

- `make check` must pass (lint + typecheck + test). Run it before saying a task is complete, and show the output.
- Single test file: `npx vitest run test/health.test.ts`
- Single test by name: `npx vitest run -t "returns ok"`
- Prefer running single tests while iterating; run the full `make check` once at the end.
- Add or update tests for any code you change, even if not asked.
- Test what the code does, not what the mocks do. No tests for statically defined values.

## Code style

- TypeScript strict mode, ESM only. Relative imports use `.js` extensions (NodeNext resolution).
- No `any`. Exported functions declare explicit return types. (Enforced in `eslint.config.js`.)
- Zod schemas at every external boundary (HTTP bodies, env, external APIs); infer types with `z.infer` — never hand-write a type a schema already defines.
- `src/routes/echo.ts` is the canonical route pattern — copy its shape for new endpoints (steps: `.claude/skills/new-endpoint`).
- Functions under ~50 lines, files under ~300 lines, changes under ~800 changed lines — split when you exceed them. New logic goes in new files, not into `src/server.ts`.
- Fastify, NOT Express. PostgreSQL via Prisma, NOT SQLite (when a DB is added).
- Names reveal intent and are searchable: `error` not `err`, `response` not `res`, `parseResult` not `parsed`. No abbreviations, no single letters outside trivial loop indices.
- Formatting is Prettier's job (`make fix`) — never hand-align code.

## Working rules

- Ask before assuming: surface assumptions and ambiguity BEFORE coding — don't hide confusion. For non-trivial requests, restate the exact deliverable before acting.
- Verify data freshness before concluding: confirm which DB/env you are hitting and that local processes (dev DBs, indexers, caches) are current — a stale source produces confidently wrong numbers. Mandatory when money is involved.
- Simplest solution first: minimum code for the stated problem. No speculative features, no premature abstraction, no error handling for cases that cannot happen.
- Surgical changes: touch only what the task requires; preserve surrounding style. Flag unrelated dead code — don't remove it unprompted.
- Destructive actions (delete, drop, force-push, deploy) require explicit confirmation. Never auto-deploy.

## Writing style — prose, not code

Orwell's six rules (1946) govern all prose: docs, READMEs, PR descriptions, commit messages, comments.

1. Never use a metaphor or figure of speech you are used to seeing in print.
2. Never use a long word where a short one will do.
3. If it is possible to cut a word out, cut it out.
4. Never use the passive where you can use the active.
5. Never use jargon or a scientific word where an everyday word will do.
6. Break any of these rules sooner than say anything outright barbarous.

These rules never touch code or technical terms. Review prose against them before delivering.
For commit messages and PRs: state what changed and why in plain words. No achievement
language ("comprehensive", "robust", "successfully"). One read should be enough.

## Project structure

- `src/server.ts` — server factory + entry point
- `src/routes/` — one file per route group
- `test/` — vitest, mirrors `src/` naming
- `docs/` — architecture, ADRs, playbook
- `.claude/` — Claude Code config: settings, commands, agents, skills, rules
- `.githooks/` — pre-commit secret scan (wired by `make setup`)

## Security & constraints

- NEVER read or print `.env` — it holds real secrets. `.env.example` is the documented reference.
- Never commit secrets. The pre-commit hook blocks obvious key patterns; don't bypass it with `--no-verify` unless the match is a confirmed false positive.
- No one-off fix scripts left in the repo — delete them after use.
- No infinite loops / long-lived polling in app code — use cron or scheduled jobs.
- Fees, limits, and thresholds are explicit config (`.env.example`), never assumed zero.
- Supply-chain cooldown: before adding or bumping a dependency, check its publish date (`npm view <pkg> time --json | tail -5`). Never install a version published less than 24h ago. (24h = manual-install floor; Dependabot's automated bumps wait 7 days.)
- Full security model: `SECURITY.md`. To check compliance, run the `security-audit` skill.

## Commit / PR instructions

- Branch from `main`. Small, focused commits; imperative subject ("Add echo route validation").
- Always run `make check` before committing.
- PRs follow `.github/PULL_REQUEST_TEMPLATE.md` — include verification evidence (test output).

## Dev environment tips

- Node >= 22 (`.nvmrc`), npm. Health check: `GET /api/health`.
- Deploy target convention: Railway (backend) / Vercel (frontend). Railway injects `PORT`.
- External facts (API decimals, rate limits, indices) are recorded in `MEMORY.md` — check there before calling an external API, and NEVER guess such values. Past bugs and dead ends: `ERRORS.md`.
