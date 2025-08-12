# Task Generation

Break down design specifications into actionable implementation tasks.

## Process

1. **Design Analysis**
   - Read design from `.tmp/design.md`
   - Identify implementation components and dependencies
   - Plan execution order and task priorities

2. **Task Breakdown**
   - Create task checklist in `.tmp/tasks.md`
   - Generate detailed task files in `.tmp/tasks/*.md`
   - Create TodoWrite checklist for active tracking

3. **File Structure**
   - **Checklist**: `.tmp/tasks.md` - Task overview with status
   - **Task Details**: `.tmp/tasks/{task-id}.md` - Full specifications
   - **TodoWrite**: Active task tracking for immediate work

## Task File Structure

### Checklist Format (`.tmp/tasks.md`)
```markdown
# Task Checklist

## Overview
- Project: [project-name]
- Design: [design-file-reference]
- Created: [timestamp]

## Tasks
- [ ] TASK-001: [brief-description]
- [ ] TASK-002: [brief-description]
- [x] TASK-003: [brief-description] ✓

## Status
- Total: X tasks
- Completed: Y tasks
- Remaining: Z tasks
```

### Task Detail Format (`.tmp/tasks/{task-id}.md`)
```markdown
# TASK-{ID}: [Title]

## Description
[Detailed implementation description]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Dependencies
- TASK-XXX: [dependency description]

## Design References
- Section: [design-section-reference]
- Files: [relevant-design-files]

## Implementation Notes
[Technical details and considerations]

## Validation Steps
1. [validation step 1]
2. [validation step 2]
```

## Integration

- Reads from `.tmp/design.md`
- Creates structured task files in `.tmp/tasks/`
- Maintains checklist in `.tmp/tasks.md`
- Creates TodoWrite checklist for active tracking
- Provides input for `/implement` command

## Next Steps

Upon successful task generation:

```bash
/dev:implement
```

This will automatically implement the first uncompleted task using strict TDD methodology (Red-Green-Refactor cycle) with comprehensive testing.
