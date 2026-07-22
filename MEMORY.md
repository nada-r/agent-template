# MEMORY.md — project memory

<!-- Agent-maintained. The DISTILLED layer: curated facts, not a log (ERRORS.md holds
     incidents; git holds history). Rules that keep this file useful:
     - Index, not archive: one line per entry, ~200-line cap. Detail goes in docs/ topic
       files with a pointer here.
     - Every entry is dated. Undated entries can't be judged stale, so nobody prunes them.
     - A fact without provenance (source + how verified) doesn't belong here.
     - Same correction needed twice → promote to AGENTS.md as a rule, remove here.
     - EXAMPLE entries below are from other projects — delete them when scaffolding. -->

> **Template note:** entries marked _(example)_ are borrowed from other projects to show
> the format. Delete them when scaffolding a real project.

## Current focus

_The volatile section — what's in flight right now, next step, open question. Rewrite freely; this is the only section that gets overwritten rather than accreted._

- (nothing yet)

## What this does

_One paragraph, plain language. Rewrite when scaffolding a real project._

## Architecture

_Sketch + one-line data flow. Detail lives in `docs/architecture.md`._

```
client ──▶ Fastify (src/server.ts) ──▶ routes (src/routes/*) ──▶ [db / external APIs]
```

## Stack rationale

_Why each major dependency — one line each. Prevents re-litigating decisions._

- Fastify over Express: performance + schema-first design (project convention).
- Zod: single source of truth for boundary types via `z.infer`.

## Verified facts

_External facts checked against their source. NEVER guess these — verify, then record: value + date + source + how verified._

| Date                   | Fact                                                                                                | Source / how verified                           |
| ---------------------- | --------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| _(example)_ 2026-06-15 | Moralis free tier: ~8 reqs then hard 429; refills ~1 req/s sustained → per-poll load must stay tiny | Measured live (burst + paced test)              |
| _(example)_ 2026-06-18 | Birdeye Standard tier = 1 rps, ~30k CU/month; 2nd call same second → 429                            | doc-checked docs.birdeye.so + live verification |

## Lessons learned

_Consequences, not slogans: name the mechanism, or impose an obligation. Each lesson should trace to a real event (link the ERRORS.md entry). Recurring ones → promote to AGENTS.md._

- _(example)_ Fallback mechanisms can hide bugs: when both sides of a comparison fall back to the same value, the result looks plausible but is wrong. Log fallback usage so silent failures become visible. (→ ERRORS.md 2026-02-xx price-fallback)
- _(example)_ When a repo is forked, a known-bug annotation carries a port-the-fix obligation in both directions.
