# Git Commit

YOU MUST: Follow the Git guidelines defined in @../../instructions/git.md

YOU MUST: Use Git MCP server tools for all Git operations when available.

YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server.

Execute the following workflow:

1. Check current git status and staged changes using git_status
2. Review changes with git_diff (both staged and unstaged)
3. Create commit using git_commit with proper Conventional Commits format and Japanese message
4. Verify commit was created successfully

## Commit Message Format

YOU MUST: Follow Conventional Commits standards with this specific format:

```text
<type> <emoji>: <commit message>
```

## Commit Types

YOU MUST: Choose from the following types:

- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **docs**: Documentation only changes
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the meaning of the code
- **test**: Adding missing tests or correcting existing tests

## Commit Message Guidelines

YOU MUST: Write commit messages on a single line without line breaks
YOU MUST: Write commit messages concisely and descriptively
YOU MUST: Use noun-ending form (体言止め) in Japanese
YOU MUST: Clearly indicate what was changed or implemented

## Commit Granularity Guidelines

YOU MUST: Make atomic commits - one logical change per commit
YOU MUST: Separate different types of changes into different commits
NEVER: Mix features and bug fixes in a single commit
NEVER: Combine multiple unrelated changes in one commit

Examples of proper commit separation:
- **Wrong**: `feat ✨: ログイン機能の追加とパスワードバリデーションのバグ修正`
- **Correct**:
  - `feat ✨: ログイン機能の追加`
  - `fix 🐛: パスワードバリデーションのバグ修正`

YOU MUST: For large features, break down into smaller, logical commits:
- **Wrong**: `feat ✨: ユーザー管理システム全体の実装`
- **Correct**:
  - `feat ✨: ユーザー登録機能の実装`
  - `feat ✨: ユーザー認証機能の実装`
  - `feat ✨: ユーザープロフィール管理機能の実装`

## Examples

- `feat ✨: ログイン機能の実装`
- `fix 🐛: データベース接続エラーの修正`
- `docs 📚: README.mdの更新`
- `refactor ♻️: ユーザー認証ロジックのリファクタリング`
