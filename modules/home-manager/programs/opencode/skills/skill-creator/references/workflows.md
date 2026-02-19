# Workflow Patterns for Skills

Guidance for implementing sequential and conditional workflows in skills.

## When to Use Workflow Patterns

Use workflow patterns when:
- Task involves multiple sequential steps
- Different paths exist based on conditions
- Decision points require user input or context
- Process has clear start and end states

## Sequential Workflows

For processes that follow a linear sequence of steps.

### Pattern: Step-by-Step Process

```markdown
## Workflow

### Step 1: [Action]
[Instructions for first step]

### Step 2: [Action]
[Instructions for second step]
[Dependencies on Step 1 output]

### Step 3: [Action]
[Instructions using results from Steps 1-2]
```

**Example - Document Processing:**
```markdown
## Document Processing Workflow

### Step 1: Read Document
Use scripts/read_document.py to extract content and metadata.

### Step 2: Analyze Structure
Identify sections, headings, and key elements from extracted content.

### Step 3: Transform Content
Apply transformations based on analysis results.

### Step 4: Write Output
Generate final document using scripts/write_document.py.
```

## Conditional Workflows

For processes with branches based on conditions or user intent.

### Pattern: Decision Tree

```markdown
## Workflow Decision Tree

**Determine user intent:**

1. **If creating new [item]** → See [Create Workflow](#create-workflow)
2. **If modifying existing [item]** → See [Modify Workflow](#modify-workflow)
3. **If analyzing [item]** → See [Analysis Workflow](#analysis-workflow)

### Create Workflow
[Steps for creation]

### Modify Workflow
[Steps for modification]

### Analysis Workflow
[Steps for analysis]
```

**Example - File Operations:**
```markdown
## File Operation Decision Tree

**Determine operation type:**

1. **If creating file** → See [File Creation](#file-creation)
2. **If reading file** → See [File Reading](#file-reading)
3. **If updating file** → See [File Update](#file-update)
4. **If deleting file** → Confirm intent, then use system delete

### File Creation
1. Determine format from user intent
2. Generate content structure
3. Write to file using scripts/write_file.py

### File Reading
1. Check file exists and is accessible
2. Read using scripts/read_file.py
3. Parse based on format

### File Update
1. Read existing content (see File Reading)
2. Apply modifications
3. Write back (see File Creation)
```

## Hybrid Workflows

Combining sequential and conditional patterns.

### Pattern: Sequential with Conditional Steps

```markdown
## Workflow

### Step 1: [Always Required]
[Instructions]

### Step 2: [Conditional]
**If condition A:**
- [Actions for A]

**If condition B:**
- [Actions for B]

**Otherwise:**
- [Default actions]

### Step 3: [Always Required]
[Instructions using Step 2 results]
```

**Example - Data Processing:**
```markdown
## Data Processing Workflow

### Step 1: Load Data
Use scripts/load_data.py with file path.

### Step 2: Determine Processing Type
**If data is CSV:**
- Parse with CSV library
- Handle quoted fields

**If data is JSON:**
- Parse with JSON library
- Validate schema

**If data is XML:**
- Parse with XML library
- Extract namespaces

### Step 3: Transform Data
Apply transformations using parsed data structure from Step 2.

### Step 4: Output Results
Format and output using scripts/output_data.py.
```

## Iterative Workflows

For processes that repeat until a condition is met.

### Pattern: Loop Until Complete

```markdown
## Iterative Workflow

1. Initialize state
2. **Repeat until [condition]:**
   - Perform operation
   - Check result
   - Update state
3. Finalize and output
```

**Example - Batch Processing:**
```markdown
## Batch Processing Workflow

### Setup
1. Get list of input files
2. Initialize results collection

### Processing Loop
**For each file:**
1. Load file using scripts/load_file.py
2. Process content
3. Collect results
4. Update progress

### Finalization
1. Aggregate all results
2. Generate summary report
3. Output combined results
```

## Error Handling in Workflows

Incorporate error handling at decision points.

### Pattern: Try-Fallback

```markdown
### Step N: [Operation]

**Primary approach:**
1. Attempt [operation] using [method A]

**If [operation] fails:**
2. Fall back to [method B]

**If still failing:**
3. Inform user: "[Error message with guidance]"
```

**Example:**
```markdown
### Step 2: Parse Document

**Primary approach:**
1. Attempt parsing with scripts/parse_document.py

**If parsing fails (corrupted file):**
2. Try recovery mode: scripts/parse_document.py --recovery

**If still failing:**
3. Inform user:
   > "Document appears corrupted and cannot be parsed. Please verify file integrity."
```

## Workflow with Script Integration

Combining instructions with deterministic scripts.

### Pattern: Instruction + Script Execution

```markdown
### Step N: [Task]

**AI Agent actions:**
1. [Analysis or decision-making]
2. [Parameter determination]

**Script execution:**
```bash
python scripts/[script].py --param [value]
```

**Post-execution:**
3. [Interpret results]
4. [Next actions based on results]
```

**Example:**
```markdown
### Step 2: Extract Text

**Preparation:**
1. Analyze document type (PDF, DOCX, image)
2. Determine best extraction method

**Execute extraction:**
```bash
python scripts/extract_text.py --input [file] --method [method]
```

**Process results:**
3. Clean extracted text (remove artifacts)
4. Structure into paragraphs
5. Return formatted text
```

## Compatibility Considerations in Workflows

When workflows depend on external tools, check environment first.

### Pattern: Environment-Aware Workflow

```markdown
## Workflow

### Prerequisites Check

```bash
python3 --version  # Check Python
pip3 show required-package
```

If missing:
> "This workflow requires Python 3.11+ and [package]. Install with: pip3 install [package]"

**Only if prerequisites met:**

### Step 1: [First Operation]
[Continue with workflow]
```

**Example:**
```markdown
## Image Processing Workflow

### Prerequisites Check

```bash
python3 --version  # Requires 3.11+
pip3 show Pillow imageio
```

If missing:
> "This workflow requires Python 3.11+ with Pillow and imageio. Install with: pip3 install Pillow imageio"

### Step 1: Load Image
[Workflow continues...]
```

## Summary Guidelines

**For sequential processes:**
- Number steps clearly
- State dependencies between steps
- Show expected outputs

**For conditional processes:**
- Use decision trees or if-then structures
- Make conditions explicit
- Provide all branches

**For hybrid processes:**
- Combine patterns appropriately
- Keep structure clear
- Avoid deep nesting (max 2-3 levels)

**For error handling:**
- Anticipate failure points
- Provide fallback options
- Give actionable error messages

**For script integration:**
- Show when to run scripts
- Specify parameters clearly
- Explain how to use results

**For environment dependencies:**
- Check prerequisites early
- Provide clear installation guidance
- Fail gracefully with helpful messages
