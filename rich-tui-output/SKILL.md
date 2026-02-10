---
name: rich-tui-output
description: >
  Format ALL responses with rich visual structure for enhanced terminal readability.
  This skill is always active and applies to every interaction. Use rich Unicode
  box-drawing characters, Unicode tables, labeled bullet comparisons, bold
  emphasis, structured sections, insight callout boxes, status badges, color
  annotations, and visual hierarchy in every response. Apply when answering
  questions, explaining code, diagnosing issues, comparing options, showing
  status, summarizing, planning, reviewing, debugging, or any other task. This
  is a presentation layer — it enhances how information is communicated without
  changing what is communicated.
---

# Rich TUI Output

Format every response with visual structure. Make terminal output beautiful and scannable.

## Core Principles

1. **Always format** — Every response gets visual structure, not just special ones
2. **Scannable first** — Users skim before they read; use bold, headers, and boxes to guide eyes
3. **80-column safe** — All visual elements fit within 80 characters; if they cannot fit, switch format
4. **Complement rich-diagrams** — This skill handles response formatting; defer to `rich-diagrams` for standalone diagrams, flowcharts, and architecture visuals
5. **Codex TUI compatible** — Never use markdown pipe tables (`| a | b |`) because they render poorly in the TUI

## Response Profiles

Match structure to task size:
- **Quick reply**: 1 short section + inline emphasis; optional single callout
- **Standard answer**: 2-3 sections + one insight box + status/checklist where relevant
- **Deep diagnosis**: full Diagnosis → Evidence → Fix pattern with Unicode table(s)

## Formatting Elements

### 1. Insight / Callout Boxes

Use for key takeaways, important context, or educational notes.

```
★ Insight ─────────────────────────────────────
Both WARP and Tailscale create utun interfaces on macOS.
When both are active, they fight over the default route.
─────────────────────────────────────────────────
```

Variants:
```
⚠ Warning ─────────────────────────────────────
This will delete all data. Back up first.
─────────────────────────────────────────────────

✓ Solution ────────────────────────────────────
Run `npm cache clean --force` then retry install.
─────────────────────────────────────────────────

ℹ Note ────────────────────────────────────────
This only applies to macOS 15+ with SIP enabled.
─────────────────────────────────────────────────
```

### 2. Bold Key Terms

Always bold:
- **Technical terms** on first use in a section
- **File paths** and **command names** in prose
- **Option labels** (Option A, Option B)
- **Status words** (success, failure, warning, error)
- **Names of services, tools, protocols**

### 3. Structured Sections

Use markdown headers (`##`, `###`) to create clear sections. Standard structure:

```
## Diagnosis (or Summary, or Answer)
Brief overview paragraph.

## The Evidence (or Details, or Analysis)
Supporting information with tables or lists.

## How to Fix It (or Recommendation, or Next Steps)
Actionable items, numbered by preference.
```

### 4. Tables for Structured Data

Never use markdown pipe tables. Use one of two safe patterns:

Simple comparison (labeled bullets):
```
- **Routing**: Tailscale owns mesh routes; WARP owns default internet route
- **DNS**: Tailscale expects MagicDNS; WARP enforces Gateway DoH
- **Outcome**: Route and DNS ownership conflict
```

Complex structured data (Unicode box table in a code block):
```
┌──────────┬──────────────────────────────────────────────┐
│ Time     │ Event                                        │
├──────────┼──────────────────────────────────────────────┤
│ 10:51:50 │ WARP connects successfully                   │
│ 10:52:00 │ Timeout while reaching upstream host         │
│ 10:52:40 │ WARP disconnects: insufficient resource      │
└──────────┴──────────────────────────────────────────────┘
```

Table safety guardrails (always apply):
- Keep full table width at or below 80 characters whenever practical.
- Do not place literal `|` characters inside cell content.
- Do not rely on terminal soft-wrapping; if content does not fit, change format.
- If any cell is long (paths, URLs, model IDs, multi-clause text), prefer labeled bullets instead of a table.
- Use Unicode box tables only for short, atomic values (status, counts, short names, timestamps).

See `references/FORMAT-PATTERNS.md` for more templates.

### 5. Numbered Options with Bold Labels

When presenting choices:

```markdown
**Option A — Restart the service** (quick workaround)
Stops and restarts the daemon. Fastest but temporary.

**Option B — Update the configuration** (proper fix)
Edit `/etc/config.yaml` to add the missing entry.

**Option C — Upgrade to v2.0** (long-term)
Migrates to the new architecture that avoids this entirely.
```

### 6. Status Indicators

```
[✓] Completed    [●] In Progress    [○] Pending    [✗] Failed    [!] Warning
```

### 7. Color Annotations

When output supports ANSI, annotate with semantic colors:
- `[green]` — success, positive, approved, correct
- `[red]` — error, danger, critical, wrong
- `[yellow]` — warning, caution, pending
- `[blue]` — informational, links, references
- `[cyan]` — highlights, emphasis, code identifiers
- `[dim]` — secondary, less important
- `[bold]` — key terms, important values

In markdown (where ANSI isn't available), use **bold** for emphasis and `backticks` for technical values to create visual contrast.

### 8. Inline Code Emphasis

Use backticks liberally for:
- IP addresses: `100.64.0.0/10`
- Paths: `/etc/resolv.conf`
- Commands: `warp-cli connect`
- Config values: `Allow Mode Switch: false`
- Interface names: `utun5`
- Port numbers: `:8080`
- Environment variables: `$HOME`

## When to Dial Back

Use minimal formatting for:
- Single-line answers ("Yes, that's correct.")
- Pure code output (just the code block, no boxes)
- When the user explicitly asks for plain text

## Detailed Patterns

For Unicode table templates, advanced box styles, and complex formatting patterns, see `references/FORMAT-PATTERNS.md`.
