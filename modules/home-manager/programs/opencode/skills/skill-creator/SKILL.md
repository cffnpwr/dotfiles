---
name: skill-creator
description: Guide for creating effective skills with explicit dependency management and eval framework. Use when creating new skills, updating existing skills, or testing skill quality with evals. Key features: mandatory compatibility field, multi-language support (Python 3.11+, Node.js 22+, Bash, Ruby, Perl, PHP, PowerShell, R, Lua), automated dependency detection via assess_compatibility.py, SubAgent review integration, strict validation, one-off command patterns (uvx/npx/go run), self-contained scripts with inline dependencies (PEP 723/Deno/Bun/Ruby), agentic script design guidelines, agent environment detection via detect_env.py, and eval framework for measuring and improving skill quality. Triggers when user wants to create a new skill, package an existing skill, test or improve a skill with evals, or needs guidance on skill structure, compatibility requirements, or script design for agents.
compatibility: |
  Required: Python 3.11+, PyYAML
  Scripts: init_skill.py, assess_compatibility.py, quick_validate.py, package_skill.py, detect_env.py, aggregate_benchmark.py
  Note: Python 3.10 may work but reaches EOL in October 2026.
---

# Skill Creator

Guide for creating effective Agent Skills with explicit dependency management and validation.

## Overview

This skill provides guidance and tools for creating Agent Skills—modular packages that extend AI Agent capabilities with specialized knowledge, workflows, and tools. Think of skills as "onboarding guides" that transform general-purpose agents into specialized agents equipped with domain-specific knowledge.

**Key Improvements over Official skill-creator:**

1. **Mandatory `compatibility` field** - All skills must explicitly declare dependencies or state "No external dependencies"
2. **Dependency assessment workflow** - Automated analysis via `assess_compatibility.py`, SubAgent delegation, or manual checklist
3. **Multi-language support** - Python 3.11+, Node.js 22+, Bash with full analysis; Ruby, Perl, PHP, PowerShell, R, Lua with basic detection
4. **SubAgent review integration** - Automated validation of compatibility declarations and script dependencies
5. **Strict validation** - Enforces compatibility field presence, script-dependency consistency, environment check instructions
6. **One-off command patterns** - uvx/npx/go run for dependency-free tool execution without a scripts/ directory
7. **Self-contained scripts** - PEP 723 (Python), Deno, Bun, Ruby inline dependencies for zero-setup scripts
8. **Agentic script design** - Non-interactive, structured output, idempotency, `--help`, exit codes

## Environment Check

This skill requires Python 3.11+ for script execution:

```bash
python3 --version  # Should be 3.11 or higher
pip3 show PyYAML   # Required for validation
```

If Python 3.11+ is not available:

> "This skill requires Python 3.11+ for skill creation, dependency analysis, and validation. Please install Python 3.11+ from python.org or via your system package manager."

## Quick Start

**Creating a new skill:**

1. Initialize skill structure:
   ```bash
   python scripts/init_skill.py my-skill-name --path /output/path
   ```

2. Edit `my-skill-name/SKILL.md`:
   - Complete the description
   - Implement skill instructions
   - Add scripts/references/assets as needed

3. Assess compatibility:
   ```bash
   python scripts/assess_compatibility.py my-skill-name/
   ```

4. Update compatibility field in SKILL.md based on assessment

5. Validate:
   ```bash
   python scripts/quick_validate.py my-skill-name/
   ```

6. Package:
   ```bash
   python scripts/package_skill.py my-skill-name/
   ```

## Detailed Documentation

For comprehensive guidance, see:

- **[Step-by-Step Guide](references/step-by-step-guide.md)** - Complete workflow from conception to packaging
- **[Compatibility Assessment](references/compatibility-guide.md)** - Detailed guide for determining dependencies
- **[Scripting Guide](references/scripting-guide.md)** - One-off commands, self-contained scripts, agentic design
- **[Scripts Reference](references/scripts-reference.md)** - Full CLI usage for all bundled scripts
- **[Workflows](references/workflows.md)** - Sequential and conditional workflow patterns
- **[Output Patterns](references/output-patterns.md)** - Template and example-based skill design
- **[Eval Guide](references/eval-guide.md)** - Testing, measuring, and improving skills with evals
- **[Eval Schemas](references/schemas.md)** - JSON schemas for evals.json, grading.json, benchmark.json

## Core Principles

### Skill Types

Skills fall into two categories. Knowing which type you're building shapes every design decision.

**Capability uplift skills** give agents knowledge or tools they don't already have:
- Domain-specific APIs, schemas, workflows
- Bundled scripts for complex operations
- Reference documentation too large to memorize
- Examples: pdf-editor, github-workflow, database-migration

**Encoded preference skills** adjust how agents behave, not what they can do:
- Coding style guides, naming conventions
- Output format preferences
- Communication tone or language rules
- Examples: ja-writing, code-quality-standards, commit-conventions

The distinction matters because:
- Capability uplift skills need thorough coverage of their domain
- Encoded preference skills need precise, unambiguous rules (vague preferences produce inconsistent behavior)

### Concise is Key

The context window is shared by system prompts, conversation history, other skills' metadata, and user requests. Only add information AI Agents don't already have.

**Default assumption: AI Agents are already smart.** Challenge each piece of information: "Does the agent really need this explanation?" and "Does this justify its token cost?"

Prefer concise examples over verbose explanations.

### Set Appropriate Degrees of Freedom

Match specificity to task fragility and variability:

- **High freedom** (text-based instructions): Multiple valid approaches, context-dependent decisions
- **Medium freedom** (pseudocode or parameterized scripts): Preferred pattern exists, variation acceptable
- **Low freedom** (specific scripts): Operations are fragile, consistency critical, specific sequence required

### Mandatory Compatibility Declaration

**Every skill must have a `compatibility` field** stating either:

1. External dependencies (language versions, packages, tools), OR
2. "No external dependencies. Works in all environments."

This ensures AI Agents can:
- Check environment requirements before execution
- Inform users of missing dependencies
- Provide installation guidance

See [Compatibility Assessment Guide](references/compatibility-guide.md) for details.

### Description Design Philosophy

The `description` field is the agent's only signal for deciding whether to load the skill.
A poorly written description causes **undertriggering** (skill never loads when needed) or
**overtriggering** (skill loads on irrelevant tasks, wasting context).

**Guidelines:**

- **100–200 words is the target range.** Too short → undertrigger. Too long → dilutes signal.
- **"When to use" belongs in `description`, not in SKILL.md body.** The agent reads the description
  before deciding to load the skill. If trigger conditions are buried in the body, the skill
  never loads for them.
- **List concrete triggering scenarios explicitly.** "Use when (1) creating a new skill,
  (2) packaging an existing skill, (3) testing skill quality" outperforms vague language like
  "Use for skill-related tasks."
- **Avoid MUSTs and NEVERs in descriptions.** Strong rules in the description sound like constraints
  on the agent's general behavior, not guidance on when to load the skill.
- **Don't optimize for a single phrasing.** Users phrase the same intent many ways. Cover the
  semantic space, not specific words.
- **Test with evals.** If triggering is unreliable, run the eval framework with
  `run_type: "without_skill"` as baseline to confirm the skill is the variable.

**Anti-patterns:**
- "Use this skill for all skill-related tasks" — too vague, undertriggers
- Repeating the skill name multiple times — wastes tokens, no signal gain
- Listing every feature instead of describing when to load — overtriggers on tangential matches

## Eval Framework

Evals measure whether a skill actually improves agent behavior. Use them when:
- A skill's trigger reliability is uncertain
- You want to compare two description variants
- You're making significant changes and need a regression check

**Quick workflow:**

1. Define test cases in `evals/evals.json`
2. Run each case with the agent (with skill loaded)
3. Grade results with `agents/grader.md`
4. Aggregate with `scripts/aggregate_benchmark.py`
5. Analyze trends with `agents/analyzer.md`
6. Iterate on description or skill content

The `evals/` directory is **excluded from packaging** — it is a development artifact.

**For the full workflow:** See [references/eval-guide.md](references/eval-guide.md)

**For JSON schemas:** See [references/schemas.md](references/schemas.md)

**Agent environment detection** (required before running evals):

```bash
python scripts/detect_env.py
```

Output identifies your agent and the correct headless command for running eval cases.

## Skill Anatomy

Every skill consists of:

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description, compatibility)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/          - Executable code (Python/Bash/Node.js/etc.)
    ├── references/       - Documentation loaded as needed
    └── assets/           - Files used in output (templates, images, etc.)
```

### SKILL.md Frontmatter

Required fields:
- **name**: Kebab-case identifier (max 64 chars)
- **description**: What the skill does and when to use it (max 1024 chars, be comprehensive)
- **compatibility**: Dependencies or "No external dependencies" (max 500 chars)

Optional fields:
- **license**: License information
- **allowed-tools**: Tool restrictions (platform-specific)
- **metadata**: Additional structured data

### Bundled Resources

#### scripts/
Executable code for deterministic, repeated operations:
- **When to include**: Same code rewritten repeatedly, or deterministic reliability needed
- **Benefits**: Token efficient, reliable, may execute without loading into context
- **Languages**: Python 3.11+, Node.js 22+, Bash preferred; Ruby, Perl, PHP, PowerShell, R, Lua supported
- **Reference scripts via relative paths**: `bash scripts/validate.sh "$INPUT"` — paths are relative to skill directory root
- **One-off alternative**: When an existing package does what you need, instruct agents to run `uvx tool@version`, `npx tool@version`, or `go run pkg@version` directly — no scripts/ directory needed
- **Self-contained scripts**: Use PEP 723 (Python), Deno `npm:` imports, Bun auto-install, or Ruby `bundler/inline` to declare dependencies inline — agents run with a single command, no separate install step

#### references/
Documentation loaded into context as needed:
- **When to include**: Detailed API docs, schemas, comprehensive guides, policies
- **Benefits**: Keeps SKILL.md lean, loaded only when needed
- **Best practice**: For files >10k words, include grep patterns in SKILL.md

#### assets/
Files used in output, not loaded into context:
- **When to include**: Templates, images, fonts, boilerplate code, sample data
- **Benefits**: Reuse without context consumption, supports template-based generation

## Supported Script Languages

### Tier 1: Full Dependency Analysis

- **Python** (.py) - Version 3.11+, import analysis, stdlib vs external detection
- **Node.js** (.js) - Version 22+, require/import analysis, built-ins vs npm detection
- **Bash** (.sh) - POSIX-compatible, external command detection

### Tier 2: Basic Detection

- **Ruby** (.rb), **Perl** (.pl), **PHP** (.php), **PowerShell** (.ps1), **R** (.r), **Lua** (.lua)
- Extension-based detection only, manual dependency listing required

### Note on Compiled Languages

Compiled languages (Go, Rust, C/C++, Java) are **not recommended** due to:
- Platform-specific binaries
- Compilation requirements  
- Distribution complexity

If compiled tools are necessary:
- Use existing system binaries (document in compatibility)
- Use `go run pkg@version` for Go tools without pre-installation
- Provide script-based alternatives
- Consider containerization

### Script Design for Agentic Use

Scripts bundled in skills must be designed for non-interactive execution. Key requirements:

- **No interactive prompts** — agents cannot respond to TTY prompts; accept all input via flags, env vars, or stdin
- **`--help` output** — primary way agents learn the interface; include description, flags, and usage examples
- **Helpful error messages** — say what went wrong, what was expected, and what to try next
- **Structured output** — prefer JSON/CSV/TSV over free-form text; send data to stdout, diagnostics to stderr
- **Idempotency** — agents may retry; "create if not exists" is safer than "fail on duplicate"
- **`--dry-run` flag** — for destructive operations, let agents preview before acting
- **Meaningful exit codes** — use distinct codes for different failure types and document them in `--help`
- **Predictable output size** — default to summaries or reasonable limits; support `--offset` or `--output FILE` for large output

See [references/scripting-guide.md](references/scripting-guide.md) for full guidance and examples.

## Progressive Disclosure Design

Skills use three-level loading to manage context efficiently:

1. **Metadata** (name + description) - Always in context (~100 words)
2. **SKILL.md body** - When skill triggers (<500 lines preferred)
3. **Bundled resources** - As needed by AI Agent

**When SKILL.md approaches 500 lines:**
- Split content into references/ files
- Reference them clearly from SKILL.md
- Describe when to read each file

**Pattern for large skills:**

```markdown
# Large Skill

## Quick Start
[Essential workflow]

## Feature Categories

- **Feature A**: See [references/feature-a.md](references/feature-a.md)
- **Feature B**: See [references/feature-b.md](references/feature-b.md)
- **API Reference**: See [references/api.md](references/api.md)
```

## Scripts Quick Reference

| Script | Purpose | Run `--help` for full usage |
|---|---|---|
| `init_skill.py` | Initialize new skill directory with templates | `python scripts/init_skill.py --help` |
| `assess_compatibility.py` | Analyze skill for dependencies, output JSON report | `python scripts/assess_compatibility.py --help` |
| `quick_validate.py` | Validate SKILL.md structure; errors block packaging | `python scripts/quick_validate.py --help` |
| `package_skill.py` | Package skill into distributable .skill file | `python scripts/package_skill.py --help` |
| `detect_env.py` | Detect agent environment and headless command | *(see below)* |
| `aggregate_benchmark.py` | Aggregate grading results into benchmark.json | `python scripts/aggregate_benchmark.py --help` |

**Full usage details:** See [references/scripts-reference.md](references/scripts-reference.md)

### detect_env.py — Agent Environment Detection

Required before running evals. Run once to identify your agent and headless command:

```bash
python scripts/detect_env.py
```

| Agent | Env var / required value | `agent` field | Headless command |
|---|---|---|---|
| Claude Code | `CLAUDECODE` (any) | `claude-code` | `claude -p` |
| opencode | `OPENCODE` (any) | `opencode` | `opencode run` |
| Amp | `AGENT=amp` | `amp` | `amp -x` |
| Goose | `AGENT=goose` | `goose` | `goose run --text` |
| Codex CLI | `AGENT=codex` | `codex` | `codex exec` |

`CLAUDECODE` and `OPENCODE` match when set to any value. `AGENT` requires a specific value.
Use `headless_command` when building eval scripts. Check `subagent_support` before parallel runs.

## Getting Help

**For detailed workflows:** See [references/step-by-step-guide.md](references/step-by-step-guide.md)

**For compatibility assessment:** See [references/compatibility-guide.md](references/compatibility-guide.md)

**For scripting patterns:** See [references/scripting-guide.md](references/scripting-guide.md)

**For script CLI usage:** See [references/scripts-reference.md](references/scripts-reference.md)

**For workflow patterns:** See [references/workflows.md](references/workflows.md)

**For output patterns:** See [references/output-patterns.md](references/output-patterns.md)

**For eval workflow:** See [references/eval-guide.md](references/eval-guide.md)

**For eval schemas:** See [references/schemas.md](references/schemas.md)

**Common issues:**
- Validation errors → Check SKILL.md frontmatter format and required fields
- Compatibility warnings → Run assess_compatibility.py or manually review scripts/
- Python version error → Upgrade to Python 3.11+
- PyYAML missing → Install with `pip3 install PyYAML`
- Script hangs → Check for interactive prompts; all input must come from flags/env/stdin
- Skill not triggering → Check description covers the scenario; run evals to measure
