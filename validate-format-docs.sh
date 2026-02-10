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
  warn "Markdown table lines detected:"
  cat /tmp/validate-format-docs-pipe-tables.txt
  fail "Remove markdown tables and use Unicode tables or labeled bullets"
fi
pass "No markdown table lines found"

for file in "${DOC_FILES[@]}"; do
  if ! rg -qi 'no markdown tables|never use markdown tables|no markdown pipe tables|never use markdown pipe tables' "$file"; then
    fail "No explicit no-markdown-table rule found in $file"
  fi
done
pass "No-markdown-table rule present in all governed docs"

OPTION_B_PHRASES=(
  "strip ANSI before width calculation"
  "use display width, not raw byte/char length"
  "pre-wrap or truncate cell content to fit column widths"
  "validate every rendered row equals table width"
)

for phrase in "${OPTION_B_PHRASES[@]}"; do
  for file in "${DOC_FILES[@]}"; do
    rg -Fqi "$phrase" "$file" || fail "Missing Option B phrase '$phrase' in $file"
  done
done
pass "Option B strict-rendering phrases present in all governed docs"

FALLBACK_PHRASE="if any cell is long or table cannot fit terminal-safe width (~80 cols), fallback to Option A labeled bullets"
for file in "${DOC_FILES[@]}"; do
  rg -Fqi "$FALLBACK_PHRASE" "$file" || fail "Missing fallback phrase in $file"
done
pass "Automatic fallback phrase present in all governed docs"

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
