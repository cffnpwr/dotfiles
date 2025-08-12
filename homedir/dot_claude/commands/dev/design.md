# Design Documentation

Transform requirements into detailed technical design specifications.

## Process

1. **Requirements Analysis**
   - Read requirements from `.tmp/requirements.md`
   - Identify system components and interfaces
   - Plan architecture and data flow

2. **Design Documentation Structure**
   - Create design overview in `.tmp/design.md`
   - Generate feature-specific designs in `.tmp/design/` directory
   - Separate concerns for maintainability and focused implementation

3. **Technical Specifications**
   - Define APIs, data structures, and algorithms
   - Specify error handling and edge cases
   - Document testing and validation approach

## Output Format

### Overview Document (`.tmp/design.md`)
- **Architecture Overview**: System structure and core principles
- **Implementation Phases**: Priority-based development roadmap
- **Feature Document Index**: Links to specific design documents
- **Key Technologies**: Framework and library decisions

### Feature-Specific Documents (`.tmp/design/*.md`)
- **Commit Validation Design**: Git commit message and signature validation
- **File Protection Design**: Manifest file protection system
- **Individual Implementation Focus**: Detailed technical specifications per feature

## Integration

- Reads from `.tmp/requirements.md`
- Outputs overview to `.tmp/design.md`
- Outputs feature designs to `.tmp/design/` directory
- Provides modular input for implementation tasks
- Leverages Serena tools for codebase analysis

## Next Steps

Upon successful completion of design documentation:

```bash
/dev:design-review
```

This will present the design to you for review and alignment, ensuring the technical approach meets your requirements before proceeding to implementation.
