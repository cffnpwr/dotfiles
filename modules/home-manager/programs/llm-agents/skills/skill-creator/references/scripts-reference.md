# Scripts Reference

Full usage reference for all scripts bundled with skill-creator.

## init_skill.py

Initialize new skill with template structure.

**Usage:**
```bash
python scripts/init_skill.py <skill-name> --path <output-directory>
```

**What it creates:**
- Skill directory with SKILL.md (includes compatibility template)
- scripts/, references/, assets/ directories with examples
- Example files demonstrating each resource type

---

## assess_compatibility.py

Analyze skill directory for dependencies, output JSON report.

**Usage:**
```bash
python scripts/assess_compatibility.py <skill-directory>
```

**Output:**
- Detected languages and versions
- External dependencies (packages, tools)
- Suggested compatibility declaration
- Confidence level and warnings

**Supports:** Python, Node.js, Bash analysis; other languages via extension detection

---

## quick_validate.py

Validate SKILL.md structure and compatibility declarations.

**Usage:**
```bash
python scripts/quick_validate.py <skill-directory>
```

**Validates:**
- YAML frontmatter format
- Required fields presence (name, description, compatibility)
- Field constraints (naming, length, format)
- Script-dependency consistency
- Environment check instructions presence

**Errors block packaging. Warnings should be addressed for quality.**

---

## package_skill.py

Package skill into distributable .skill file.

**Usage:**
```bash
python scripts/package_skill.py <skill-directory> [output-directory]
```

**Process:**
1. Runs validation automatically
2. Creates ZIP archive with .skill extension
3. Maintains directory structure
4. Excludes `evals/` directory (development artifact, not distributed)
5. Only succeeds if validation passes

---

## detect_env.py

Detect the current coding agent environment and headless command.

**Usage:**
```bash
python scripts/detect_env.py
```

**Output:**
```json
{
  "agent": "opencode",
  "headless_command": "opencode run",
  "env_var": "OPENCODE",
  "subagent_support": true,
  "browser_support": false
}
```

**Supported agents:**

| Agent | Env var / required value | `agent` field | Headless command | subagent_support |
|---|---|---|---|---|
| Claude Code | `CLAUDECODE` (any) | `claude-code` | `claude -p` | true |
| opencode | `OPENCODE` (any) | `opencode` | `opencode run` | true |
| Amp | `AGENT=amp` | `amp` | `amp -x` | true |
| Goose | `AGENT=goose` | `goose` | `goose run --text` | false |
| Codex CLI | `AGENT=codex` | `codex` | `codex exec` | false |

`CLAUDECODE` and `OPENCODE` match when set to any value. `AGENT` requires a specific value.
Use `headless_command` when building eval scripts that invoke the agent programmatically.
Check `subagent_support` before launching parallel SubAgent eval runs.

---

## aggregate_benchmark.py

Aggregate grading results from a single eval run into `benchmark.json`.

**Usage:**
```bash
python scripts/aggregate_benchmark.py <run-directory> [options]

Options:
  --run-type {with_skill,without_skill}  Whether the skill was loaded (default: with_skill)
  --skill SKILL                          Skill name (inferred from SKILL.md if omitted)
  --version VERSION                      Skill version (default: 0.0.0)
  --description DESC                     Snapshot of the description used in this run
  --output PATH                          Output path (default: <run-dir>/benchmark.json)
```

Reads all `grading.json` files under the run directory and writes `benchmark.json`
to the run directory root.
