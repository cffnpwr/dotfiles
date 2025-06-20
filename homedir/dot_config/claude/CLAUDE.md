# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## General Principles

YOU MUST: Respond in Japanese when communicating with users and writing technical documentation.
YOU MUST: Write CLAUDE.md files and system instructions in English for optimal processing.
YOU MUST: Write commit messages in Japanese using noun-ending form (体言止め).
YOU MUST: When insufficient information is provided to complete a user's request, clearly state what information is missing and specify what additional details would be needed to fulfill the request.
YOU MUST: If you don't know something, explicitly state that you don't know rather than guessing or providing uncertain information.

## Git Commit Guidelines

YOU MUST: Follow Conventional Commits standards with the following specific format:

### Commit Message Format

```text
<type> <emoji>: <commit message>
```

### Commit Types

YOU MUST: Choose from the following types:

- **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **ci**: Changes to CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: Documentation only changes
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: Adding missing tests or correcting existing tests

### Emoji Guidelines

YOU MUST: Use Gitmoji for consistency and visual clarity
YOU MUST: Each commit type should be paired with an appropriate emoji

### Commit Message Guidelines

YOU MUST: Write commit messages on a single line without line breaks
YOU MUST: Write commit messages concisely and descriptively
YOU MUST: Use noun-ending form (体言止め) in Japanese
YOU MUST: Clearly indicate what was changed or implemented

### Examples

**Good Examples:**

- `feat ✨: ログイン機能の実装`
- `fix 🐛: データベース接続エラーの修正`
- `docs 📚: README.mdの更新`
- `refactor ♻️: ユーザー認証ロジックのリファクタリング`

**Bad Examples:**

- `なんかもうめっちゃ変えた`
- `update`
- `fixes`
- `commit`

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

## Editor Configuration

YOU MUST: When editing files, always check for the existence of `.editorconfig` in the project root
YOU MUST: If `.editorconfig` exists, strictly follow its formatting rules including:

- Indentation style (spaces vs tabs)
- Indentation size
- End of line characters
- Character encoding
- Final newline requirements
- Trailing whitespace handling

YOU MUST: Ensure all file modifications comply with the project's `.editorconfig` settings

## Claude Code Initialization Guidelines

YOU MUST: When writing CLAUDE.md using `/init` command, always write rules in English
YOU MUST: When writing CLAUDE.md using `/init` command, include detailed directory structure to provide comprehensive project context
IMPORTANT: English is preferred for CLAUDE.md because Claude Code processes rules more efficiently in English context

## Git Operations Guidelines

YOU MUST: Use Git MCP server tools for all Git operations when available
YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server
YOU MUST: Prioritize Git MCP server tools over bash commands for Git operations

Examples of preferred approach:
- Use `mcp__git__git_status` instead of `git status`
- Use `mcp__git__git_diff` instead of `git diff`
- Use `mcp__git__git_commit` instead of `git commit`
- Use `mcp__git__git_add` instead of `git add`

## important-instruction-reminders

Do what has been asked; nothing more, nothing less.
NEVER: Create files unless they're absolutely necessary for achieving your goal.
YOU MUST: Always prefer editing an existing file to creating a new one.
NEVER: Proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
