---
name: structured-claude-md
description: Create well-organized CLAUDE.md files with companion documentation for Claude Code projects. Use when (1) setting up CLAUDE.md for a new project, (2) refactoring large or unstructured CLAUDE.md files, (3) adding new workflow documentation, (4) improving Claude's effectiveness in a project, (5) creating project documentation standards, or (6) organizing project-specific guidance into a structured .claude/docs/ hierarchy.
---

# Structured CLAUDE.md Creation Guide

Create well-organized CLAUDE.md documentation ecosystems for Claude Code projects.

## Core Philosophy

CLAUDE.md is not a README for humans. It is an instruction set for Claude Code. Every line should help Claude perform tasks more effectively.

### Documentation Ecosystem

A Claude Code project's documentation consists of three components:

```
CLAUDE.md                 # Entry point: project identity + navigation
.claude/docs/             # Detailed reference and workflow documentation
.claude/skills/           # Reusable behavioral instructions (Skills)
```

Each component serves a distinct purpose. Do not conflate them.

### Guiding Principles

**Progressive Disclosure**: CLAUDE.md provides overview and navigation. Detailed information lives in `.claude/docs/`. Claude reads CLAUDE.md on every conversation start, but reads linked documents only when relevant tasks arise.

**Task-Oriented Navigation**: Organize documentation around tasks Claude will perform, not around project structure or technology categories.

**Actionable Content**: Every section should contain instructions Claude can act on. Avoid passive descriptions or background information that does not inform action.

**Appropriate Granularity**: Split documentation when content serves different tasks. Keep documentation together when it serves the same task. Do not split purely for line count reduction.

## CLAUDE.md Design

### Required Sections

**Project Summary**: 2-3 sentences describing what the project is and its core architectural principle. This gives Claude essential context for every interaction.

**Critical Rules**: The rules that, if violated, cause the most damage. These belong directly in CLAUDE.md because Claude reads it every time. Link to detailed rules document for elaboration.

**Quick Start**: Essential commands Claude needs to build, test, and deploy. Only include commands Claude will actually use.

**Task Navigation**: The most important section. Maps common tasks to the documentation files that contain detailed guidance. Use "When doing X → Read Y" format.

**Project Structure**: Brief directory overview showing where code lives. Focus on the organizational pattern, not exhaustive listing.

### Optional Sections

- **Development Tools**: Key tools and their roles (only if non-obvious)
- **Commit Convention**: If the project uses a specific format
- **Available Skills**: List skills Claude can invoke for specialized guidance

### What Does NOT Belong in CLAUDE.md

- Detailed step-by-step workflows (→ `.claude/docs/workflows/`)
- Complete architecture documentation (→ `.claude/docs/reference/`)
- Troubleshooting guides (→ `.claude/docs/troubleshooting.md`)
- Reusable behavioral rules or standards (→ `.claude/skills/`)
- Information that only applies to specific tasks

## `.claude/docs/` Organization

### Directory Structure

```
.claude/docs/
├── critical/              # Rules that MUST be followed always
│   └── rules.md
├── reference/             # Lookup information
│   ├── architecture.md    # Project architecture details
│   ├── commands.md        # Full command reference
│   └── [domain].md        # Domain-specific reference
├── workflows/             # Step-by-step task guides
│   ├── [task-name].md
│   └── [category]/        # Group related workflows
│       └── [subtask].md
└── troubleshooting.md     # Common errors and solutions
```

### Content Categorization

Determine where content belongs based on how Claude uses it:

| Usage Pattern | Location | Example |
|---|---|---|
| Must follow on every interaction | CLAUDE.md (Critical Rules) | "Never edit files in home directory directly" |
| Needed when performing a specific task | `.claude/docs/workflows/` | "How to add a new Nix module" |
| Needed for understanding context | `.claude/docs/reference/` | "Project architecture overview" |
| Must never be violated | `.claude/docs/critical/` | "Detailed security requirements" |
| Needed when debugging | `.claude/docs/troubleshooting.md` | "Common build errors" |
| Reusable behavioral standards | `.claude/skills/` | "Code quality standards" |

### When to Split Documentation

Split when:
- Content serves different tasks (a workflow doc and a reference doc)
- A section is only needed for specific scenarios (not every conversation)
- Subcategories within a workflow are independent (e.g., "adding programs" vs "adding services")

Keep together when:
- Content is always needed together for a single task
- Splitting would force Claude to read multiple files for one operation
- The content is short enough that splitting adds navigation overhead without benefit

## Skills vs Documentation

### When to Create a Skill

Skills (`.claude/skills/` or project-local) are appropriate for:

- **Reusable behavioral standards**: Code quality rules, writing standards, review checklists
- **Cross-project guidance**: Standards that apply beyond a single project
- **On-demand expertise**: Specialized knowledge invoked only when relevant
- **Workflow protocols**: Multi-step processes with specific rules (e.g., git operations, PR creation)

### When to Use `.claude/docs/` Instead

Documentation is appropriate for:

- **Project-specific context**: Architecture, directory structure, conventions unique to this project
- **Task instructions**: Step-by-step guides for project operations
- **Reference material**: Commands, path mappings, configuration details
- **Troubleshooting**: Project-specific error resolution

### Key Distinction

Skills define **how Claude should behave** (standards, rules, methods).
Documentation provides **project-specific knowledge** (what exists, where things are, how this project works).

### Creating Skills

Use the built-in `skill-creator` skill for creating new Skills. It provides comprehensive guidance on skill structure, frontmatter, and content design.

## Workflow

### Phase 1: Analysis

**For New Projects:**

1. Identify project type, primary language, and framework
2. List the tasks Claude will most commonly perform
3. Identify critical rules and constraints
4. Determine which standards could be reusable Skills

**For Existing Projects:**

1. Read current CLAUDE.md and `.claude/docs/` structure
2. Identify content that is misplaced (e.g., detailed workflows in CLAUDE.md)
3. Find gaps: what tasks lack documentation?
4. Check for content that should be a Skill instead of documentation

**Ask the User:**

Before creating documentation, confirm:
- What are the critical rules Claude must follow?
- What are the main tasks Claude will perform?
- Are there reusable standards that should be Skills?

### Phase 2: Design

1. Categorize all content into: critical rules, reference, workflows, troubleshooting, skills
2. Design the `.claude/docs/` directory structure
3. Plan CLAUDE.md sections and navigation links
4. Identify which Skills are needed (if any)

### Phase 3: Creation

1. Create `.claude/docs/` directory structure
2. Write detailed documents for each category
3. Write CLAUDE.md as the entry point with navigation
4. Create Skills if identified in Phase 2

### Phase 4: Verification

1. Verify all links in CLAUDE.md point to existing files
2. Check that every common task has a navigation entry
3. Confirm critical rules are visible in CLAUDE.md
4. Test discoverability: can Claude find the right document for each task?

## Writing Guidelines

### For Instructions

- Use imperative mood: "Run `nix build`" not "You should run `nix build`"
- Be specific: "Edit `modules/home-manager/programs/zsh/default.nix`" not "Edit the Zsh config"
- Provide the exact command or file path Claude needs

### For Rules

- State what is prohibited and what is required
- Explain why briefly (Claude follows rules better when it understands the reason)
- Provide the correct alternative for each prohibition

### For Navigation

Use consistent task-based format:

```markdown
### [Task Category]
**Task**: [When this applies]

→ Read: `.claude/docs/workflows/[file].md`
```

### For Reference Material

- Use tables for mappings and lookups
- Include concrete examples
- Keep structure scannable

## Refactoring Existing Documentation

### Assessment

1. **Misplacement**: Is detailed content in CLAUDE.md that belongs in `.claude/docs/`?
2. **Gaps**: Are there tasks Claude performs without documented guidance?
3. **Redundancy**: Is the same information in multiple places?
4. **Discoverability**: Can Claude find the right document via CLAUDE.md navigation?
5. **Skill Candidates**: Is there behavioral guidance that should be a reusable Skill?

### Process

1. Inventory all existing content
2. Categorize each piece: critical rules, reference, workflow, troubleshooting, skill
3. Move content to appropriate locations
4. Rewrite CLAUDE.md as navigation entry point
5. Extract reusable standards into Skills
6. Verify all links and navigation paths
