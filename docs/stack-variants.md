# Stack variants

The scaffold is TypeScript/Fastify. When a project needs a different or additional stack,
keep the same five layers (see `docs/PLAYBOOK.md`) and swap the verification tooling.
The invariant across every variant: **one command runs the full gate, and CI runs exactly that.**

## Python (data pipelines, research)

`pyproject.toml` baseline (proven in `etesia_data_pipeline`):

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "project-name"
requires-python = ">=3.12"

[project.optional-dependencies]
dev = ["ruff", "mypy", "pytest", "pytest-asyncio"]

[tool.ruff]
line-length = 120

[tool.mypy]
strict = true

[tool.pytest.ini_options]
asyncio_mode = "auto"
```

Makefile targets become:

```make
lint:      ## ruff check + ruff format --check
	ruff check . && ruff format --check .
typecheck: ## mypy
	mypy .
test:      ## pytest
	pytest
check: lint typecheck test ## Full gate
```

AGENTS.md changes: swap the commands section; style rules become "type hints everywhere,
mypy strict passes, ruff formats" — keep the same pruning discipline.

## Rust / Solana (Anchor programs)

- Gate: `cargo fmt --check && cargo clippy -- -D warnings && cargo test` (+ `anchor test` for programs).
- AGENTS.md must record the toolchain pins (`rust-toolchain.toml`, Anchor + Solana CLI versions) —
  agents cannot guess these and version drift is the #1 Anchor footgun.
- Verified on-chain facts (program IDs, account sizes, decimals) go in `MEMORY.md` → "Verified facts". NEVER guessed.

## Adding Prisma + PostgreSQL (the default DB path)

1. `npm i prisma @prisma/client && npx prisma init`
2. Uncomment `DATABASE_URL` in `.env.example` and the `db-*` targets in the Makefile.
3. Railway build convention: `"build": "prisma generate && prisma migrate deploy && tsc -p tsconfig.build.json"`.
4. Add to AGENTS.md: migration etiquette (never edit an applied migration; `db-migrate` locally, `migrate deploy` in prod).

## Monorepo (pnpm + Turborepo)

- Root AGENTS.md holds workspace-wide rules only; each `apps/*` and `packages/*` gets its own
  short nested AGENTS.md (nearest file wins — every major tool honors this).
- Root CLAUDE.md still bridges with `@AGENTS.md`; per-package CLAUDE.md files load on demand
  when the agent touches files there.
- Pin the package manager in root `package.json` (`"packageManager": "pnpm@x.y.z"`).
- Keep the one-command gate at the root: `turbo run lint typecheck test`.

## Next.js frontend

- Same layers; gate adds `next build` (the real typecheck for the app router) and Playwright
  for the verification loop: agents iterate against screenshots (paste design → implement →
  screenshot → compare → fix).
- Deploy: Vercel. Keep server-only secrets out of `NEXT_PUBLIC_*` — worth a line in AGENTS.md.
