---
name: markdown-standards
description: >
  Markdown linting with markdownlint-cli2. Use when writing or editing Markdown,
  fixing lint errors, or reviewing quality. Covers lint commands, config priority,
  and false-positive suppression.
compatibility: |
  Required: Node.js 22+
  Packages: markdownlint-cli2
---

# Markdown Standards — markdown-standards

Enforce Markdown quality through markdownlint-cli2 static analysis combined with
AI-supplementary rules.

## Setup

When no project config exists, copy the default config from this skill's `assets/` directory:

```bash
SKILL_ASSETS="$HOME/.config/opencode/skills/markdown-standards/assets"
cp "$SKILL_ASSETS/.markdownlint-cli2.yaml" ./.markdownlint-cli2.yaml
```

## Running markdownlint-cli2

```bash
# Lint a single file
markdownlint-cli2 "path/to/file.md"

# Lint all Markdown files recursively
markdownlint-cli2 "**/*.md" "#node_modules"

# Auto-fix fixable errors
markdownlint-cli2 --fix "**/*.md" "#node_modules"
```

## Project Config Priority

markdownlint-cli2 searches for configuration files in this order (first match wins):

1. `.markdownlint-cli2.jsonc`
2. `.markdownlint-cli2.yaml`
3. `.markdownlint-cli2.cjs` / `.markdownlint-cli2.mjs`
4. `.markdownlint.jsonc` / `.markdownlint.json`
5. `.markdownlint.yaml` / `.markdownlint.yml`
6. `.markdownlint.cjs` / `.markdownlint.mjs`
7. `package.json` (`markdownlint` key)

**When a project config is found, use it as-is.** Apply the Default Rule
Configuration below only when no project config exists.

## Default Rule Configuration

The default config in `assets/.markdownlint-cli2.yaml` enables all rules with one customization:

```yaml
config:
  default: true
  MD024:
    siblings_only: true
```

All rules are enabled (`default: true`). MD024 is set to `siblings_only: true` to allow
duplicate headings across different sections (e.g., multiple `### Parameters` in different
parent sections). The `config:` wrapper is required by the `.markdownlint-cli2.yaml` options
file format.

## Interpreting Results

Each error line shows: `file:line:col  rule-name/alias  message`

Example:

```
README.md:10:1  MD022/blanks-around-headings  Headings should be surrounded by blank lines
README.md:24    MD040/fenced-code-language     Fenced code blocks should have a language specified
```

Severity: all markdownlint violations are errors unless suppressed.

## Suppressing False Positives

When markdownlint incorrectly flags valid content:

```markdown
<!-- markdownlint-disable MD013 -->
This line is intentionally long because it contains a URL or table that cannot be broken.
<!-- markdownlint-enable MD013 -->
```

For a single line:

```markdown
This line is intentionally long. <!-- markdownlint-disable-line MD013 -->
```

Common false-positive cases:

- Long lines containing URLs — suppress `MD013`
- Duplicate headings in different sections (e.g., multiple `### Parameters`) — use `siblings_only: true` in MD024 config instead of suppression
- Generated content mixed with hand-written docs — suppress at file level with `<!-- markdownlint-disable -->` at top

## Rules markdownlint Cannot Detect (AI Supplement Required)

The following must be checked manually or by AI:

### Descriptive link text

markdownlint has no rule for link text quality. Avoid generic anchor text:

| Wrong | Correct |
|---|---|
| `[click here](url)` | `[markdownlint-cli2 documentation](url)` |
| `[here](url)` | `[installation guide](url)` |
| `[this](url)` | `[configuration reference](url)` |

### Meaningful alt text for images

MD045 only checks that alt text is present, not that it is meaningful:

- Wrong: `![image](./screenshot.png)`
- Correct: `![Screenshot of the configuration dialog showing the timeout field](./screenshot.png)`

### Heading hierarchy intent

MD001 enforces that levels increment by one, but cannot check semantic structure.
Ensure headings reflect the actual document hierarchy — do not use heading levels
for visual sizing.
