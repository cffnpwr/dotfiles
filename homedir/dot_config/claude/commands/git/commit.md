# Git Commit

## Commit Quality Guidelines

**CRITICAL COMMIT GRANULARITY ENFORCEMENT:**

🚨 **ABSOLUTE REQUIREMENTS:**

YOU MUST: Apply the commit granularity rules from @../../instructions/git.md WITHOUT EXCEPTION
YOU MUST: NEVER create a commit without first analyzing ALL changes for proper separation
YOU MUST: ALWAYS propose commit separation strategy before creating any commits
YOU MUST: Get explicit user approval for multi-commit strategies

**ZERO-TOLERANCE VIOLATIONS:**

NEVER: Create commits with mixed unrelated changes
NEVER: Skip the mandatory commit analysis phase
NEVER: Bundle different types of changes (feature + bugfix, config + feature)
NEVER: Create commits without user confirmation of the separation strategy

**MANDATORY PRE-COMMIT ANALYSIS:**

Before ANY commit creation, you MUST:

1. **Exhaustive Change Analysis**: Review every single file change
2. **Logical Grouping**: Identify natural commit boundaries
3. **Separation Proposal**: Clearly propose how to split changes
4. **User Consultation**: Present the strategy and get explicit approval
5. **Sequential Execution**: Create commits one by one with verification

**COMMIT SEPARATION DECISION TREE:**

For EACH changed file, ask:
- Does this change belong to the same logical unit as other changes?
- Could this change be deployed independently?
- Does this solve the same problem or implement the same feature?
- Would reviewing this change separately make sense?

If ANY answer is "no" → SEPARATE COMMIT REQUIRED

YOU MUST: Follow the Git guidelines defined in @../../instructions/git.md

YOU MUST: Use Git MCP server tools for all Git operations when available.

YOU MUST: Only use command line Git operations for functions not supported by the Git MCP server.

Execute the following workflow:

1. **Status Check**: Check current git status and staged changes using git_status
2. **Change Review**: Review changes with git_diff (both staged and unstaged)
3. **MANDATORY COMMIT ANALYSIS**: Analyze all changes and identify logical commit units
   - **Change Classification**: Categorize each change by type (feature, fix, refactor, etc.)
   - **Component Analysis**: Identify which components/modules are affected
   - **Dependency Analysis**: Determine if changes are related or independent
   - **Commit Unit Proposal**: Propose how to split changes into separate commits
4. **Commit Strategy Confirmation**: Present commit separation strategy:
   - **Number of commits**: How many commits will be created
   - **Commit breakdown**: List what changes go into each commit
   - **Commit order**: The sequence of commits to be created
   - **Rationale**: Explain why changes are grouped or separated
5. **User Approval**: Get explicit user confirmation for the commit strategy
6. **Sequential Commit Creation**: Create commits one by one using git_commit
7. **Verification**: Verify each commit was created successfully

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

## Commit Analysis Template

**MANDATORY USAGE**: Use this template for EVERY commit analysis:

```
## Commit Analysis Report

### Files Changed:
[List all changed files with their modification type]

### Change Classification:
- **Type 1 Changes**: [Group related changes by type/feature]
- **Type 2 Changes**: [List other types of changes]
- **Unrelated Changes**: [Identify independent changes]

### Proposed Commit Strategy:

**Commit 1**: [Description]
- Files: [List files for this commit]
- Proposed message: `[type] [emoji]: [Japanese commit message]`
- Rationale: [Why these changes belong together]

**Commit 2**: [Description]  
- Files: [List files for this commit]
- Proposed message: `[type] [emoji]: [Japanese commit message]`
- Rationale: [Why these changes belong together]

[Continue for additional commits...]

### Separation Rationale:
[Explain why changes are split this way]

### User Confirmation Required:
Do you approve this commit separation strategy? Please confirm before proceeding.
```

**ENFORCEMENT**: You MUST use this exact template format for every commit analysis

## Examples

- `feat ✨: ログイン機能の実装`
- `fix 🐛: データベース接続エラーの修正`
- `docs 📚: README.mdの更新`
- `refactor ♻️: ユーザー認証ロジックのリファクタリング`
