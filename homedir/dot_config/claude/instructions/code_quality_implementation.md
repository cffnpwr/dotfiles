# Code Quality & Implementation Guidelines

## Code Quality Standards

YOU MUST: Write clear, maintainable code with proper documentation
YOU MUST: Follow established coding conventions for the project's language
YOU MUST: Include appropriate error handling
YOU MUST: Write meaningful variable and function names

## Implementation Guidelines

### Design Decisions

NEVER: Change implementation approaches without explicit user approval
YOU MUST: When considering alternative approaches, always ask the user for permission before making changes
YOU MUST: Clearly explain the reasons for any proposed changes and their implications
YOU MUST: Respect the user's original architectural decisions and coding patterns

### Error Handling and Debugging

NEVER: Use quick fixes or workarounds for errors
NEVER: Comment out error-causing code without proper resolution
NEVER: Silence errors with empty catch blocks
NEVER: Modify test cases to make them pass instead of fixing the underlying issue
NEVER: Use temporary patches that don't address root causes

YOU MUST: Investigate and understand the root cause of errors
YOU MUST: Implement proper, sustainable solutions
YOU MUST: If unsure about the best approach, ask the user for guidance
YOU MUST: Preserve the integrity of existing test cases unless explicitly instructed otherwise

### Information Gathering

YOU MUST: Actively use web search when encountering:

- Unfamiliar libraries, frameworks, or technologies
- API documentation needs
- Best practices for specific implementations
- Error messages or debugging guidance
- Latest syntax or feature updates

IMPORTANT: Don't assume knowledge about rapidly changing technologies
YOU MUST: Always verify implementation details with current documentation when uncertain

### Library and Framework Usage

YOU MUST: When using external libraries or frameworks in code:

- Research the library thoroughly even if you think you know it well
- Verify the latest version, syntax, and best practices
- Check for any breaking changes or deprecations
- Ensure information accuracy and reliability before implementation
- Consult official documentation and reliable sources
