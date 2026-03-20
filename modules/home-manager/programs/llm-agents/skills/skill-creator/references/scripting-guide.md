# Scripting Guide

Complete reference for using scripts in skills: one-off commands, self-contained scripts, and designing scripts for agentic execution.

## One-off Commands

When an existing package already does what you need, reference it directly in `SKILL.md` — no `scripts/` directory required.

### Runners by Ecosystem

**Python — uvx (recommended)**
```bash
uvx ruff@0.8.0 check .
uvx black@24.10.0 .
```
- Requires [uv](https://docs.astral.sh/uv/) — fast, aggressive caching, near-instant repeat runs
- Not bundled with Python; must be installed separately

**Python — pipx**
```bash
pipx run 'black==24.10.0' .
pipx run 'ruff==0.8.0' check .
```
- Available via OS package managers (`apt install pipx`, `brew install pipx`)
- Mature alternative to uvx

**Node.js — npx**
```bash
npx eslint@9.0.0 --fix .
npx create-vite@6 my-app
```
- Bundled with Node.js — no extra install
- Downloads and caches the package on first run

**Node.js (Bun) — bunx**
```bash
bunx eslint@9 --fix .
bunx create-vite@6 my-app
```
- Drop-in replacement for npx in Bun environments
- Use only when the user's environment has Bun rather than Node.js

**Deno — deno run**
```bash
deno run npm:create-vite@6 my-app
deno run --allow-read npm:eslint@9 -- --fix .
```
- Permission flags required (`--allow-read`, `--allow-write`, etc.)
- Use `--` to separate Deno flags from the tool's own flags

**Go — go run**
```bash
go run golang.org/x/tools/cmd/goimports@v0.28.0 .
go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.0 run
```
- Built into Go — no extra tooling
- Pin versions or use `@latest` for explicit behavior

### Tips for One-off Commands in Skills

- **Pin versions** (`npx eslint@9.0.0`) for reproducibility
- **State prerequisites** in `SKILL.md` (e.g., "Requires Node.js 18+") and in the `compatibility` frontmatter field
- **Move complex commands into scripts** when a command grows too complex to get right on the first try

---

## Self-contained Scripts

Bundle scripts in `scripts/` that declare their own dependencies inline. Agents run them with a single command — no separate install step.

### Python — PEP 723 Inline Script Metadata

```python
# scripts/extract.py
# /// script
# dependencies = [
#   "beautifulsoup4>=4.12,<5",
# ]
# requires-python = ">=3.11"
# ///

from bs4 import BeautifulSoup

html = '<html><body><h1>Welcome</h1><p class="info">Test.</p></body></html>'
print(BeautifulSoup(html, "html.parser").select_one("p.info").get_text())
```

Run with:
```bash
uv run scripts/extract.py
```

- `uv run` creates an isolated environment, installs declared dependencies, and runs the script
- `pipx run scripts/extract.py` also supports PEP 723
- Use PEP 508 specifiers to pin versions: `"beautifulsoup4>=4.12,<5"`
- Use `uv lock --script` for a lockfile with full reproducibility

### Deno — `npm:` and `jsr:` Import Specifiers

```typescript
// scripts/extract.ts
#!/usr/bin/env -S deno run

import * as cheerio from "npm:cheerio@1.0.0";

const html = `<html><body><p class="info">Test.</p></body></html>`;
const $ = cheerio.load(html);
console.log($("p.info").text());
```

Run with:
```bash
deno run scripts/extract.ts
```

- Use `npm:` for npm packages, `jsr:` for Deno-native packages
- Dependencies cached globally; use `--reload` to force re-fetch
- Native addons (node-gyp) may not work; prefer packages with pre-built binaries

### Bun — Auto-install at Runtime

```typescript
// scripts/extract.ts
#!/usr/bin/env bun

import * as cheerio from "cheerio@1.0.0";

const html = `<html><body><p class="info">Test.</p></body></html>`;
const $ = cheerio.load(html);
console.log($("p.info").text());
```

Run with:
```bash
bun run scripts/extract.ts
```

- No `package.json` or `node_modules` needed; TypeScript works natively
- Packages cached globally; first run downloads, subsequent runs are near-instant
- **Caveat:** If a `node_modules` directory exists anywhere up the directory tree, auto-install is disabled and Bun falls back to standard Node.js resolution

### Ruby — `bundler/inline`

```ruby
# scripts/extract.rb
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'nokogiri', '~> 1.16'
end

html = '<html><body><p class="info">Test.</p></body></html>'
doc = Nokogiri::HTML(html)
puts doc.at_css('p.info').text
```

Run with:
```bash
ruby scripts/extract.rb
```

- `bundler/inline` ships with Ruby since 2.6
- Pin gem versions explicitly (`'~> 1.16'`) — there is no lockfile
- An existing `Gemfile` or `BUNDLE_GEMFILE` env var can interfere

---

## Designing Scripts for Agentic Use

Agents read stdout and stderr to decide what to do next. These design choices make scripts reliable in agentic pipelines.

### No Interactive Prompts

**Hard requirement.** Agents operate in non-interactive shells — they cannot respond to TTY prompts, password dialogs, or confirmation menus. A script that blocks on interactive input will hang indefinitely.

Accept all input via command-line flags, environment variables, or stdin:

```
# Bad: hangs waiting for input
$ python scripts/deploy.py
Target environment: _

# Good: clear error with guidance
$ python scripts/deploy.py
Error: --env is required. Options: development, staging, production.
Usage: python scripts/deploy.py --env staging --tag v1.2.3
```

### Document Usage with `--help`

`--help` output is the primary way an agent learns your script's interface. Include a brief description, available flags, and examples:

```
Usage: scripts/process.py [OPTIONS] INPUT_FILE

Process input data and produce a summary report.

Options:
  --format FORMAT    Output format: json, csv, table (default: json)
  --output FILE      Write output to FILE instead of stdout
  --verbose          Print progress to stderr

Examples:
  scripts/process.py data.csv
  scripts/process.py --format csv --output report.csv data.csv
```

Keep it concise — the output enters the agent's context window alongside everything else.

### Write Helpful Error Messages

When an agent gets an error, the message directly shapes its next attempt:

```
# Bad — wastes a turn
Error: invalid input

# Good — actionable
Error: --format must be one of: json, csv, table.
       Received: "xml"
```

### Use Structured Output

Prefer JSON, CSV, or TSV over free-form text — structured formats are composable with `jq`, `cut`, `awk`, and other tools:

```
# Bad — hard to parse programmatically
NAME          STATUS    CREATED
my-service    running   2025-01-15

# Good — unambiguous field boundaries
{"name": "my-service", "status": "running", "created": "2025-01-15"}
```

**Separate data from diagnostics:** send structured data to stdout and progress messages/warnings to stderr.

### Further Considerations

| Concern | Guidance |
|---------|----------|
| **Idempotency** | Agents may retry commands. "Create if not exists" is safer than "fail on duplicate." |
| **Input constraints** | Reject ambiguous input with a clear error; use enums and closed sets. |
| **`--dry-run`** | For destructive or stateful operations, let agents preview what will happen. |
| **Exit codes** | Use distinct codes for different failure types (not found, invalid args, auth failure); document in `--help`. |
| **Safe defaults** | Consider requiring `--confirm` or `--force` flags for destructive operations. |
| **Output size** | Agent harnesses may truncate output beyond 10-30K characters. Default to summaries; support `--offset` or `--output FILE` for large output. |
