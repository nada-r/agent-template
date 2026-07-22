@AGENTS.md

_The line above inlines AGENTS.md at session start — Claude Code's `@` import. Shared rules live there; only Claude-specific behavior lives below (ADR-0001)._

# Claude-specific instructions

<!-- AGENTS.md (imported above) is the single source of truth.
     Only genuinely Claude-only behavior lives here. Keep this file tiny. -->

## Workflow

- Non-trivial tasks: Explore → Plan → Code → Commit. Start in plan mode; if you could describe the diff in one sentence, skip the plan.
- Larger features: interview me first (`/interview-spec`), write the result to `SPEC.md` (created on demand — doesn't exist until then), then implement from the spec in a fresh session.
- After a series of edits, run `make check` and show the output — evidence, not assertion.
- Before declaring a task done, use the `verifier` subagent. For review, use `code-reviewer` (fresh context, sees only the diff).
- Use subagents for high-volume output (full test-suite runs, large searches) to keep this context clean.

## Memory protocol

- `MEMORY.md` (context, verified facts, lessons) and `ERRORS.md` (bugs with root causes, failed approaches) are the project's long-term memory. These are the repo-root files, NOT your auto-memory directory. Update them after every significant task — `/update-memory` walks through it.
- Before debugging anything that feels familiar, read ERRORS.md first.
- If MEMORY.md can't hold its ~200-line cap despite pruning (or ERRORS.md outgrows grep), graduate to the SQLite kb — see the `knowledge-base` skill and ADR-0002.
- NEVER guess external facts (decimals, indices, rate limits, API shapes). Verify against the source, then record in MEMORY.md → "Verified facts".

## Reporting

- Report progress in plain sentences: what changed, what failed, what comes next. No emoji checkmarks, no "Successfully", no "Perfect", no wall of bullets. Start with three lines; add detail only when it changes the next action.

## Self-improvement

- When I correct you, or a review catches something you should have known: add one line to AGENTS.md (shared rules) or this file (Claude-only). Apply the pruning test — if the file grows past ~150 lines, cut the weakest line.
- If a rule must hold 100% of the time, don't write prose — add a hook in `.claude/settings.json` instead.
