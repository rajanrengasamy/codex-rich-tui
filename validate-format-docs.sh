#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

pass() {
  printf '[✓] %s\n' "$1"
}

warn() {
  printf '[!] %s\n' "$1"
}

fail() {
  printf '[✗] %s\n' "$1" >&2
  exit 1
}

if [[ -f "rich-tui-output/SKILL.md" ]]; then
  SKILL_BASE="rich-tui-output"
elif [[ -f "skills/rich-tui-output/SKILL.md" ]]; then
  SKILL_BASE="skills/rich-tui-output"
else
  fail "Could not find rich-tui-output skill path (expected rich-tui-output/ or skills/rich-tui-output/)"
fi

DOC_FILES=(
  "AGENTS.md"
  "$SKILL_BASE/SKILL.md"
  "$SKILL_BASE/references/FORMAT-PATTERNS.md"
)

for file in "${DOC_FILES[@]}"; do
  [[ -f "$file" ]] || fail "Missing required doc file: $file"
done
pass "Required documentation files exist"

if rg -n '^\s*\|.*\|\s*$' "${DOC_FILES[@]}" >/tmp/validate-format-docs-pipe-tables.txt; then
  warn "Markdown pipe table lines detected:"
  cat /tmp/validate-format-docs-pipe-tables.txt
  fail "Remove markdown pipe tables and use Unicode tables or labeled bullets"
fi
pass "No markdown pipe tables found"

for file in "${DOC_FILES[@]}"; do
  if ! rg -qi 'no markdown pipe tables|never use markdown pipe tables' "$file"; then
    fail "No explicit no-pipe-table rule found in $file"
  fi
done
pass "No-pipe-table rule present in all governed docs"

if rg -n 'Use markdown tables whenever' "$SKILL_BASE/SKILL.md" "$SKILL_BASE/references/FORMAT-PATTERNS.md" >/tmp/validate-format-docs-conflicts.txt; then
  warn "Conflicting markdown-table guidance detected:"
  cat /tmp/validate-format-docs-conflicts.txt
  fail "Remove conflicting markdown-table guidance"
fi
pass "No conflicting markdown-table guidance found"

for token in '[✓]' '[●]' '[○]' '[✗]' '[!]'; do
  rg -Fq "$token" "AGENTS.md" || fail "Missing status indicator token $token in AGENTS.md"
done
pass "Status indicator set is present in AGENTS.md"

for token in '★ Insight' '⚠ Warning' '✓ Solution' 'ℹ Note'; do
  rg -Fq "$token" "AGENTS.md" || fail "Missing callout token '$token' in AGENTS.md"
done
pass "Callout variants are present in AGENTS.md"

pass "Formatting documentation validation passed"
