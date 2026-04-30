# Tool Usage

Rules for tool selection and temporary CLI usage.

## Temporary CLI Tools: Use `nix-shell`

When a CLI tool is not available in the current environment, use `nix-shell -p <package>` to run it temporarily. Never install it globally.

### Why

- The system is managed by Nix. Installing tools via `brew`, `npm -g`, `pip`, `cargo install`, etc., creates untracked state that may conflict with Nix-managed packages.
- `nix-shell -p <package>` is a clean, reproducible, temporary environment with no side effects.

### How

```bash
# Wrong — installs globally, creates untracked state
brew install ripgrep
npm install -g typescript

# Correct — temporary, no side effects
nix-shell -p ripgrep --run "rg <pattern> <path>"
nix-shell -p nodePackages.typescript --run "tsc --version"
```

For interactive use:

```bash
nix-shell -p ripgrep
```

### Before Running Any Install Command

1. Is this tool available via `nix-shell -p <pkg>`? → Use nix-shell.
2. Did the user explicitly request a permanent install? → Ask which Nix module to add it to.
3. No Nix package available? → Inform the user and ask how to proceed.

Never run `brew`, `npm -g`, `pip`, `cargo install`, etc., without explicit user instruction.

## GitHub Resources

Tool priority depends on the kind of access:

1. External repository investigation (understanding a codebase, API, architecture, design) → `deepwiki` MCP first, `gh` CLI as fallback.
2. Specific GitHub resources (issues, PRs, releases, workflow runs, API calls) → `gh` CLI.
3. Never use `WebFetch` for GitHub pages.

### External Repository Investigation: Prefer `deepwiki` MCP

For research-oriented questions about an external GitHub repository — how something works, what an API does, where a feature is implemented — use `deepwiki` first. It indexes the whole repository and answers in one call, which is faster and more thorough than walking the source tree by hand.

Available tools:

- `mcp__deepwiki__read_wiki_structure` — list documentation topics for a repo.
- `mcp__deepwiki__read_wiki_contents` — full documentation for a repo.
- `mcp__deepwiki__ask_question` — AI-powered Q&A about a repo.

Fall back to `gh` CLI when:

- `deepwiki` cannot answer (private repo, very recent change not yet indexed, etc.).
- You need exact current file contents, commit history, or specific GitHub objects.

### GitHub Resources via `gh` CLI

For issues, PRs, releases, workflow runs, raw file contents, and API calls, use `gh` instead of `WebFetch`.

#### Why

GitHub pages use client-side rendering (JavaScript). `WebFetch` fetches raw HTML without executing JavaScript and returns incomplete or empty content. `gh` calls the GitHub API directly and returns complete, structured data.

#### Examples

```bash
# Wrong — JavaScript not executed, content missing
WebFetch("https://github.com/owner/repo/issues/123")

# Wrong — use deepwiki for research questions instead
gh api repos/owner/repo/contents/src/auth.go  # then read 20 files to understand auth

# Correct — research questions via deepwiki
mcp__deepwiki__ask_question(repoName="owner/repo", question="How is authentication implemented?")

# Correct — specific resources via gh
gh issue view 123 --repo owner/repo
gh pr view 456 --repo owner/repo
gh api repos/owner/repo/contents/path/to/file.md
```

Load the `gh-reference` skill for command details when working with GitHub.

## Note: Avoid `find` on `/nix/store`

Searching `/nix/store` with `find` is extremely slow (huge directory tree).
Instead:

- Use `nix eval --raw nixpkgs#<pkg>.src` to resolve a specific store path.
- Use `deepwiki` to research upstream repositories, or `gh api` to read specific source files directly.
