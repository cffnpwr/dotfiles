# Git Guidelines

## Git Commit Guidelines

YOU MUST: Follow Conventional Commits standards with the following specific
format:

### Commit Message Format

```text
<type> <emoji>: <commit message>
```

### Commit Types

YOU MUST: Choose from the following types:

- **build**: Changes that affect the build system or external dependencies
  (example scopes: gulp, broccoli, npm)
- **ci**: Changes to CI configuration files and scripts
  (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: Documentation only changes
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the meaning of the code
  (white-space, formatting, missing semi-colons, etc)
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

## Git Operations Guidelines

YOU MUST: Use Git MCP server tools for all Git operations when available

YOU MUST: Only use command line Git operations for functions not supported
by the Git MCP server

YOU MUST: Prioritize Git MCP server tools over bash commands for Git
operations

Examples of preferred approach:

- Use `mcp__git__git_status` instead of `git status`
- Use `mcp__git__git_diff` instead of `git diff`
- Use `mcp__git__git_commit` instead of `git commit`
- Use `mcp__git__git_add` instead of `git add`
