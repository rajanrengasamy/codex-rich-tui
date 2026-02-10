# Global Agent Instructions

## Output Formatting — Always Active

Format every response with rich visual structure for terminal readability. This applies to ALL interactions — explanations, debugging, comparisons, planning, code review, and general Q&A.

### Source of Truth

For skill behavior and reusable templates, treat:
- `rich-tui-output/SKILL.md` as the behavioral contract
- `rich-tui-output/references/FORMAT-PATTERNS.md` as the pattern library

If examples in different files ever conflict, prefer the most TUI-safe rendering rule:
1. No markdown pipe tables
2. Use Unicode box tables in fenced code blocks
3. Use labeled bullet comparisons for lightweight cases

### Required Formatting Elements

1. **Insight callout boxes** for key takeaways and educational context:
   ```
   ★ Insight ─────────────────────────────────────
   Key technical insight or educational note here.
   ─────────────────────────────────────────────────
   ```
   Variants: `⚠ Warning`, `✓ Solution`, `ℹ Note`

2. **Bold key terms** — Always bold service names, file paths, commands, status words, and option labels on first use

3. **Tables — NEVER use markdown pipe tables** (they don't render in the TUI). Instead use one of these formats:

   **For simple comparisons, use bullet lists with bold labels:**
   ```
   - **Routing**: Tailscale wants own routes; WARP wants full internet → Route conflict
   - **DNS**: Tailscale uses MagicDNS; WARP uses Gateway → DNS conflict
   ```

   **For complex tabular data, use Unicode box tables inside code blocks:**
   ```
   ┌──────────────┬──────────────────┬──────────────────┬────────────────┐
   │  Component   │  Tailscale       │  Cloudflare WARP │  Result        │
   ├──────────────┼──────────────────┼──────────────────┼────────────────┤
   │  Routing     │  Own routes      │  Full internet   │  Conflict      │
   │  DNS         │  MagicDNS        │  Gateway DoH     │  Conflict      │
   │  VPN slot    │  Active tunnel   │  Active tunnel   │  OS limit      │
   └──────────────┴──────────────────┴──────────────────┴────────────────┘
   ```
   Safety rules for Unicode tables:
   - Keep table width near 80 columns and avoid overflow.
   - Do not place raw `|` characters in cell content.
   - Do not rely on terminal soft-wrapping for row alignment.
   - If cells are long (paths, URLs, model IDs, sentence-like text), switch to labeled bullets.

4. **Numbered options with bold labels** for presenting choices:
   ```
   **Option A — Label** (quick workaround)
   Description.

   **Option B — Label** (proper fix)
   Description.
   ```

5. **Status indicators** — `[✓] Done  [●] Running  [○] Pending  [✗] Failed  [!] Warning`

6. **Inline code** — Use backticks liberally for IPs, paths, commands, config values, interface names, ports, env vars

7. **Structured sections** — Use `##` headers to create scannable sections. Follow patterns like: Diagnosis → Evidence → Fix, or Summary → Details → Next Steps

8. **Color annotations** where ANSI is supported:
   - `[green]` success, `[red]` error, `[yellow]` warning, `[blue]` info, `[cyan]` highlight, `[dim]` secondary

### Box Styles

**Standard callout (open style — preferred for inline use):**
```
★ Insight ─────────────────────────────────────
Content without side borders. Lighter visual weight.
─────────────────────────────────────────────────
```

**Emphasis box (for critical info):**
```
╔═════════════════════════════════════════════════════════════════════════╗
║  ★ KEY INSIGHT                                                         ║
║  Critical information that must not be missed.                         ║
╚═════════════════════════════════════════════════════════════════════════╝
```

**Rounded box (soft style for notes):**
```
╭─────────────────────────────────────────────────────────────────────────╮
│  Softer visual style for tips and notes                                │
╰─────────────────────────────────────────────────────────────────────────╯
```

### Key-Value Display

For config/status info, use this pattern inside a code block:
```
┌─────────────────┬────────────────────────────────────────────────┐
│ Service          │ Cloudflare WARP                                │
│ Mode             │ WarpWithDnsOverHttps (MASQUE)                  │
│ Interface        │ utun5                                          │
│ Status           │ [✗] Disconnected                               │
└─────────────────┴────────────────────────────────────────────────┘
```

### Comparison / Decision Layout

For comparing options, use Unicode tables inside code blocks:
```
┌──────────────┬──────────┬──────────┬──────────────────────────────┐
│   Feature    │  Tool A  │  Tool B  │           Notes              │
├──────────────┼──────────┼──────────┼──────────────────────────────┤
│ Speed        │  [✓] ★   │  [✓]     │ A is 2x faster               │
│ Memory       │  [✗]     │  [✓] ★   │ B uses 50% less RAM          │
│ Plugins      │  [✓]     │  [✗]     │ A has 200+ plugins           │
└──────────────┴──────────┴──────────┴──────────────────────────────┘
★ = better option for this category
```

### Diagnostic Output Pattern

Template for troubleshooting responses:

```
## Diagnosis: [Problem Title]

Brief 1-2 sentence summary.

★ Insight ─────────────────────────────────────
[Key technical insight the user needs]
─────────────────────────────────────────────────

## The Evidence

The log at `[path]` shows:

┌──────────┬──────────────────────────────────────────────┐
│ HH:MM:SS │ First relevant event                         │
│ HH:MM:SS │ **Key event** with emphasis                  │
│ HH:MM:SS │ Final relevant event                         │
└──────────┴──────────────────────────────────────────────┘

## The Problem(s)

1. **Problem A**: Description with `technical values`
2. **Problem B**: Description with `technical values`

## How to Fix It

**Option A — [Label]** (quick workaround)
Description and commands.

**Option B — [Label]** (proper fix)
Description and commands.
```

### Progress and Checklist Patterns

```
Step 1 ─────────● Complete
Step 2 ─────────● Complete
Step 3 ─────────◐ In Progress
Step 4 ─────────○ Pending
```

```
[✓] Dependencies installed
[✓] Configuration validated
[●] Building project...
[○] Run tests
[○] Deploy
```

### Character Quick Reference

```
Boxes:      ┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼
Double:     ╔ ═ ╗ ║ ╚ ╝ ╠ ╣ ╦ ╩ ╬
Rounded:    ╭ ╮ ╰ ╯
Arrows:     → ← ↑ ↓ ▶ ◀ ▲ ▼
Decorators: ★ ● ○ ◆ ◇ ▪ ▫ □ ■ ◐
Checks:     ✓ ✗ ⚠ ℹ
```

### When to Dial Back

Use minimal formatting for single-line answers and pure code output.

### Skill Reference

For standalone diagrams, flowcharts, and architecture visuals, use the `rich-diagrams` skill.

### Maintenance Checklist (for instruction edits)

Before finalizing changes to formatting guidance:
- [ ] No markdown pipe tables were introduced
- [ ] Examples render cleanly in plain terminal width
- [ ] `AGENTS.md`, `rich-tui-output/SKILL.md`, and `rich-tui-output/references/FORMAT-PATTERNS.md` are consistent
- [ ] Required status badges and callout box patterns still exist
