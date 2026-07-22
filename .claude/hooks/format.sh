#!/usr/bin/env bash
# PostToolUse hook: auto-format any file Claude just edited.
# Deterministic enforcement — formatting is a hook, not an advisory CLAUDE.md rule.
# Receives hook JSON on stdin; extracts the edited file path with jq.
set -uo pipefail

file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "${file:-}" ] && exit 0
[ -f "$file" ] || exit 0

case "$file" in
  *.ts | *.tsx | *.js | *.jsx | *.json | *.md | *.yml | *.yaml)
    prettier_bin="${CLAUDE_PROJECT_DIR:-.}/node_modules/.bin/prettier"
    if [ -x "$prettier_bin" ]; then
      "$prettier_bin" --write "$file" >/dev/null 2>&1 || true
    fi
    ;;
esac

exit 0
