# Git Operations

Git workflow guidelines and slash command usage for version control operations.

## Core Principle: Use Slash Commands

**ALWAYS prefer Git slash commands over natural language requests.**

When users request Git operations in natural language, guide them to the appropriate slash command.

## Available Git Slash Commands

### Commit Operations

**`/commit`** - Create a Git commit
- Stages changes
- Generates commit message
- Creates commit with conventional format

**Usage:**
```
User: "Commit my changes"
Assistant: "Please use the /commit slash command to create a commit."
```

### Pull Request Operations

**`/pr`** - Create a pull request
- Pushes current branch
- Creates PR with description
- Links related issues

**Usage:**
```
User: "Create a pull request"
Assistant: "Please use the /pr slash command to create a pull request."
```

### Branch Operations

**`/branch`** - Create and switch to a new branch (if available)

**Usage:**
```
User: "Create a new branch for feature X"
Assistant: "Please use the /branch slash command, or I can help you with:
git checkout -b feature/feature-x"
```

### Review Operations

**`/review-pr`** - Review a pull request (if available)

**Usage:**
```
User: "Review this PR"
Assistant: "Please use the /review-pr slash command to review the pull request."
```

## Permitted Direct Git Operations

Only use Bash tool for Git commands in these cases:

### 1. Read-Only Operations (Always Permitted)

```bash
# Status and inspection
git status
git log
git log --oneline
git log --graph --oneline --all
git diff
git diff --staged
git diff main...feature-branch
git show <commit-hash>

# Branch listing
git branch
git branch -a
git branch -r

# Remote information
git remote -v
git remote show origin

# Configuration inspection
git config --list
git config --get user.name
```

### 2. Safe Local Operations (Permitted)

```bash
# Stashing
git stash
git stash list
git stash pop
git stash apply

# Fetch (no local changes)
git fetch
git fetch --all
git fetch origin

# Branch switching (existing branches)
git checkout <existing-branch>
git switch <existing-branch>
```

### 3. Operations Requiring User Confirmation

**ALWAYS ask user before executing:**

```bash
# Destructive operations
git reset --hard
git clean -fd
git rebase
git push --force

# Branch deletion
git branch -d <branch>
git branch -D <branch>
git push origin --delete <branch>

# Merge operations
git merge <branch>
git pull origin <branch>
```

## Workflow Examples

### Example 1: User Wants to Commit

❌ BAD:
```
User: "Commit my changes with message 'fix bug'"
Assistant: *Runs git add . && git commit -m "fix bug"*
```

✅ GOOD:
```
User: "Commit my changes with message 'fix bug'"
Assistant: "Please use the /commit slash command to create a commit.
It will help you stage changes and create a properly formatted commit message."
```

### Example 2: User Wants to Create PR

❌ BAD:
```
User: "Create a PR for this feature"
Assistant: *Runs gh pr create commands*
```

✅ GOOD:
```
User: "Create a PR for this feature"
Assistant: "Please use the /pr slash command to create a pull request.
It will push your branch and create a PR with a proper description."
```

### Example 3: Checking Status (Permitted)

✅ GOOD:
```
User: "What's the current git status?"
Assistant: *Runs git status*
"Here's your current git status:
[output]"
```

### Example 4: Destructive Operation (Confirmation Required)

✅ GOOD:
```
User: "Reset my changes"
Assistant: "This will permanently discard all uncommitted changes. Are you sure you want to:
git reset --hard HEAD

This action cannot be undone. Confirm?"

[Wait for user confirmation]
```

## Commit Message Conventions

If you need to suggest commit message format:

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semi-colons, etc.)
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks
- **ci**: CI/CD changes

### Examples

```
feat(auth): add OAuth2 authentication flow

Implement OAuth2 authentication using Google provider.
Includes login, logout, and token refresh functionality.

Closes #123
```

```
fix(api): resolve race condition in user creation

Add mutex lock to prevent duplicate user creation when
multiple requests arrive simultaneously.
```

```
docs(readme): update installation instructions

Add troubleshooting section for common installation issues.
```

## GitHub CLI (gh) Commands

### Read-Only Operations (Always Permitted)

```bash
# View issues
gh issue list
gh issue view <number>

# View PRs
gh pr list
gh pr view <number>
gh pr diff <number>
gh pr checks <number>

# View releases
gh release list
gh release view <tag>

# Repository information
gh repo view
```

### Operations Requiring Confirmation

```bash
# Create/modify issues
gh issue create
gh issue close <number>

# Create/modify PRs (use /pr instead)
gh pr create
gh pr merge <number>
gh pr close <number>

# Create releases
gh release create <tag>
```

## Best Practices

1. **Always prefer slash commands for write operations**
2. **Use Bash for read-only Git operations**
3. **Ask for confirmation before destructive operations**
4. **Provide clear explanations for Git errors**
5. **Suggest proper commit message format**
6. **Check git status before suggesting operations**

## Error Handling

When Git operations fail:

1. **Read the error message carefully**
2. **Search for solution if unfamiliar error** (use research-and-information-gathering skill)
3. **Explain the error to user in clear terms**
4. **Suggest corrective action**
5. **Ask for user confirmation before attempting fix**

### Example Error Handling

```
Error: "fatal: not a git repository"

✅ GOOD Response:
"This error means the current directory is not a Git repository.
Would you like me to:
1. Initialize a new Git repository (git init)?
2. Check if we're in the correct directory?

Which would you prefer?"
```

## When to Use This Skill

- User requests Git operations (commit, push, PR, etc.)
- Need to explain Git workflow
- Handling Git errors
- Suggesting Git commands
- Reviewing Git history
