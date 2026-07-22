---
name: llm-caching
description: Prompt-caching design rules for code that calls the Claude API. Use when writing or reviewing any code that builds LLM prompts, or when API costs/cache hit rates need improving.
---

# Prompt caching for LLM API code

Facts verified against platform.claude.com/docs prompt-caching (2026-07-21). Re-check pricing
and per-model minimums there before big decisions.

## The invariant

Caching is an exact prefix match. Render order: `tools` → `system` → `messages`.
One changed byte invalidates everything after it. Design order: stable content first,
volatile content last.

## Economics

- Cache read: **0.1×** base input. Write: 1.25× (5-min TTL) or 2× (1-hour TTL).
- Break-even: 2 requests (5m), 3+ requests (1h). Use 1h when gaps between calls exceed
  5 min (agentic steps, slow conversations); 1h blocks must come BEFORE 5m blocks.
- Minimum cacheable prefix (below it, markers are silently ignored): Fable 5 = 512 tokens;
  Opus 4.8 / Sonnet 5 / Sonnet 4.6 = 1024; Opus 4.7 = 2048; Opus 4.6/4.5 & Haiku 4.5 = 4096.
- Cache scope: workspace-level on the Claude API (org-level on Bedrock/Vertex).

## Design rules

1. **Freeze the system prompt.** No `Date.now()`, no UUIDs, no user names interpolated —
   dynamic context goes at the END of `messages`, never in `system`.
2. **Deterministic tools.** Never add/remove/reorder tools mid-conversation (position 0 →
   invalidates everything). Serialize sorted (`sort_keys=True`; watch Go/Swift map ordering).
3. **Breakpoint on the last STABLE block**, not the last block. Max 4 breakpoints.
   Multi-turn: top-level automatic `cache_control` is the simplest correct option.
4. **Cheap changes**: `tool_choice`, thinking config, and images invalidate only the
   messages tier — the tools+system cache survives them.
5. **Long agentic turns**: cache lookback is max 20 content blocks. If one turn adds more
   than 20 blocks (tool_use/tool_result pairs), add an intermediate breakpoint every ~15.
6. **Parallel fan-out**: N simultaneous identical requests all pay full price. Send one,
   await the FIRST streamed token, then fire the rest.
7. **Pre-warm** latency-sensitive apps with a `max_tokens: 0` request at startup — writes
   the cache, bills no output. Skip if traffic is continuous or the prefix is tiny.

## Verify (never assume it works)

- Read `usage.cache_read_input_tokens` — zero across repeated requests = silent invalidator.
  Diff the rendered prompt bytes of two requests to find it.
- Total prompt = `input_tokens + cache_creation_input_tokens + cache_read_input_tokens` —
  judge cost by the sum, not by `input_tokens` alone.
- Record measured hit rates and cost deltas in MEMORY.md → "Verified facts".
