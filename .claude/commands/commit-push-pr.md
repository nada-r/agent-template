---
description: Verify, commit, push, and open a PR for the current work
disable-model-invocation: true
allowed-tools: Bash(make check), Bash(git status), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Bash(git push), Bash(git checkout -b:*), Bash(gh pr create:*)
---

Ship the current work:

1. Run `make check`. If anything fails, fix it first and re-run until green.
2. Run `git status` and `git diff` to review exactly what changed. If unrelated changes are mixed in, split them into separate commits.
3. If on `main`, create a descriptively named branch first.
4. Stage and commit with a focused, imperative message explaining the WHY.
5. Push and open a PR with `gh pr create`, following `.github/PULL_REQUEST_TEMPLATE.md`. Paste the `make check` output as verification evidence.
6. Update `MEMORY.md` / `ERRORS.md` if this task produced facts, lessons, bugs, or dead ends worth recording (`/update-memory`).
7. Run the `roadmap-check` subagent; apply the ROADMAP.md moves it suggests if they are right.
