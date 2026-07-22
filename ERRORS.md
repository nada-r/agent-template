# ERRORS.md — incident log

<!-- Agent-maintained, APPEND-ONLY, newest first. Read this BEFORE debugging anything
     that feels familiar. Rules:
     - One dated entry per bug: `## YYYY-MM-DD — STATUS: headline`. Status markers:
       INCIDENT, ROOT CAUSE, CORRECTION, REFUTED, FIXED. Headlines alone should tell
       the story — write them so a grep by symptom finds the entry.
     - Corrections NEVER rewrite old entries — add a new dated entry ("my earlier X
       hypothesis was WRONG"). Wrong turns stay searchable.
     - Entry format (5 lines, all earning their place):
       Symptom (the search key — what you observed, not the cause) / Root cause (the
       condition, not the trigger) / Fix + commit / Earlier catch (what test or check
       would have caught it) / Dead ends (failed approaches, so they aren't retried).
     - An unread postmortem might as well never have existed — hence the read trigger
       in CLAUDE.md.
     - EXAMPLE entries below are from other projects — delete when scaffolding. -->

> **Template note:** the three entries below are examples borrowed from other projects to
> show the format. Delete them when scaffolding a real project.

## _(example)_ 2026-07-19 — FIXED: wrong P&L reported from stale local indexer

- Symptom: Deposited/P&L amounts wrong; had to be flagged twice before anyone doubted the data source.
- Root cause: never-restarted local indexer serving old code — the numbers were confidently produced from a stale process, not a calculation bug.
- Fix: restart + a freshness check before reading. Rule promoted to AGENTS.md ("verify data freshness before concluding").
- Earlier catch: print the data source + process start time alongside any money number.
- Dead ends: 2 rounds auditing the P&L math — the math was fine.

## _(example)_ 2026-06-20 — ROOT CAUSE: deposit stuck 10h, service blind to pending assets

- Symptom: first $100 deposit pending ~10h; curator service never emitted a tx (nonce = 0).
- Root cause: SDK v0.5-era `getPendingAssets()` returns 0 on a v0.6 vault — service healthy, 0 errors, structurally blind. Earlier "boot crash" hypothesis was WRONG.
- Fix: derive pending state from ground truth (`USDC.balanceOf(pendingSilo) > 0`), version-proof, instead of the SDK helper.
- Earlier catch: integration test asserting detection fires on a real pending deposit, not on SDK mocks.
- Dead ends: reading deploy logs for a crash that never happened.

## _(example)_ 2026-02-xx — FIXED: Vercel prerender crash, React 18/19 conflict

- Symptom: `TypeError: Cannot read properties of null (reading 'useRef')` in prerender workers.
- Root cause: `node-linker=hoisted` → prerender workers resolve React from monorepo root (v18) while app uses v19.
- Fix: skip build-time prerendering (`export const dynamic = "force-dynamic"`).
- Earlier catch: CI build on the exact Vercel node-linker config.
- Dead ends: webpack `resolve.alias` (bundling only, not prerender runtime); `NODE_PATH` (doesn't reach child workers); react@19 at root (breaks react-native).
