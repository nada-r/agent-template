# agent-template

The reference template for starting a new project. A working TypeScript/Fastify scaffold
wired for the agent era: every file exists to make the repo maximally workable by **humans
and coding agents**, following practices from Anthropic (Boris Cherny / Claude Code),
the AGENTS.md open standard, and Andrej Karpathy's "build for agents" principles.

**Why each file exists — with sources — is documented in [`docs/PLAYBOOK.md`](docs/PLAYBOOK.md).**

## The idea in one diagram

```
                    ┌───────────────────────────────────────────────┐
                    │  L1  ALWAYS-ON (loaded every session, <200ln) │
                    │      AGENTS.md ──@──▶ CLAUDE.md               │
                    ├───────────────────────────────────────────────┤
                    │  L2  ON-DEMAND (loaded when relevant)         │
                    │      .claude/skills  .claude/rules  docs/     │
                    ├───────────────────────────────────────────────┤
                    │  L3  DETERMINISTIC (enforced, not advisory)   │
                    │      hooks  .githooks/pre-commit  CI          │
                    ├───────────────────────────────────────────────┤
                    │  L4  VERIFICATION (the agent checks itself)   │
                    │      make check = lint + typecheck + test     │
                    ├───────────────────────────────────────────────┤
                    │  L5  MEMORY (survives amnesiac sessions)      │
                    │   MEMORY.md ERRORS.md decisions/ SPEC.md      │
                    └───────────────────────────────────────────────┘
```

The single governing constraint (Anthropic): _the context window is the scarce resource_.
Layer 1 stays tiny; everything else loads just-in-time, is enforced mechanically, or is
verified by the agent itself.

## The rules the agent works under

The heart of [`AGENTS.md`](AGENTS.md), always loaded:

- **Ask before assuming** — surface assumptions before coding; restate the deliverable first. **Simplest solution first**; **surgical changes** only. (After Karpathy's working principles.)
- **Verify data freshness before concluding** — which DB, which env, is the process current. Never guess external facts; verify, then record in `MEMORY.md`.
- **`make check` green before anything is called done** — and show the output.
- **All prose follows [Orwell's six rules](AGENTS.md#writing-style--prose-not-code)** — short words, active voice, cut what you can. No "comprehensive", no "robust", no "successfully".
- **Never install a package published less than 48h ago** — supply-chain cooldown.

## Quickstart — new project from this template

```bash
cp -R agent-template my-project && cd my-project && rm -rf .git && git init
make setup     # installs deps + wires the pre-commit secret scan
make check     # lint + typecheck + test — must be green before you start
```

Then adapt:

1. `package.json` — name, description.
2. `AGENTS.md` — rewrite "Project overview"; prune rules that don't apply.
3. `MEMORY.md` / `docs/architecture.md` — describe the real project.
4. Delete `docs/PLAYBOOK.md` (teaching material) if you want a lean repo — or keep it for the team.

## Daily commands

| Command        | What                                                |
| -------------- | --------------------------------------------------- |
| `make dev`     | Dev server with hot reload (port 3000)              |
| `make check`   | **The definition of done**: lint + typecheck + test |
| `make fix`     | Auto-fix lint + formatting                          |
| `make secrets` | Scan tracked files for secret-looking strings       |
| `make help`    | Everything else                                     |

## File map

| Path                       | Layer | Purpose                                                                                |
| -------------------------- | ----- | -------------------------------------------------------------------------------------- |
| `AGENTS.md`                | L1    | Single source of truth for all coding agents ([open standard](https://agents.md))      |
| `CLAUDE.md`                | L1    | Thin bridge: `@AGENTS.md` + Claude-only extras                                         |
| `.claude/settings.json`    | L3    | Committed permission allowlist + format-on-edit hook                                   |
| `.claude/commands/`        | L2    | `/commit-push-pr`, `/fix-issue`, `/interview-spec`, `/update-memory`, `/rewrite-prose` |
| `.claude/agents/`          | L2    | `code-reviewer`, `verifier` (adversarial done-check), `roadmap-check` (drift detector) |
| `.claude/skills/`          | L2    | `new-endpoint`, `security-audit`, `llm-caching`, `knowledge-base` (load on demand)     |
| `.claude/rules/`           | L2    | Path-scoped rules (load only for matching files)                                       |
| `.githooks/pre-commit`     | L3    | Secret scan — gitleaks with regex fallback                                             |
| `.gitleaks.toml`           | L3    | Default ruleset + wallet-key rules (EVM, Solana, mnemonics)                            |
| `.github/workflows/ci.yml` | L3    | CI runs exactly what `make check` runs + gitleaks + npm audit                          |
| `.github/dependabot.yml`   | L3    | Weekly updates with 7-day supply-chain cooldown (14 on majors)                         |
| `SECURITY.md`              | L3    | Security model: secrets, wallet keys, supply chain, agent safety                       |
| `Makefile`                 | L4    | One well-named command per workflow                                                    |
| `MEMORY.md` + `ERRORS.md`  | L5    | Agent memory: facts & lessons / bugs & failed approaches                               |
| `ROADMAP.md`               | L5    | Now / Next / Later / Done — direction across sessions                                  |
| `docs/decisions/`          | L5    | ADRs — why decisions were made, so they aren't re-litigated                            |
| `docs/architecture.md`     | L5    | Living arch doc: measured facts, dated                                                 |
| `docs/stack-variants.md`   | —     | Python / Rust / Prisma / monorepo / Next.js adaptations                                |
| `src/` + `test/`           | —     | Working proof of the verification loop (`echo.ts` is the canonical pattern)            |
