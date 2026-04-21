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

## GitHub Resources: Use `gh` CLI

When accessing any GitHub resource (issues, PRs, repos, releases, API calls), use `gh` instead of `WebFetch`.

### Why

GitHub pages use client-side rendering (JavaScript). `WebFetch` fetches raw HTML without executing JavaScript and returns incomplete or empty content. `gh` calls the GitHub API directly and returns complete, structured data.

### Examples

```bash
# Wrong — JavaScript not executed, content missing
WebFetch("https://github.com/owner/repo/issues/123")

# Correct — direct API access
gh issue view 123 --repo owner/repo
gh pr view 456 --repo owner/repo
gh api repos/owner/repo/contents/path/to/file.md
```

Load the `gh-reference` skill for command details when working with GitHub.

## Note: Avoid `find` on `/nix/store`

Searching `/nix/store` with `find` is extremely slow (huge directory tree).
Instead:

- Use `nix eval --raw nixpkgs#<pkg>.src` to resolve a specific store path.
- Use `gh api` to read source files from upstream repositories directly.
