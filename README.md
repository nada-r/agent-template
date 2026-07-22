# agent-template

A starter repo built for coding agents as much as for humans. TypeScript, Fastify, Zod.
The layout follows one constraint: an agent's context window is small, so the always-loaded
files stay short and everything else loads on demand, runs as a hook, or gets verified.

```
always loaded   AGENTS.md ──@──▶ CLAUDE.md          (~120 lines total)
on demand       .claude/skills  .claude/rules  docs/
enforced        format hook · pre-commit secret scan · CI
verified        make check = lint + typecheck + test
remembered      MEMORY.md · ERRORS.md · ROADMAP.md · docs/decisions/
```

## The rules

The heart of [`AGENTS.md`](AGENTS.md):

- Ask before assuming. Restate the deliverable, then act. Simplest solution first, surgical changes only.
- Never guess external facts. Verify data freshness — which DB, which env, is the process current.
- `make check` green before anything is called done. Show the output.
- Prose follows [Orwell's six rules](AGENTS.md#writing-style--prose-not-code). No "comprehensive", no "robust", no "successfully".
- No package published less than 48h ago.

## Start a project

```bash
cp -R agent-template my-project && cd my-project && rm -rf .git && git init
make setup     # deps + git hooks
make check     # must be green before you touch anything
```

Then: rename in `package.json`, rewrite the overview in `AGENTS.md`, describe the real
system in `MEMORY.md` and `docs/architecture.md`, delete the `(example)` entries.

## Where things are

- `AGENTS.md` — the rules, readable by any agent ([open standard](https://agents.md)). `CLAUDE.md` imports it and adds the workflow.
- `.claude/` — commands (`/commit-push-pr`, `/fix-issue`, `/interview-spec`, `/update-memory`), review and verification subagents, on-demand skills, path-scoped rules.
- `MEMORY.md`, `ERRORS.md`, `ROADMAP.md` — what the agent learns, breaks, and aims for. Dated entries; examples show the format.
- `docs/PLAYBOOK.md` — why each file exists, with sources. Delete it if you want a lean repo.
- `docs/stack-variants.md` — Python, Rust/Anchor, Prisma, monorepo, Next.js adaptations.
- `src/routes/echo.ts` — the pattern to copy for new endpoints. `make help` lists the commands.
