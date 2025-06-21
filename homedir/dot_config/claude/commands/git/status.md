# Git Status

YOU MUST: Follow the Git guidelines defined in @instructions/git.md

YOU MUST: Use Git MCP server tools for all Git operations when available.

YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server.

Execute the following workflow:

1. Display current repository status using git_status
2. Show current branch and tracking information
3. List staged, unstaged, and untracked files
4. Provide summary of repository state

## Status Information

Display the following information:

- **Current branch**: Active branch name and upstream tracking
- **Repository state**: Clean, dirty, or in special state (merge, rebase, etc.)
- **Staged changes**: Files ready for commit
- **Unstaged changes**: Modified files not yet staged
- **Untracked files**: New files not under version control
- **Conflicted files**: Files with merge conflicts (if applicable)

## Additional Context

YOU MUST: Provide clear interpretation of the status information.
YOU MUST: Suggest next steps based on current repository state.
YOU MUST: Highlight any issues that require attention.
