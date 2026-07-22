# Unified entrypoint for humans, agents, and CI.
# One well-named command beats a multi-step incantation (Anthropic, "Writing effective tools for agents").
# Run `make help` to list targets.

.PHONY: help setup dev build start lint fix typecheck test check secrets clean

help: ## List available targets
	@grep -E '^[a-zA-Z_:-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

setup: ## Install deps and wire git hooks (run once after clone)
	npm install
	git config core.hooksPath .githooks
	@echo "✔ Setup complete. Run 'make check' to verify."

dev: ## Run the dev server with hot reload (port 3000)
	npm run dev

build: ## Compile TypeScript to dist/
	npm run build

start: ## Run the compiled server
	npm run start

lint: ## ESLint + Prettier check
	npm run lint

fix: ## Auto-fix lint and formatting issues
	npm run lint:fix

typecheck: ## TypeScript type check (src + test)
	npm run typecheck

test: ## Run the test suite once
	npm run test

check: ## Full verification gate: lint + typecheck + test. The definition of done.
	npm run check

secrets: ## Scan the working tree for secret-looking strings
	@./.githooks/pre-commit --scan-all || (echo "✖ Possible secrets found" && exit 1)
	@echo "✔ No secrets detected"

clean: ## Remove build artifacts
	rm -rf dist coverage

# ── Database targets (uncomment when Prisma is added — see docs/stack-variants.md) ──
# db-generate: ## Regenerate Prisma client
# 	npx prisma generate
# db-migrate: ## Create + apply a migration locally
# 	npx prisma migrate dev
# db-studio: ## Open Prisma Studio
# 	npx prisma studio
