# Output Patterns for Skills

Guidance for defining desired outputs and quality standards in skills.

## When to Use Output Patterns

Use output patterns when:
- Output format is specific (structured data, documents, code)
- Quality standards must be met (style, completeness, accuracy)
- Examples are more effective than descriptions
- Multiple output variations exist

## Template-Based Outputs

Provide templates that AI Agents fill with content.

### Pattern: Direct Template

```markdown
## Output Format

Use this template:

```
[Template with placeholders]
```

Example:
[Filled template example]
```

**Example - Status Report:**
```markdown
## Output Format

Use this template for status reports:

```
# Project Status Report - [Date]

## Overview
[1-2 sentence summary]

## Completed This Week
- [Item 1]
- [Item 2]

## In Progress
- [Item with status]

## Blockers
[None / List blockers]

## Next Week
- [Planned item 1]
- [Planned item 2]
```

Example:
```
# Project Status Report - 2026-02-18

## Overview
Successfully completed API integration and began frontend implementation.

## Completed This Week
- REST API endpoints for user management
- Database schema migrations

## In Progress
- Frontend authentication flow (70% complete)

## Blockers
None

## Next Week
- Complete frontend auth
- Begin dashboard implementation
```
```

### Pattern: Asset-Based Template

Reference asset files that get copied and customized.

```markdown
## Output Format

Start with template from assets/[template-name]:

1. Copy template to working location
2. Customize [specific sections]
3. Fill placeholders: [list]

The template includes:
- [Structure element 1]
- [Structure element 2]
```

**Example - Document Template:**
```markdown
## Creating New Reports

Start with template from assets/report-template.docx:

1. Copy template to output location
2. Customize:
   - Title page: Company name, date, author
   - Section 1: Executive summary
   - Section 2-4: Detailed findings
   - Appendix: Supporting data
3. Maintain formatting and styles from template
```

## Example-Based Outputs

Show concrete examples that demonstrate desired output.

### Pattern: Multiple Examples

```markdown
## Output Examples

**Example 1: [Scenario A]**
```
[Complete output for scenario A]
```

**Example 2: [Scenario B]**
```
[Complete output for scenario B]
```

Key characteristics:
- [Pattern 1]
- [Pattern 2]
```

**Example - Code Generation:**
```markdown
## Output Examples

**Example 1: Simple function**
```python
def calculate_total(items: list[dict]) -> float:
    """Calculate total price of items.
    
    Args:
        items: List of dicts with 'price' and 'quantity' keys
        
    Returns:
        Total price as float
    """
    return sum(item['price'] * item['quantity'] for item in items)
```

**Example 2: Class with methods**
```python
class ShoppingCart:
    """Shopping cart with add/remove/total operations."""
    
    def __init__(self):
        """Initialize empty cart."""
        self.items = []
    
    def add_item(self, item: dict) -> None:
        """Add item to cart."""
        self.items.append(item)
    
    def calculate_total(self) -> float:
        """Calculate cart total."""
        return sum(item['price'] * item['quantity'] for item in self.items)
```

Key characteristics:
- Type hints for all parameters and returns
- Docstrings in Google style
- Descriptive variable names
- One responsibility per function/method
```

## Quality Standards

Define standards that outputs must meet.

### Pattern: Checklist

```markdown
## Output Requirements

Output must satisfy:
- [ ] [Requirement 1]
- [ ] [Requirement 2]
- [ ] [Requirement 3]

Verify each item before finalizing.
```

**Example - Code Quality:**
```markdown
## Code Quality Standards

Generated code must satisfy:
- [ ] Passes type checking (mypy for Python, tsc for TypeScript)
- [ ] Has docstrings/comments for all public functions
- [ ] Uses descriptive variable names (no single letters except i, j, k in loops)
- [ ] Handles errors appropriately (try/catch or Result types)
- [ ] Maximum function length: 50 lines
- [ ] Maximum file length: 500 lines

Verify each item before finalizing code.
```

### Pattern: Acceptance Criteria

```markdown
## Acceptance Criteria

Output is acceptable if:
1. [Criterion 1 with measurable standard]
2. [Criterion 2 with measurable standard]
3. [Criterion 3 with measurable standard]

If any criterion fails, [remediation action].
```

**Example - Document Quality:**
```markdown
## Document Acceptance Criteria

Document is acceptable if:
1. Length is 1000-2000 words
2. Contains 3-5 main sections with clear headings
3. Includes at least 2 concrete examples
4. Free of spelling/grammar errors (use spell checker)
5. All claims have supporting evidence or citations

If any criterion fails, revise the document before presenting to user.
```

## Structured Data Outputs

Define JSON, YAML, or other structured formats.

### Pattern: Schema Definition

```markdown
## Output Schema

Return JSON with this structure:

```json
{
  "field1": "type and description",
  "field2": {
    "nested": "structure description"
  },
  "field3": ["array of items"]
}
```

Validation rules:
- [Rule 1]
- [Rule 2]
```

**Example - API Response:**
```markdown
## API Response Format

Return JSON with this structure:

```json
{
  "status": "success or error",
  "data": {
    "id": "string - unique identifier",
    "name": "string - user-facing name",
    "created_at": "ISO 8601 timestamp",
    "attributes": {
      "key1": "value1",
      "key2": "value2"
    }
  },
  "errors": []
}
```

Validation rules:
- status must be "success" or "error"
- data is null when status is "error"
- errors is empty array when status is "success"
- timestamps in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ)
- all IDs are UUIDs v4
```

## Progressive Outputs

For multi-stage outputs, define each stage.

### Pattern: Staged Output

```markdown
## Output Stages

### Stage 1: [Initial Output]
[Format and requirements for stage 1]

### Stage 2: [Refined Output]
[Format and requirements for stage 2, building on stage 1]

### Stage 3: [Final Output]
[Format and requirements for final stage]
```

**Example - Design Process:**
```markdown
## Design Output Stages

### Stage 1: Wireframe
Text-based layout structure:
```
[Header]
  - Logo | Navigation
[Main Content]
  - Title
  - Body (2 columns)
  - Sidebar (1 column)
[Footer]
  - Links | Copyright
```

### Stage 2: Detailed Mockup
ASCII art or description with specific dimensions:
- Colors specified (hex codes)
- Fonts identified (family, size, weight)
- Spacing defined (padding, margins in px)

### Stage 3: Implementation Code
HTML/CSS code implementing the design:
- Semantic HTML structure
- Responsive CSS (mobile-first)
- Accessibility attributes (ARIA labels)
```

## Format-Specific Patterns

### Code Output

```markdown
## Code Output Format

Language: [Specify language]

Structure:
```[language]
[Code structure template]
```

Style guide:
- [Style rule 1]
- [Style rule 2]

Comments:
- [When and what to comment]
```

### Document Output

```markdown
## Document Format

Format: [Markdown/PDF/DOCX/etc.]

Structure:
1. [Section 1]: [Purpose and length]
2. [Section 2]: [Purpose and length]

Formatting:
- Headings: [Style guide]
- Lists: [When to use]
- Emphasis: [Bold/italic usage]
- Code blocks: [When to use]
```

### Data Output

```markdown
## Data Format

Format: [JSON/CSV/YAML/etc.]

Columns/Fields:
- field1: [Type, constraints, description]
- field2: [Type, constraints, description]

Encoding: [UTF-8/etc.]
Delimiter: [for CSV]
Null handling: [How to represent missing values]
```

## Validation Patterns

How to verify outputs meet standards.

### Pattern: Self-Validation

```markdown
## Output Validation

Before finalizing, verify:

**Automated checks:**
```bash
[Command to run validation tool]
```

**Manual checks:**
1. [Visual or logical check 1]
2. [Visual or logical check 2]

If validation fails:
[Remediation steps]
```

**Example:**
```markdown
## Python Code Validation

Before finalizing, verify:

**Automated checks:**
```bash
python -m py_compile code.py  # Syntax check
mypy code.py                  # Type check
pylint code.py                # Linting
```

**Manual checks:**
1. All functions have docstrings
2. No TODOs or placeholder comments remain
3. Variable names are descriptive

If validation fails:
- Fix syntax/type errors first
- Address linting warnings (aim for 8.0+ score)
- Complete all TODOs or remove if not needed
```

## Compatibility in Output Patterns

Consider environment when defining outputs.

### Pattern: Environment-Conditional Output

```markdown
## Output Format

**If Python available:**
Generate Python script using scripts/template.py

**If Python not available:**
Generate shell script alternative

Both outputs must achieve same result.
```

**Example:**
```markdown
## Data Processing Output

**If Python 3.11+ with pandas available:**
Generate Python script:
- Use pandas for data manipulation
- Output to CSV/JSON/Excel as needed

**If only Bash available:**
Generate shell script:
- Use awk/sed for data manipulation
- Output to CSV only

Both approaches must:
- Handle same input format
- Produce compatible outputs
- Include error handling
```

## Summary Guidelines

**For template-based outputs:**
- Provide complete, usable templates
- Mark placeholders clearly
- Show filled examples

**For example-based outputs:**
- Include diverse examples covering common cases
- Highlight patterns and key characteristics
- Show both simple and complex cases

**For quality standards:**
- Make criteria measurable and verifiable
- Provide validation methods
- State what to do if standards not met

**For structured data:**
- Define schema completely
- Specify validation rules
- Include type information

**For staged outputs:**
- Define each stage clearly
- Show how stages build on each other
- Specify when to move between stages

**For validation:**
- Provide automated checks when possible
- Include manual verification steps
- State remediation procedures
