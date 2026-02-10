# codex-rich-tui

Rich-formatting skill package for **Codex TUI** responses.

This project defines a practical, enforceable formatting contract so agent output is:
- Highly scannable in terminal UIs
- Visually structured without being noisy
- Consistent across answers, diagnostics, reviews, and plans
- Compatible with TUI rendering constraints

★ Insight ─────────────────────────────────────
The core standard in this repo is simple:
never use markdown tables in agent output.
Use Option B strict Unicode box tables only when safe.
Otherwise automatically fallback to Option A labeled bullets.
─────────────────────────────────────────────────

## Purpose

Most LLM responses in terminals are technically correct but visually hard to parse.
This repo fixes that by packaging:
- A reusable output skill
- Pattern templates
- Agent-facing instruction contract
- Automated validation to prevent formatting regressions

## Repository Layout

```text
.
├── AGENTS.md
├── README.md
├── validate-format-docs.sh
├── .pre-commit-config.yaml
├── .github/workflows/validate-format-docs.yml
└── rich-tui-output
    ├── SKILL.md
    ├── agents/openai.yaml
    └── references/FORMAT-PATTERNS.md
```

Component responsibilities:
- `AGENTS.md`: global formatting policy and required response elements
- `rich-tui-output/SKILL.md`: operational behavior contract for the skill
- `rich-tui-output/references/FORMAT-PATTERNS.md`: copy-paste-safe visual templates
- `rich-tui-output/agents/openai.yaml`: provider/agent metadata + default prompt
- `validate-format-docs.sh`: policy enforcement for docs consistency

## What the Formatting Standard Requires

- **Callout boxes** for key takeaways (`★ Insight`, `⚠ Warning`, `✓ Solution`, `ℹ Note`)
- **Bold key terms** on first use
- **Inline code** for paths, commands, config values, ports, env vars
- **Structured sections** with clear `##` headings
- **Status badges** (`[✓]`, `[●]`, `[○]`, `[✗]`, `[!]`)
- **No markdown tables**

Accepted alternatives to markdown tables:
- **Option A**: labeled bullet comparisons
- **Option B**: Unicode box tables in fenced code blocks with strict rendering

Option B strict table rendering policy:
- Strip ANSI before width calculation
- Use display width (not raw byte/char length)
- Pre-wrap or truncate cell content to fit column widths
- Validate every rendered row equals table width

Automatic fallback policy:
- If any cell is long or table cannot fit terminal-safe width (~80 cols), fallback to Option A labeled bullets

## Install the Skill Locally

If your **Codex** setup loads skills from `$CODEX_HOME/skills`:

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
mkdir -p "$CODEX_HOME/skills"
rsync -a ./rich-tui-output/ "$CODEX_HOME/skills/rich-tui-output/"
```

If your environment uses a different skill path, copy the `rich-tui-output` directory there.

## Use the Skill

Prompt with:
- `$rich-tui-output`
- Or an equivalent instruction such as:
  - "Use rich TUI formatting"
  - "Use callouts, status markers, Unicode tables; no pipe tables"

The skill supports three practical response profiles:
- **Quick reply**: short, lightly formatted answer
- **Standard answer**: sections + one insight + concise structure
- **Deep diagnosis**: Diagnosis → Evidence → Fix with Unicode tables

## Validation and Enforcement

Run the validator manually:

```bash
./validate-format-docs.sh
```

Current checks include:
- Required docs exist
- No markdown table lines in governed docs
- Explicit no-markdown-table rule exists in each governed doc
- Option B strict-rendering phrases exist in each governed doc
- Automatic fallback phrases exist in each governed doc
- No conflicting "use markdown tables" guidance
- Required status tokens exist in `AGENTS.md`
- Required callout variants exist in `AGENTS.md`

## Pre-commit Integration

This repo includes `.pre-commit-config.yaml` with a local hook:
- Hook id: `validate-format-docs`
- Stages: `pre-commit`, `pre-push`

Typical setup:

```bash
python -m pip install pre-commit
pre-commit install --hook-type pre-commit --hook-type pre-push
pre-commit run --all-files
```

## CI Integration

GitHub Actions workflow:
- File: `.github/workflows/validate-format-docs.yml`
- Triggers:
  - Pull requests
  - Pushes to `main`
- Job installs `ripgrep` and runs `./validate-format-docs.sh`

## Contribution Workflow

When editing formatting docs:
1. Update the relevant source:
   - Behavior: `rich-tui-output/SKILL.md`
   - Reusable templates: `rich-tui-output/references/FORMAT-PATTERNS.md`
   - Global policy: `AGENTS.md`
2. Keep all three consistent
3. Run `./validate-format-docs.sh`
4. Run `pre-commit run --all-files` if pre-commit is installed

## Design Guardrails

Use these as hard constraints unless explicitly overridden:
- Do not use markdown tables in agent output
- Option B tables require strict rendering checks before output
- If any cell is long or table cannot fit terminal-safe width (~80 cols), fallback to Option A labeled bullets
- Keep visual blocks near terminal-safe width
- Prefer semantic structure over decorative noise
- Keep formatting as a presentation layer, not a content substitute

## Troubleshooting

If validation fails:
- Read the exact `[✗]` message from `validate-format-docs.sh`
- Fix the referenced file and rerun the script
- Ensure no `| ... |` lines exist in governed docs unless they are literal examples explicitly forbidden by policy text

If the skill appears ignored:
- Confirm the skill directory is in your active skill path
- Confirm the prompt explicitly requests `$rich-tui-output`
- Confirm no higher-priority instruction disables rich formatting

## Roadmap Ideas

- Expand validator to check width constraints on template lines
- Add snapshot-style tests for canonical response examples
- Add profile-specific templates (quick, standard, deep) as standalone assets
- Add contributor script to scaffold new pattern sections safely
