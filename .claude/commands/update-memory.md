---
description: Update MEMORY.md and ERRORS.md with knowledge from the current session
---

Review this session and update the project memory:

1. Structural changes? Update MEMORY.md "Architecture" / "Stack rationale".
2. External facts verified this session (rate limits, decimals, API shapes)? Add rows to
   MEMORY.md "Verified facts" with date + source.
3. Non-obvious bugs? Add a dated entry to ERRORS.md "Bugs encountered": root cause, fix,
   and how it could have been caught earlier.
4. Dead ends? Add to ERRORS.md "Failed approaches": what we tried, why it failed, what worked.
5. Lessons? Add to MEMORY.md "Lessons learned". If a lesson is a rule the agent should always
   follow, also add one line to AGENTS.md (and apply the pruning test).
6. Prune anything stale in both files. They are memory, not changelogs — keep them scannable.
