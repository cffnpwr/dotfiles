# Step-by-Step Skill Creation Guide

Complete workflow for creating Agent Skills from conception to distribution.

## Process Overview

1. Understanding the Skill with Concrete Examples
2. Planning Reusable Skill Contents
3. Assessing Compatibility Requirements (NEW in improved-skill-creator)
4. Initializing the Skill
5. Editing the Skill
6. Validating the Skill
7. SubAgent Review (Recommended, NEW)
8. Packaging the Skill
9. Iteration

## Step 1: Understanding the Skill with Concrete Examples

**Goal:** Clearly understand how the skill will be used through concrete examples.

**When to skip:** Only skip if usage patterns are already crystal clear.

### Approach

Gather or generate concrete examples of skill usage:

**If working with a user:**
- "What functionality should this skill support?"
- "Can you give specific examples of how this would be used?"
- "What would a user say that should trigger this skill?"
- "Are there edge cases or variations to consider?"

**If creating independently:**
- Generate realistic usage scenarios
- Imagine different user intents and phrasings
- Consider variations in complexity and context
- Document example inputs and expected outputs

### Example: Image Editor Skill

**Questions to answer:**
- Functionality: Editing, rotating, resizing, filtering, format conversion
- Usage examples:
  - "Remove red-eye from this photo"
  - "Rotate image 90 degrees clockwise"
  - "Convert PNG to JPEG"
  - "Apply sepia filter"
- Triggers: "edit image", "modify photo", "rotate picture", "convert image format"

### Avoid

- Asking too many questions at once (overwhelming)
- Being vague about functionality
- Skipping edge case consideration
- Not documenting the examples

### Completion Criteria

You have clear understanding of:
- What the skill does
- How users will invoke it
- What variations exist
- What outputs are expected

## Step 2: Planning Reusable Skill Contents

**Goal:** Identify what scripts, references, and assets would make this skill reusable and efficient.

### Analysis Process

For each concrete example from Step 1:

1. **Consider from-scratch implementation** - How would you execute this without the skill?
2. **Identify repetition** - What code/data would be rewritten each time?
3. **Identify fragility** - What operations are error-prone or require exact execution?
4. **Identify bulk content** - What information is too large for SKILL.md?

### Decision Framework

**Use a one-off command (no scripts/ directory) when:**
- An existing package already does what you need
- `uvx tool@version`, `npx tool@version`, `go run pkg@version`, etc. run it directly
- The command is simple enough to get right on the first try
- Pin the version in the command itself (e.g., `npx eslint@9.0.0`)

**Create a script when:**
- Same code pattern appears in multiple examples
- Operation requires deterministic, error-free execution
- Complex algorithm or data processing
- External tool integration with specific flags/options
- Command would be hard to get right without a tested, bundled script

**Design scripts for agentic execution:**
- No interactive prompts (agents operate in non-interactive shells)
- Accept input via flags, env vars, or stdin
- Implement `--help` output with usage examples
- Use structured output (JSON/CSV) to stdout; diagnostics to stderr
- Support `--dry-run` for destructive operations
- Use meaningful exit codes and document them
- Make operations idempotent (agents may retry)

**Create a reference file when:**
- API documentation or schema information
- Comprehensive workflow guides
- Domain knowledge or policies
- Examples and patterns library
- Content too detailed for SKILL.md

**Create an asset when:**
- Templates that get copied or customized
- Images, icons, fonts
- Boilerplate code or project structures
- Sample data files

### Example: PDF Editor Skill

**Analysis:**

"Rotate this PDF 90 degrees":
- From scratch: Would write Python code each time with PyPDF2
- Repetition: PDF rotation code pattern
- Decision: Create `scripts/rotate_pdf.py`

"Fill out this PDF form":
- From scratch: Would discover field names, then write fill code
- Repetition: Form filling logic
- Bulk content: Common field name mappings
- Decision: Create `scripts/fill_form.py` and `references/common-fields.md`

"Merge multiple PDFs":
- From scratch: Would write merge logic with PyPDF2
- Repetition: Merge code pattern
- Decision: Create `scripts/merge_pdfs.py`

**Result:**
```
pdf-editor/
├── scripts/
│   ├── rotate_pdf.py
│   ├── fill_form.py
│   └── merge_pdfs.py
└── references/
    └── common-fields.md
```

### Avoid

- Over-engineering (don't create scripts for one-time operations)
- Under-engineering (don't force AI Agent to rewrite same code repeatedly)
- Duplication (information in both SKILL.md and references/)
- Missing assets (templates should be included, not recreated)

### Completion Criteria

You have a clear list of:
- Scripts to create (with language choice)
- Reference files to include (with content outline)
- Assets to bundle (with source identification)

## Step 3: Assessing Compatibility Requirements (NEW)

**Goal:** Determine and document all environment dependencies.

This is a NEW step in improved-skill-creator. Official skill-creator makes compatibility optional; we make it mandatory.

### Why This Matters

Without explicit compatibility:
- AI Agents can't check prerequisites before execution
- Users encounter cryptic errors when dependencies are missing
- Support burden increases
- Skill adoption decreases

### Three Assessment Methods

Choose based on your workflow and available tools:

#### Method A: Automated Script (Recommended)

```bash
python scripts/assess_compatibility.py <skill-directory>
```

Review JSON output and use suggested compatibility text.

**Pros:** Fast, consistent, catches obvious dependencies  
**Cons:** May miss dynamic imports, subprocess-invoked tools  
**Best for:** Python/Node.js/Bash skills with straightforward dependencies

#### Method B: SubAgent Delegation

Use SubAgent to analyze scripts and generate compatibility declaration.

**Prompt template in:** [compatibility-guide.md](compatibility-guide.md#method-2-subagent-delegation)

**Pros:** Thorough, catches complex patterns, provides reasoning  
**Cons:** Requires SubAgent capability, slower  
**Best for:** Complex multi-language skills, when thoroughness matters

#### Method C: Manual Checklist

Follow manual assessment guide in [compatibility-guide.md](compatibility-guide.md#method-3-manual-assessment).

**Pros:** Works without tools, educational  
**Cons:** Time-consuming, error-prone  
**Best for:** Simple skills, learning workflow, no automation available

### Decision Tree

```
Do you have scripts/ directory?
├─ No → "No external dependencies. Works in all environments."
│
└─ Yes
   │
   Is it primarily Python/Node.js/Bash?
   ├─ Yes → Use Method A (assess_compatibility.py)
   │         If warnings appear → Consider Method B (SubAgent) for verification
   │
   └─ No/Mixed languages
      │
      SubAgent available?
      ├─ Yes → Use Method B (SubAgent)
      │
      └─ No → Use Method C (Manual)
```

### What to Document

Your compatibility declaration should include:

1. **Required languages with versions:**
   - Python 3.11+
   - Node.js 22+
   - Bash (usually no version)

2. **External packages:**
   - Python: PyYAML, requests, pandas
   - Node.js: express, axios
   - Bash: git, docker, jq

3. **External tools:**
   - LibreOffice, ImageMagick, ffmpeg, etc.

4. **Platform notes (if applicable):**
   - "Linux or macOS (Windows via WSL)"
   - "Requires X Window System"

**OR clearly state:**

```yaml
compatibility: |
  No external dependencies. Works in all environments with standard AI Agent tools.
```

### Completion Criteria

- Compatibility field drafted
- All script languages identified
- External dependencies enumerated
- OR "no dependencies" explicitly stated
- Environment check instructions planned

## Step 4: Initializing the Skill

**Goal:** Create skill directory structure with templates.

### When to Skip

Only skip if the skill directory already exists and you're iterating.

### Command

```bash
python scripts/init_skill.py <skill-name> --path <output-directory>
```

**Skill name requirements:**
- Kebab-case (lowercase, hyphens)
- Max 64 characters
- No leading/trailing hyphens
- No consecutive hyphens

### What Gets Created

```
<skill-name>/
├── SKILL.md                      # With compatibility template
├── scripts/
│   └── example.py               # Placeholder (delete if unneeded)
├── references/
│   └── api_reference.md         # Placeholder (delete if unneeded)
└── assets/
    └── example_asset.txt        # Placeholder (delete if unneeded)
```

### Immediate Actions

1. **Review SKILL.md template** - Note the TODO sections
2. **Delete unneeded placeholders** - Remove example files you won't use
3. **Create planned resources** - Add scripts, references, assets from Step 2

### Completion Criteria

- Skill directory exists
- SKILL.md template is in place
- Resource directories match your Step 2 plan
- Placeholder files removed or replaced

## Step 5: Editing the Skill

**Goal:** Implement skill functionality and documentation.

### 5.1 Implement Reusable Resources First

Start with scripts, references, and assets (from Step 2).

**For scripts:**
1. Implement functionality
2. Add shebang line (`#!/usr/bin/env python3`)
3. Add docstring explaining purpose and usage
4. Implement `--help` output (how agents learn your script's interface)
5. Ensure no interactive prompts — all input via flags, env vars, or stdin
6. Use structured output (JSON/CSV) to stdout; diagnostics to stderr
7. Add `--dry-run` for destructive operations
8. Use meaningful exit codes; document them in `--help`
9. Test by running directly
10. Make executable: `chmod +x scripts/script.py`

**Self-contained scripts (no separate install step):**
- Python: Use PEP 723 inline metadata, run with `uv run scripts/extract.py`
- Deno: Use `npm:` or `jsr:` import specifiers, run with `deno run scripts/extract.ts`
- Bun: Version-pinned imports auto-install at runtime, run with `bun run scripts/extract.ts`
- Ruby: Use `bundler/inline` gemfile block, run with `ruby scripts/extract.rb`

**For references:**
1. Write comprehensive documentation
2. Add table of contents if >100 lines
3. Include examples and code samples
4. Structure for easy grep if >10k words

**For assets:**
1. Copy/create template files
2. Ensure files are in final usable form
3. Document any customization needed

**Testing requirement:** Test representative scripts to ensure they work. Not every script needs testing if patterns are identical, but verify core functionality.

### 5.2 Update SKILL.md Frontmatter

**name:** Should match directory name (already set by init_skill.py)

**description:** Update the TODO with comprehensive description:
- What the skill does (functionality)
- When to use it (triggers and contexts)
- Key capabilities or features
- Target: 50-500 characters, be thorough
- Include ALL triggering scenarios

**Example:**
```yaml
description: |
  Comprehensive PDF document processing with rotation, merging, splitting, form filling,
  and text extraction. Use when working with PDF files for: (1) rotating pages, 
  (2) combining multiple PDFs, (3) extracting pages or content, (4) filling form fields,
  (5) extracting text for analysis. Triggers on "PDF", "rotate", "merge", "extract", "form".
```

**compatibility:** Replace TODO with your Step 3 assessment:

```yaml
compatibility: |
  Required: Python 3.11+, PyPDF2, pdfplumber
  Optional: Tesseract OCR (for scanned document text extraction)
```

### 5.3 Write SKILL.md Body

**Essential sections:**

1. **Overview** (1-2 sentences) - What this skill enables

2. **Environment Requirements** - If dependencies exist:
   - Check commands for each dependency
   - Installation instructions
   - Error messages to show users

3. **Main Content** - Choose structure:
   - Workflow-based (sequential processes)
   - Task-based (operation categories)
   - Reference/Guidelines (standards)
   - Capabilities-based (feature list)

4. **Resources** (optional) - Document bundled scripts/references/assets

**Keep SKILL.md under 500 lines:**
- Move detailed content to references/
- Link to references clearly
- Explain when to read each reference

**Writing style:**
- Imperative form ("Run the script", not "You should run")
- Concise and actionable
- Examples over explanations
- Code samples with comments

### 5.4 Add Environment Check Instructions

If you have dependencies, add this section after Overview:

```markdown
## Environment Requirements

Check Python and packages:

```bash
python3 --version  # Should be 3.11+
pip3 show PyPDF2 pdfplumber
```

If dependencies are missing:

> "This skill requires Python 3.11+ and packages: PyPDF2, pdfplumber"
> "Install with: pip3 install PyPDF2 pdfplumber"
```

Make it copy-pasteable and clear.

### Completion Criteria

- All planned resources implemented
- SKILL.md frontmatter complete (no TODOs)
- SKILL.md body written (<500 lines)
- Environment check instructions present (if dependencies exist)
- Examples and code samples included
- References linked clearly

## Step 6: Validating the Skill

**Goal:** Ensure skill meets all requirements before packaging.

### Command

```bash
python scripts/quick_validate.py <skill-directory>
```

### What Gets Validated

**Errors (block packaging):**
- SKILL.md exists
- Valid YAML frontmatter format
- Required fields present: name, description, compatibility
- Name format: kebab-case, max 64 chars
- Description format: no angle brackets, max 1024 chars
- Compatibility format: non-empty, max 500 chars
- No unexpected frontmatter fields

**Warnings (should address):**
- Description too short (<50 chars)
- Scripts present but language not mentioned in compatibility
- Dependencies declared but no environment check instructions
- Compatibility contains TODO placeholder

### Fixing Validation Errors

**"Missing required 'compatibility' field":**
- Action: Add compatibility field to frontmatter
- See: Step 3 or [compatibility-guide.md](compatibility-guide.md)

**"'name' should be kebab-case":**
- Action: Rename directory and update name field to use lowercase and hyphens only

**"'compatibility' field contains TODO":**
- Action: Complete compatibility assessment (Step 3)

**"Found Python files but compatibility doesn't mention Python":**
- Action: Add "Python 3.11+" to compatibility field
- Verify with assess_compatibility.py

**"No environment check instructions found":**
- Action: Add Environment Requirements section to SKILL.md body

### Completion Criteria

- Validation passes without errors
- All warnings addressed or consciously accepted
- Ready for packaging

## Step 7: SubAgent Review (Recommended, NEW)

**Goal:** Automated review of compatibility accuracy and completeness.

This is a NEW step in improved-skill-creator for additional quality assurance.

### When to Use

- After validation passes
- Before packaging
- When uncertain about dependency completeness
- For complex multi-language skills

### Review Task 1: Compatibility Validation

**Task:**
```
Review compatibility field accuracy for skill at [path].

Checks to perform:
1. Verify all scripts in scripts/ have corresponding dependency declarations
2. For Python scripts:
   - Extract all import statements: grep -h "^import\|^from" scripts/*.py
   - Categorize as stdlib vs external packages
   - Compare with compatibility field
   - Flag any missing external packages
3. For Node.js scripts:
   - Extract require/import statements
   - Categorize as built-ins vs npm packages
   - Compare with compatibility field
4. For Bash scripts:
   - Check for external command usage
   - Verify tools are listed in compatibility
5. Check SKILL.md for environment check instructions
6. Verify compatibility declaration format and completeness

Report format:
- Missing dependencies: [list]
- Extra/unnecessary declarations: [list]
- Environment check instructions: [present/missing/incomplete]
- Overall assessment: [pass/fail with specific reasons]
- Recommendations: [improvement suggestions]
```

### Review Task 2: General Quality (Optional)

**Task:**
```
Perform quality review of skill at [path].

Review areas:
1. SKILL.md clarity and completeness
2. Proper use of progressive disclosure (references/ organization)
3. Example quality and relevance
4. Documentation consistency
5. Code quality in scripts (if applicable)

Report findings with specific suggestions for improvement.
```

### Acting on Review Results

1. **Address missing dependencies** immediately (correctness issue)
2. **Consider extra declarations** (may be false positives)
3. **Improve environment check** if incomplete
4. **Iterate on quality issues** as time permits

### Completion Criteria

- SubAgent review completed (or consciously skipped)
- Critical issues addressed
- Skill quality improved based on feedback

## Step 8: Packaging the Skill

**Goal:** Create distributable .skill file.

### Command

```bash
python scripts/package_skill.py <skill-directory> [output-directory]
```

**Output:** `<skill-name>.skill` file (ZIP with .skill extension)

### Process

1. **Automatic validation** - Runs quick_validate.py first
2. **If validation fails** - Packaging aborts with error messages
3. **If validation passes** - Creates .skill file
4. **Output location** - Current directory or specified output directory

### What Gets Packaged

Everything in skill directory:
- SKILL.md
- scripts/ and all contents
- references/ and all contents
- assets/ and all contents
- Directory structure maintained

### Distribution

The .skill file can be:
- Shared directly with users
- Posted to skill repositories
- Distributed via package managers
- Imported into AI Agent systems

### Completion Criteria

- .skill file created successfully
- File is distributable and self-contained
- Ready for testing or deployment

## Step 9: Iteration

**Goal:** Improve skill based on real-world usage.

### When to Iterate

- After using the skill on real tasks
- When users report issues or confusion
- When dependencies change (package updates, language versions)
- When new functionality is needed

### Iteration Workflow

1. **Use the skill** on actual tasks
2. **Notice struggles** - Where does the AI Agent or user get stuck?
3. **Identify improvements** - SKILL.md clarity? Missing scripts? Bad examples?
4. **Implement changes**
5. **Re-validate** and **re-package**
6. **Test** with the changes

### Common Iteration Triggers

**"AI Agent keeps asking for clarification":**
- SKILL.md examples may be too vague
- Add more concrete examples
- Clarify decision points

**"Scripts frequently need patching":**
- Consider adding parameters to scripts
- Document common variations in references/
- Add script usage examples

**"Skill is slow (high token usage)":**
- SKILL.md may be too verbose
- Move details to references/
- Improve progressive disclosure

**"Users can't install dependencies":**
- Environment check instructions may be unclear
- Add platform-specific guidance
- Include troubleshooting section

### Completion Criteria

Skill works reliably in production:
- AI Agents use it successfully
- Users can install dependencies
- Error rates are low
- Documentation is clear

## Summary Checklist

Before considering a skill complete:

**Step 1-2: Planning**
- [ ] Concrete usage examples documented
- [ ] Scripts/references/assets planned

**Step 3: Compatibility**
- [ ] Assessment method chosen and executed
- [ ] Compatibility field drafted
- [ ] Environment check instructions planned

**Step 4-5: Implementation**
- [ ] Skill initialized with init_skill.py
- [ ] Resources implemented and tested
- [ ] SKILL.md frontmatter complete
- [ ] SKILL.md body written (<500 lines)
- [ ] Environment check instructions added

**Step 6-7: Validation**
- [ ] quick_validate.py passes without errors
- [ ] Warnings addressed
- [ ] SubAgent review completed (or skipped)
- [ ] Critical issues resolved

**Step 8: Packaging**
- [ ] package_skill.py succeeds
- [ ] .skill file created
- [ ] Ready for distribution

**Step 9: Iteration**
- [ ] Tested on real tasks
- [ ] Issues noted for future iteration

**You have a production-ready skill!**
