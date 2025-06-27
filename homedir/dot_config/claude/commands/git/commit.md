# Git Commit

## Commit Quality Guidelines

**Commit Granularity Guidelines:**

YOU SHOULD: Create logical, coherent commits that represent complete units of work

AVOID: Mixing unrelated changes in a single commit

**Smart Granularity Rules:**
- Related changes that work together can be in the same commit
- Configuration changes supporting a feature can be included with the feature
- Documentation updates for a feature can be included with the feature
- Small formatting/style fixes can be bundled with related functional changes

**When to Consider Splitting Commits:**
- Truly unrelated changes (different features/bugs)
- Large refactoring mixed with new features
- Changes that affect completely different parts of the system

YOU MUST: Follow the Git guidelines defined in @../../instructions/git.md

YOU MUST: Use Git MCP server tools for all Git operations when available.

YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server.

Execute the following workflow:

1. **Status Check**: Check current git status and staged changes using git_status
2. **Change Review**: Review changes with git_diff (both staged and unstaged)
3. **Commit Confirmation**: Present commit summary:
   - **Target Branch**: Show the current branch name
   - **Files to be committed**: List all staged files with their status
   - **Proposed commit message**: Show the commit message that will be used
4. **User Confirmation**: Ask user to confirm before proceeding with the commit
5. Create commit using git_commit with proper Conventional Commits format and Japanese message
6. Verify commit was created successfully

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

## Best Practice Examples

### ✅ Good Commit Examples:

**Complete Feature Implementation:**
- `feat ✨: ログイン機能の実装` (includes form, validation, API)
- `feat ✨: ユーザープロフィール機能の追加` (includes UI, backend, tests)

**Bug Fixes:**
- `fix 🐛: パスワードバリデーションエラーの修正`
- `fix 🐛: データベース接続タイムアウトの解決`

**Refactoring:**
- `refactor ♻️: 認証ロジックの整理`
- `refactor ♻️: コンポーネント構造の改善`

**Configuration and Documentation:**
- `chore 🔧: 環境設定の更新`
- `docs 📚: API仕様書の追加`

### 💡 Smart Bundling Examples:

**Feature with Supporting Changes:**
- Feature implementation + related config + documentation
- Component + its styles + tests
- API endpoint + validation + error handling

**Avoid These Combinations:**
- Multiple unrelated features
- Bug fix + new feature  
- Large refactoring + new functionality

## Examples

- `feat ✨: ログイン機能の実装`
- `fix 🐛: データベース接続エラーの修正`
- `docs 📚: README.mdの更新`
- `refactor ♻️: ユーザー認証ロジックのリファクタリング`
