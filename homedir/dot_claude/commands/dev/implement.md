# Task Implementation

Implement a specific task or automatically implement the next pending task from `.tmp/tasks.md` with comprehensive testing.

## Usage

```bash
/dev:implement              # Automatically select first incomplete task
/dev:implement [TASK-ID]    # Implement specific task (e.g., ARCH-003, SIG-001)
```

## Process

1. **Task Selection**
   - Check `.tmp/tasks.md` for uncompleted tasks (items with `[ ]`)
   - If no task specified in arguments: automatically select the first uncompleted task
   - If task specified in arguments: validate and select the specified task
   - Load detailed task information from `.tmp/tasks/*.md`

2. **TDD Cycle Implementation**
   - Follow strict Test-Driven Development (Red-Green-Refactor) cycle
   - Use Serena tools for code analysis and modification
   - Apply design patterns and project conventions
   - Follow established coding standards and practices

3. **RED Phase - Test First**
   - Create function/struct/class declarations (empty implementations)
   - Write comprehensive tests for expected behavior
   - Include tests for edge cases and error conditions
   - Run tests to confirm they FAIL (RED state)
   - Verify test failures are for the right reasons

4. **GREEN Phase - Make Tests Pass**
   - Implement minimal logic to make tests pass
   - Focus on making tests green, not perfect code
   - Run tests iteratively until all pass
   - Ensure no existing tests are broken

5. **REFACTOR Phase - Improve Code Quality**
   - Clean up implementation while keeping tests green
   - Apply design patterns and best practices
   - Remove code duplication
   - Improve readability and maintainability
   - Re-run tests to ensure refactoring doesn't break functionality

6. **Progress Tracking**
   - Update task status to `[x]` in `.tmp/tasks.md` upon completion
   - Ensure proper validation of both implementation and tests
   - Prepare artifacts for validation step

## Task File Structure

Expected structure:

```text
.tmp/
├── tasks.md          # Main task checklist with [ ]/[x] format
└── tasks/            # Detailed task descriptions
    ├── task-1.md
    ├── task-2.md
    └── ...
```

## Implementation Strategy

- **Strict TDD Workflow**: Follow Red-Green-Refactor cycle religiously
- **Incremental Development**: One task at a time with small iterations
- **Quality Focus**: Follow code quality guidelines throughout all phases
- **Integration Aware**: Consider existing codebase patterns
- **Test-First Approach**: Write tests before any implementation logic
- **Continuous Validation**: Ensure tests fail first (RED), then pass (GREEN)
- **Refactoring Discipline**: Improve code quality while maintaining green tests
- **Validation Ready**: Prepare for `/validate` verification with comprehensive test coverage

## Integration

- Reads `.tmp/tasks.md` for task selection
- Loads detailed specs from `.tmp/tasks/*.md`
- Uses Serena tools for code implementation
- Follows strict TDD Red-Green-Refactor cycle
- Validates each phase transition with test execution
- Updates checklist status automatically upon successful TDD completion

## Next Steps

Upon successful implementation completion:

```bash
/dev:validate
```

This will verify implementation quality, run tests, and update task completion status before proceeding to the next implementation cycle.

## TDD Workflow Requirements

### RED Phase Requirements

- **Declaration First**: Create empty function/class/struct declarations
- **Test Implementation**: Write comprehensive tests for expected behavior
- **Failure Verification**: Run tests to confirm they fail for correct reasons
- **Edge Case Coverage**: Include boundary conditions and error scenarios

### GREEN Phase Requirements

- **Minimal Implementation**: Write just enough code to pass tests
- **Iterative Development**: Make one test pass at a time
- **Regression Testing**: Ensure existing tests remain green
- **Progress Validation**: Confirm all new tests pass before proceeding

### REFACTOR Phase Requirements

- **Code Quality**: Improve implementation without changing behavior
- **Design Patterns**: Apply appropriate patterns and principles
- **DRY Principle**: Eliminate code duplication
- **Continuous Testing**: Re-run tests after each refactoring step

### Framework Integration

- **Auto-Detection**: Automatically detect and use project's testing framework
- **Convention Following**: Adhere to project's testing conventions and patterns
- **Test Organization**: Structure tests logically with clear descriptions
- **Documentation**: Include test descriptions explaining what is being verified
