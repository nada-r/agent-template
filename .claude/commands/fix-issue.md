---
description: Analyze and fix a GitHub issue end-to-end
argument-hint: <issue-number>
disable-model-invocation: true
---

Analyze and fix GitHub issue $ARGUMENTS:

1. `gh issue view $ARGUMENTS` to get the details.
2. Understand the problem; search the codebase for the relevant files.
3. Write a failing test that reproduces the issue BEFORE changing any code.
4. Implement the fix; make the failing test pass without breaking others.
5. Run `make check` until green.
6. Commit referencing the issue, push, and open a PR with `gh pr create`.
