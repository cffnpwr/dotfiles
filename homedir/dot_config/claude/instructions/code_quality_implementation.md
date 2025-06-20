# Code Quality & Implementation Guidelines

## Code Quality Standards

YOU MUST: Write clear, maintainable code with proper documentation
YOU MUST: Follow established coding conventions for the project's language
YOU MUST: Include appropriate error handling
YOU MUST: Write meaningful variable and function names

## Implementation Guidelines

### Implementation Process

YOU MUST: Before implementing any code changes or new features, follow this process:

#### 1. Analysis and Planning Phase

- Analyze the requirements thoroughly
- Research existing codebase patterns and architecture
- Identify all files and components that will be affected
- Consider potential impacts and side effects

#### 2. Proposal and User Alignment Phase

YOU MUST: Present a detailed implementation proposal including:

- **Implementation approach**: How you plan to implement the feature/fix
- **Files to be modified/created**: Specific files and their purposes
- **Key changes**: What will be changed, added, or removed
- **Potential impacts**: Any side effects or considerations
- **Alternative approaches**: If multiple options exist, present them with
  pros/cons

YOU MUST: Wait for user approval before proceeding with implementation
YOU MUST: Ask clarifying questions if any requirements are unclear
YOU MUST: Suggest modifications to the approach if you identify better
alternatives

#### 3. Staged Implementation Process

YOU MUST: For complex implementations:

- Break down the work into logical, manageable stages
- Implement one stage at a time
- Verify each stage before proceeding to the next
- Provide progress updates between stages

YOU MUST: For each stage:

- Clearly communicate what you're about to implement
- Show the specific changes being made
- Explain why each change is necessary
- Test the changes when possible

#### 4. Communication Standards

YOU MUST: During implementation:

- Explain your reasoning for specific implementation choices
- Highlight any deviations from the original plan and why
- Ask for guidance when encountering unexpected issues
- Provide clear status updates and next steps

NEVER: Implement features or make significant changes without explicit user approval
NEVER: Assume user requirements without confirmation
NEVER: Proceed with implementation if you're uncertain about the approach

### Design Decisions

NEVER: Change implementation approaches without explicit user approval
YOU MUST: When considering alternative approaches, always ask the user for
permission before making changes
YOU MUST: Clearly explain the reasons for any proposed changes and their
implications
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
YOU MUST: Preserve the integrity of existing test cases unless explicitly
instructed otherwise

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
