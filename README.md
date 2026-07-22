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
- Never guess external facts. Verify data freshness - which DB, which env, is the process current.
- `make check` green before anything is called done. Show the output.
- Prose follows [Orwell's six rules](AGENTS.md#writing-style--prose-not-code). No "comprehensive", no "robust", no "successfully".
- No package published less than 24h ago.

## Start a project

Needs Node >= 22 (`.nvmrc`). Click **Use this template** on GitHub, or:

```bash
git clone https://github.com/nada-r/agent-template.git my-project
cd my-project && rm -rf .git && git init
make setup     # deps + git hooks
make check     # must be green before you touch anything
```

After scaffolding:

1. `package.json` - name and description.
2. `AGENTS.md` - rewrite the project overview; prune rules that don't apply.
3. `MEMORY.md` + `docs/architecture.md` - describe the real system; delete every `(example)` entry.
4. `SECURITY.md` - fill the vulnerability-reporting placeholder.
5. Rewrite this README - your project ships its own, not the template's.
6. `docs/PLAYBOOK.md` - keep for the team, or delete.

## Where things are

- `AGENTS.md` - the rules, readable by any agent ([open standard](https://agents.md)). `CLAUDE.md` imports it and adds the workflow.
- `.claude/` - commands (`/commit-push-pr`, `/fix-issue`, `/interview-spec`, `/update-memory`), subagents (fresh-context sessions that review or verify), skills (playbooks loaded only when used), rules (loaded only when matching files are touched).
- `MEMORY.md`, `ERRORS.md`, `ROADMAP.md` - what the agent learns, breaks, and aims for. The agent updates them after each task (`/update-memory`) and reads ERRORS.md before debugging anything familiar. Dated entries; `(example)` rows show the format.
- `SECURITY.md` - the security model: secret scanning at three layers (pre-commit, `make secrets`, CI), the 24h package cooldown, the agent permission allowlist.
- `docs/PLAYBOOK.md` - why each file exists, with sources. Delete it if you want a lean repo.
- `docs/stack-variants.md` - Python, Rust/Anchor, Prisma, monorepo, Next.js adaptations.
- `src/routes/echo.ts` - the pattern to copy for new endpoints. `make help` lists the commands.

MIT license.
