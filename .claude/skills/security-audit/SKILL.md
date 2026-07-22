---
name: security-audit
description: Audit this repo against the security checklist - secrets, supply chain, agent safety. Use when asked for a security check, before a first deploy, or when adopting an old repo.
---

# Security audit

Run each check, collect evidence, report findings ranked by severity. Degrade gracefully:
if a tool is missing, say so and use the fallback - never skip a category silently.

## 1. Secrets in the repo

- `git ls-files | grep -E '\.env($|\.)' ` - only `.env.example` may appear.
- Full scan: `gitleaks dir . --no-banner --redact` (fallback: `make secrets` or grep for
  `sk-`, `ghp_`, `AKIA`, `PRIVATE KEY`, `hooks.slack.com`).
- History scan if gitleaks exists: `gitleaks git . --no-banner --redact`.
- Wallet repos: grep for key-shaped literals - EVM hex keys near `private_key`-like names,
  Solana 64-byte JSON arrays, mnemonics. Check test fixtures too.
- Any hit on a REAL secret: report "rotate first, then clean history" - in that order.

## 2. Supply chain

- Lockfile committed? CI uses `npm ci` (or frozen-lockfile equivalent)?
- Recently added/bumped deps: `npm view <pkg> time --json | tail -5` - flag any version
  published <24h before it was installed.
- `npm audit --audit-level=high` (or the ecosystem equivalent).
- Dependabot/Renovate present, with a cooldown configured?

## 3. Secret hygiene config

- `.gitignore` covers `.env` and variants; `.env.example` exists and documents every var.
- Pre-commit secret scan wired? (`git config core.hooksPath` or husky/pre-commit framework).
- CI has a secrets-scan job?

## 4. Agent safety

- `.claude/settings.json`: allowlist present? deny-rules for env files? No
  `--dangerously-skip-permissions` habits documented anywhere?

## 5. Report

Rank findings: CRITICAL (live secret exposed) → HIGH (no scanning, vulnerable dep) →
MEDIUM (missing cooldown, no audit in CI) → LOW (hygiene). For each: the evidence
(command + output), the risk in one sentence, the fix in one step. Plain sentences, no
checkmark walls. If the repo is clean, say so and stop.
