# Git Rebase

YOU MUST: Follow the Git guidelines defined in @../../instructions/git.md

YOU MUST: Use Git MCP server tools for all Git operations when available.

YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server.

Execute the following workflow:

1. Check current repository status and branch using git_status
2. Verify working directory is clean
3. Execute rebase operation with specified target using git_rebase
4. Handle any conflicts that arise during rebase
5. Confirm rebase completion

## Rebase Types

- **Standard rebase**: Rebase current branch onto another branch
- **Interactive rebase**: Allow editing of commit history
- **Continue**: Continue rebase after resolving conflicts
- **Abort**: Cancel ongoing rebase operation
- **Skip**: Skip current commit during rebase

## Safety Guidelines

YOU MUST: Ensure working directory is clean before starting rebase.
YOU MUST: Create backup branch before complex rebase operations.
YOU MUST: Never rebase commits that have been pushed to shared branches.
YOU MUST: Handle conflicts carefully and test after rebase completion.

## Conflict Resolution

When conflicts occur:

1. Identify conflicted files
2. Resolve conflicts manually
3. Stage resolved files
4. Continue rebase process
