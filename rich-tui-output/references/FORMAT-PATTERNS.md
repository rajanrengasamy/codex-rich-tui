# Format Patterns Reference

Detailed templates for rich TUI formatting. Load this file when building complex formatted output.

## Codex TUI Compatibility Rules

Keep all patterns renderer-safe:
- No markdown pipe tables (`| col | col |`)
- Prefer Unicode box tables inside fenced code blocks
- Keep visual blocks near 80 columns and avoid overflow
- Use labeled bullet lists when tabular structure is light

## Table Safety Guardrails

Apply these before rendering any Unicode table:
- Use tables only for short, atomic values.
- If values include long paths, URLs, model names, or sentence-like text, use labeled bullets.
- Never include literal `|` characters inside cell text.
- Never depend on terminal soft-wrap to preserve borders.
- If width cannot stay within ~80 columns, switch to bullet or sectioned list format.

Safe fallback for long values:

```markdown
- **Provider**: Google Gemini (`@google/genai`)
- **Model**: `gemini-2.5-flash`
- **Used For**: LinkedIn post, X thread, article draft
```

## Unicode Box Styles

### Standard Box (Single-line)
```
┌─────────────────────────────────────────────────────────────────────────┐
│  Content goes here with 2-space padding on each side                   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Emphasis Box (Double-line)
```
╔═════════════════════════════════════════════════════════════════════════╗
║  ★ KEY INSIGHT                                                         ║
║  Critical information that must not be missed.                         ║
╚═════════════════════════════════════════════════════════════════════════╝
```

### Rounded Box (Soft)
```
╭─────────────────────────────────────────────────────────────────────────╮
│  Softer visual style for notes and tips                                │
╰─────────────────────────────────────────────────────────────────────────╯
```

### Open Callout (Header + Rule)
```
★ Insight ─────────────────────────────────────
Content without side borders. Lighter visual weight.
Preferred for inline callouts within longer responses.
─────────────────────────────────────────────────
```

## Unicode Table Patterns

### Basic Data Table
```
┌────────────────┬─────────────────┬─────────────────┐
│    Column A    │    Column B     │    Column C     │
├────────────────┼─────────────────┼─────────────────┤
│ Row 1 data     │ Value           │ Status          │
│ Row 2 data     │ Value           │ Status          │
│ Row 3 data     │ Value           │ Status          │
└────────────────┴─────────────────┴─────────────────┘
```

### Comparison Table with Status
```
┌──────────────┬──────────┬──────────┬──────────────────────────────┐
│   Feature    │  Tool A  │  Tool B  │           Notes              │
├──────────────┼──────────┼──────────┼──────────────────────────────┤
│ Speed        │  [✓] ★   │  [✓]     │ A is 2x faster               │
│ Memory       │  [✗]     │  [✓] ★   │ B uses 50% less RAM          │
│ Plugins      │  [✓]     │  [✗]     │ A has 200+ plugins           │
│ Price        │  [✓] ★   │  [✓]     │ Both free, A has better tier │
└──────────────┴──────────┴──────────┴──────────────────────────────┘
★ = better option for this category
```

### Key-Value Layout
```
┌─────────────────┬────────────────────────────────────────────────┐
│ Service          │ Cloudflare WARP                                │
│ Mode             │ WarpWithDnsOverHttps (MASQUE)                  │
│ Interface        │ utun5                                          │
│ Status           │ [✗] Disconnected                               │
│ Last Error       │ "Insufficient System Resource"                 │
└─────────────────┴────────────────────────────────────────────────┘
```

## Section Header Styles

### Primary Header (for major sections)
```markdown
## Diagnosis: Service Name Issue
```

### Decorated Subheader
```
─── The Evidence ──────────────────────────────
```

### Numbered Section
```markdown
### 1. Routing conflict
WARP takes over the default route, but Tailscale's `utun5` also claims routes.
```

## Progress and Status Patterns

### Step Progress
```
Step 1 ─────────● Complete
Step 2 ─────────● Complete
Step 3 ─────────◐ In Progress
Step 4 ─────────○ Pending
Step 5 ─────────○ Pending
```

### Checklist
```
[✓] Dependencies installed
[✓] Configuration validated
[●] Building project...
[○] Run tests
[○] Deploy
```

### Severity Scale
```
[■■■■■] CRITICAL  — Service down, data loss imminent
[■■■■□] HIGH      — Major feature broken, workaround exists
[■■■□□] MEDIUM    — Bug affecting some users
[■■□□□] LOW       — Cosmetic issue
[■□□□□] INFO      — Enhancement request
```

## Diagnostic Output Pattern

Template for troubleshooting responses:

````markdown
## Diagnosis: [Problem Title]

Brief 1-2 sentence summary of what's happening.

★ Insight ─────────────────────────────────────
[Key technical insight the user needs to understand]
─────────────────────────────────────────────────

## The Evidence

The log at `[path]` shows:

```text
┌──────────┬──────────────────────────────────────────────┐
│ Time     │ Event                                        │
├──────────┼──────────────────────────────────────────────┤
│ HH:MM:SS │ First relevant event                         │
│ HH:MM:SS │ Key event (with emphasis)                   │
│ HH:MM:SS │ Final relevant event                         │
└──────────┴──────────────────────────────────────────────┘
```

## The Problem(s)

1. **Problem A**: Description with `technical values` highlighted
2. **Problem B**: Description with `technical values` highlighted

## How to Fix It

**Option A — [Label]** (quick workaround)
Description and commands.

**Option B — [Label]** (proper fix)
Description and commands.
````

## Comparison / Decision Pattern

Template for comparing options:

````markdown
## Options Analysis

```text
┌────────────┬──────────────┬──────────────┬──────────────┐
│ Criteria   │ Option A     │ Option B     │ Option C     │
├────────────┼──────────────┼──────────────┼──────────────┤
│ Speed      │ ★ Fast       │ Medium       │ Slow         │
│ Complexity │ Low          │ ★ Low        │ High         │
│ Durability │ Temporary    │ Medium       │ ★ Permanent  │
└────────────┴──────────────┴──────────────┴──────────────┘
```

**Recommendation**: Option B — best balance of effort vs. durability.
````

## Code Explanation Pattern

Template for explaining code:

````markdown
## How `functionName` Works

Brief description of purpose.

★ Insight ─────────────────────────────────────
[Key architectural or design insight]
─────────────────────────────────────────────────

### The Flow

1. **Input validation** — Checks `param` against schema
2. **Processing** — Transforms data using `helperFn()`
3. **Output** — Returns `ResultType` with status

### Key Details

```text
┌───────────────┬───────────────────────────────┬─────────────────┐
│ Component     │ Role                          │ File            │
├───────────────┼───────────────────────────────┼─────────────────┤
│ `validate()`  │ Input sanitization            │ `src/utils.ts`  │
│ `transform()` │ Core business logic           │ `src/core.ts`   │
│ `format()`    │ Output serialization          │ `src/output.ts` │
└───────────────┴───────────────────────────────┴─────────────────┘
```
````

## Character Quick Reference

```
Boxes:      ┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼
Double:     ╔ ═ ╗ ║ ╚ ╝ ╠ ╣ ╦ ╩ ╬
Heavy:      ┏ ━ ┓ ┃ ┗ ┛ ┣ ┫ ┳ ┻ ╋
Rounded:    ╭ ╮ ╰ ╯
Arrows:     → ← ↑ ↓ ▶ ◀ ▲ ▼ ⟶ ⟵
Decorators: ★ ● ○ ◆ ◇ ▪ ▫ □ ■ ◐
Checks:     ✓ ✗ ⚠ ℹ
Bullets:    • ◦ ‣ ➤ ►
Rules:      ─────── ═══════ ━━━━━━━
```
