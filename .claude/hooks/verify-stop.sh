#!/usr/bin/env bash
# Stop hook: block the turn from ending while TypeScript changes don't typecheck.
# The fast subset of `make check` — full gate stays the human-facing definition of done.
# Exit 2 = block, stderr shown to the agent. Exit 0 = allow.
set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

# Only fire when TS files changed since HEAD — keeps quiet turns instant.
changed=$(git status --porcelain -- '*.ts' 2>/dev/null | head -1)
[ -z "$changed" ] && exit 0

if ! npm run typecheck >/tmp/verify-stop.log 2>&1; then
  echo "Typecheck failing — fix before ending the turn (make check for the full gate):" >&2
  tail -15 /tmp/verify-stop.log >&2
  exit 2
fi

exit 0
