---
name: gh-reference
description: GitHub CLI (gh) command reference for accessing GitHub resources. Use when fetching GitHub issues, pull requests, repositories, releases, or any GitHub resource. Preferred over WebFetch for GitHub URLs because WebFetch cannot execute JavaScript and may fail to render dynamic GitHub pages.
compatibility: No external dependencies. Requires gh CLI to be authenticated (gh auth login).
---

# GitHub CLI (gh) Reference

Use `gh` for all GitHub resource access. Do NOT use WebFetch for GitHub URLs — GitHub pages require JavaScript to render and WebFetch will fail.

## Why gh Instead of WebFetch

- GitHub uses client-side rendering (JavaScript). WebFetch fetches raw HTML without JS execution.
- `gh` calls the GitHub API directly and returns structured, complete data.

## Common Commands

### Issues

```bash
gh issue view <number>                   # View issue details
gh issue list                            # List issues in current repo
gh issue list --repo owner/repo          # List issues in specific repo
gh issue view <number> --comments        # View with comments
gh issue create                          # Create new issue
```

### Pull Requests

```bash
gh pr view <number>                      # View PR details
gh pr list                               # List open PRs
gh pr list --repo owner/repo             # List PRs in specific repo
gh pr view <number> --comments           # View with comments
gh pr diff <number>                      # View PR diff
gh pr checks <number>                    # View CI check status
gh pr review <number>                    # Review a PR
```

### Repositories

```bash
gh repo view owner/repo                  # View repo details
gh repo clone owner/repo                 # Clone a repository
gh repo list <owner>                     # List repos for a user/org
```

### Releases

```bash
gh release view <tag>                    # View release details
gh release list                          # List releases
gh release list --repo owner/repo        # List releases in specific repo
```

### API (arbitrary GitHub API calls)

```bash
gh api repos/owner/repo                  # Repo metadata
gh api repos/owner/repo/issues           # Issues list
gh api repos/owner/repo/pulls/123        # PR details
gh api repos/owner/repo/contents/path    # File contents (base64 encoded)
```

For paginated results:
```bash
gh api --paginate repos/owner/repo/issues
```

### Other

```bash
gh auth status                           # Check authentication
gh gist view <id>                        # View a gist
gh search issues "query"                 # Search issues
gh search prs "query"                    # Search pull requests
gh search repos "query"                  # Search repositories
```

## Specifying Repository Context

When not inside a git repository, always pass `--repo owner/repo` or use `gh api repos/owner/repo/...`.

```bash
# In a repo directory — repo is inferred automatically
gh issue list

# Outside a repo — must specify explicitly
gh issue list --repo cffnpwr/dotfiles
gh api repos/cffnpwr/dotfiles/issues
```

## Output Formats

```bash
gh issue view 123 --json title,body,state          # JSON output with specific fields
gh pr list --json number,title,state               # JSON list
gh api repos/owner/repo --jq '.description'        # Use jq to extract fields
```
