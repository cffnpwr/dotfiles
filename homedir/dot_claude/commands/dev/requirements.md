# Requirements Generation

Analyze user instructions and generate structured requirements documentation.

## Process

1. **Instruction Analysis**
   - Parse user request for functional requirements
   - Identify technical constraints and dependencies
   - Extract quality requirements and acceptance criteria

2. **Requirements Documentation**
   - Create structured requirements document
   - Save to `.tmp/requirements.md` for reference
   - Include priority levels and implementation notes

3. **Validation**
   - Ensure requirements are testable and measurable
   - Check for completeness and clarity
   - Identify potential risks and assumptions

## Output Format

Generate requirements document with:
- **Functional Requirements**: Core features and behaviors
- **Technical Requirements**: Architecture, performance, compatibility
- **Quality Requirements**: Testing, documentation, maintainability
- **Acceptance Criteria**: Definition of done for each requirement

## Integration

- Uses `.tmp` directory for artifact management
- Provides input for `/design` command
- References existing project context and constraints

## Next Steps

Upon successful completion of requirements generation:

```bash
/dev:design
```

This will transform your requirements into detailed technical design specifications, creating an architecture overview and feature-specific implementation plans.
