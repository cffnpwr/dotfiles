# Git Pull

YOU MUST: Follow the Git guidelines defined in @instructions/git.md

YOU MUST: Use Git MCP server tools for all Git operations when available.

YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server.

Execute the following workflow:

1. Check current branch and remote tracking status using git_status
2. Verify working directory state
3. Fetch and merge changes from remote repository using git_pull
4. Handle any merge conflicts that arise
5. Confirm pull operation success

## Pull Options

- **Standard pull**: Fetch and merge from tracked upstream
- **Rebase pull**: Fetch and rebase instead of merge
- **Fast-forward only**: Only allow fast-forward merges

## Safety Guidelines

YOU MUST: Check for uncommitted changes before pulling.
YOU MUST: Stash or commit local changes if working directory is dirty.
YOU MUST: Handle merge conflicts carefully if they occur.
YOU MUST: Verify repository state after pull completion.

## Conflict Resolution

When merge conflicts occur:
1. Identify conflicted files
2. Resolve conflicts manually
3. Stage resolved files  
4. Complete merge with commit (if needed)