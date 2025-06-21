# Git Push

YOU MUST: Follow the Git guidelines defined in @../../instructions/git.md

YOU MUST: Use Git MCP server tools for all Git operations when available.

YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server.

Execute the following workflow:

1. Check current branch and remote tracking status using git_status
2. Verify local changes are committed
3. Push to remote repository using git_push with appropriate options
4. Confirm push was successful

## Push Options

- **Standard push**: Push current branch to its upstream
- **Set upstream**: Push and set upstream tracking for new branches  
- **Force push (with lease)**: Safely force push using --force-with-lease
- **Push tags**: Include tags in the push operation

YOU MUST: Use --force-with-lease instead of --force for safer force pushes.
YOU MUST: Confirm the target remote and branch before pushing.
YOU MUST: Check for any untracked files or uncommitted changes before pushing.
