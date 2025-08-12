# Implementation Validation

Verify implementation quality and update task completion status.

## Process

1. **Implementation Review**
   - Analyze recent implementation changes
   - Verify adherence to design specifications
   - Check compliance with project standards

2. **Quality Validation**
   - Run tests and linting where applicable
   - Review code quality and maintainability
   - Validate functional requirements satisfaction

3. **Checklist Updates**
   - Confirm task completion or identify issues
   - Update TodoWrite status appropriately
   - Document validation results and next steps

## Validation Criteria

- **Functional Correctness**: Implementation meets requirements
- **Code Quality**: Follows project conventions and standards
- **Integration**: Works with existing codebase
- **Testing**: Passes relevant tests and validations

## Integration

- Reviews implementation artifacts
- Updates TodoWrite checklist status
- Provides feedback for iteration
- Signals readiness for next `/implement` cycle

## Next Steps

After validation completion:

### If validation successful and more tasks remain:
```bash
/dev:implement
```

### If all tasks completed:
```bash
# Development cycle complete!
# Consider running project-specific commands like:
# - `npm run test` for final testing
# - `npm run build` for production builds
# - `/git:commit` for version control
```

### If validation reveals issues:
```bash
/dev:implement
```
Address identified issues in the current task before proceeding.
