# Structured CLAUDE.md

Create well-organized CLAUDE.md files with companion documentation for Claude Code projects.

## Overview

This skill provides a complete workflow for creating structured CLAUDE.md documentation:

- **Main CLAUDE.md**: Concise entry point with navigation
- **`.claude/docs/`**: Detailed documentation split by concern
- **Supports**: New project creation AND existing project refactoring

## Workflow

### Phase 1: Analysis

**For New Projects:**

1. Identify project type (library, application, framework, etc.)
2. Determine primary language and framework
3. List key workflows users will perform
4. Identify critical rules or constraints

**For Existing Projects:**

1. Read current CLAUDE.md (if exists)
2. Analyze codebase structure
3. Identify undocumented conventions
4. List pain points or missing guidance

**Questions to Ask User:**

```
Before creating documentation, I need to understand your project:

1. What is the primary purpose of this project?
2. What are the critical rules Claude must follow? (e.g., "never edit X directly")
3. What are the main workflows? (e.g., "add feature", "fix bug", "deploy")
4. Any specific tools or commands Claude should use?
```

### Phase 2: Design

**Determine Documentation Structure:**

```
CLAUDE.md                          # Entry point (keep SHORT)
.claude/
├── docs/
│   ├── critical/                  # Non-negotiable rules
│   │   └── rules.md
│   ├── reference/                 # Lookup information
│   │   ├── architecture.md
│   │   ├── commands.md
│   │   └── [domain-specific].md
│   ├── workflows/                 # Step-by-step guides
│   │   ├── [workflow-1].md
│   │   ├── [workflow-2].md
│   │   └── [category]/
│   │       └── [sub-workflow].md
│   └── troubleshooting.md         # Common issues
└── rules/                         # Auto-loaded rules (optional)
    └── [context].md
```

**Section Assignment Guidelines:**

| Content Type | Location |
|---|---|
| Project summary | CLAUDE.md |
| Critical rules (MUST follow) | `.claude/docs/critical/rules.md` |
| Architecture overview | `.claude/docs/reference/architecture.md` |
| Command reference | `.claude/docs/reference/commands.md` |
| Step-by-step workflows | `.claude/docs/workflows/` |
| Common errors and fixes | `.claude/docs/troubleshooting.md` |

### Phase 3: Creation

**Step 1: Create Main CLAUDE.md**

Use the template in the Templates section below. Keep it SHORT:
- Project summary (2-3 sentences)
- Critical rules summary (link to full rules)
- Quick start section
- Task navigation with links to `.claude/docs/`
- Brief structure overview

**Step 2: Create `.claude/docs/` Structure**

Create directories and files based on design phase.

**Step 3: Write Content**

For each document:
1. Start with clear heading and purpose
2. Use consistent formatting
3. Include examples where helpful
4. Cross-reference related documents

**Step 4: Verify Navigation**

Ensure all links in CLAUDE.md point to existing files.

## Templates

### Main CLAUDE.md Template

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Summary

[2-3 sentence description of the project]

**Tech Stack:** [Primary technologies]

## Critical Rules

[Brief summary of most important rules - 3-5 bullet points max]

**Full critical rules**: `.claude/docs/critical/rules.md`

## Quick Start

[Essential commands to get started]

```bash
# Example commands
[command 1]
[command 2]
```

**Full command reference**: `.claude/docs/reference/commands.md`

## Task Navigation

### [Task Category 1]
**Task**: [Description of when to use]

→ Read: `.claude/docs/workflows/[workflow].md`

### [Task Category 2]
**Task**: [Description of when to use]

→ Read: `.claude/docs/workflows/[workflow].md`

### Troubleshooting
**Task**: Debug errors, fix issues

→ Read: `.claude/docs/troubleshooting.md`

## Project Structure

```
[Brief directory tree showing key locations]
```

**Full architecture**: `.claude/docs/reference/architecture.md`
```

### Critical Rules Template

```markdown
# Critical Rules

Rules that MUST be followed in all circumstances.

## Absolute Requirements

### Rule 1: [Rule Name]

**NEVER:** [What is prohibited]
**ALWAYS:** [What is required]

**Why:** [Brief explanation]

### Rule 2: [Rule Name]

...

## Common Violations to Avoid

1. [Violation description] → [Correct approach]
2. [Violation description] → [Correct approach]
```

### Workflow Template

```markdown
# [Workflow Name]

## When to Use

Use this workflow when:
- [Condition 1]
- [Condition 2]

## Prerequisites

- [Prerequisite 1]
- [Prerequisite 2]

## Step-by-Step Process

### Step 1: [Step Name]

[Description]

```bash
# Commands if applicable
```

### Step 2: [Step Name]

...

## Common Issues

**Issue:** [Description]
**Solution:** [How to fix]

## Related Workflows

- [Link to related workflow 1]
- [Link to related workflow 2]
```

### Architecture Reference Template

```markdown
# Architecture Reference

## Project Overview

[Description of project architecture]

**Key Technologies:**
- **[Tech 1]**: [Purpose]
- **[Tech 2]**: [Purpose]

## Directory Structure

```
[Full directory tree with annotations]
```

## [Component/Module] System

### [Subsystem 1]

[Description]

### [Subsystem 2]

[Description]

## Data Flow

[Description of how data moves through the system]

## Best Practices

### Do
- [Best practice 1]
- [Best practice 2]

### Don't
- [Anti-pattern 1]
- [Anti-pattern 2]
```

### Troubleshooting Template

```markdown
# Troubleshooting

## Common Errors

### Error: [Error Message or Type]

**Cause:** [Why this happens]

**Solution:**
```bash
# Fix command
```

**Prevention:** [How to avoid in future]

---

### Error: [Error Message or Type]

...

## Debug Checklist

When encountering issues:

1. [ ] [Check item 1]
2. [ ] [Check item 2]
3. [ ] [Check item 3]

## Getting Help

[How to escalate or get additional help]
```

## Best Practices

### CLAUDE.md Design Principles

**DO:**
- Keep main CLAUDE.md SHORT (fits in one screen)
- Use task-based navigation ("When doing X, read Y")
- Link to detailed docs instead of embedding
- Update docs when workflows change
- Include examples in workflow docs

**DON'T:**
- Put all content in single CLAUDE.md
- Duplicate information across files
- Use vague section titles
- Assume Claude knows project context
- Forget to update links when restructuring

### Writing Style

**For Instructions:**
- Use imperative mood ("Run command" not "You should run")
- Be specific ("Edit `src/config.ts`" not "Edit the config")
- Include concrete examples

**For Rules:**
- Use NEVER/ALWAYS for absolute rules
- Explain the "why" briefly
- Provide correct alternative for each prohibition

### Content Organization

**Principle: Progressive Disclosure**

```
Level 1: CLAUDE.md
         → What is this project?
         → What are the critical rules?
         → Where do I find detailed info?

Level 2: docs/workflows/, docs/reference/
         → Step-by-step guides
         → Detailed reference information

Level 3: Inline code comments
         → Implementation-specific notes
```

## Refactoring Existing CLAUDE.md

### Assessment Checklist

1. **Length Check**: Is CLAUDE.md > 200 lines? → Needs splitting
2. **Navigation Check**: Can Claude find info for specific tasks? → Needs structure
3. **Duplicate Check**: Is information repeated? → Needs consolidation
4. **Currency Check**: Is information outdated? → Needs update

### Refactoring Steps

1. **Inventory** current content sections
2. **Categorize** into: critical rules, reference, workflows, troubleshooting
3. **Extract** each category to appropriate `.claude/docs/` file
4. **Condense** CLAUDE.md to summary + navigation
5. **Verify** all links work
6. **Test** by asking Claude to perform common tasks

### Migration Pattern

**Before (monolithic):**
```markdown
# CLAUDE.md
[500 lines of mixed content]
```

**After (structured):**
```markdown
# CLAUDE.md
[50 lines: summary + navigation]

.claude/docs/
├── critical/rules.md      [50 lines]
├── reference/
│   ├── architecture.md    [100 lines]
│   └── commands.md        [80 lines]
├── workflows/
│   ├── feature.md         [60 lines]
│   └── bugfix.md          [40 lines]
└── troubleshooting.md     [70 lines]
```

## When to Use This Skill

- Setting up CLAUDE.md for a new project
- Refactoring large/unstructured CLAUDE.md
- Adding new workflow documentation
- Improving Claude's effectiveness in a project
- Creating project documentation standards

## Example Invocation

```
User: "Help me create a structured CLAUDE.md for this project"