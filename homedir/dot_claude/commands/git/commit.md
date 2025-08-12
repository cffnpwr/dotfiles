# Git Commit (Sub Agent Powered)

## 3-Phase Workflow Architecture

This command executes a 3-phase workflow using specialized Sub Agents:

### Phase 1: Commit Planning (Planning Sub Agent)

### Phase 2: User Confirmation (Main Agent)

### Phase 3: Commit Execution (Execution Sub Agent)

## Execution Workflow

Execute the following 3-phase process:

### Phase 1: Commit Planning

**STEP 1**: Call Planning Sub Agent for commit analysis and strategy planning

```text
Use Task tool to invoke git-commit-planner Sub Agent:
- Execute comprehensive analysis of current Git state
- Logical classification of changes and commit granularity determination
- Generate Conventional Commits compliant messages
- Output commit plan in JSON format
```

**Planning Agent Instructions:**

- Execute detailed analysis of Git status and diff
- Classify changes into logical units
- Generate appropriate messages for each commit
- Clarify rationale for commit separation
- Provide analysis results in Japanese

### Phase 2: User Confirmation Phase

**STEP 2**: Present commit plan returned from Planning Sub Agent to user

YOU MUST: Display the plan in Japanese using the following format:

```text
## コミット計画の確認

Planning Sub Agentが以下のコミット戦略を提案しました:

### 分析結果:
[Agent-provided analysis summary]

### 提案されたコミット:

**コミット1**: [type] [emoji]: [message]
- ファイル: [file list]
- 根拠: [rationale]

**コミット2**: [type] [emoji]: [message]
- ファイル: [file list]
- 根拠: [rationale]

[Continue for additional commits...]

### 確認事項:
この計画を承認して実行を開始しますか？
- [y] はい、この計画でコミットを実行
- [n] いいえ、計画を見直す
- [m] 計画を修正したい
```

**STEP 3**: Obtain explicit user approval

- Do not proceed to next phase until approval is received
- Re-request Planning Agent if modification is requested
- Abort process if rejected

### Phase 3: Commit Execution Phase

**STEP 4**: After user approval, execute commits sequentially with Execution Sub Agent

```text
For each commit in the approved commit plan:
1. Call git-commit-executor Sub Agent using Task tool
2. Pass single commit information for execution
3. Confirm execution results and proceed to next commit
4. Repeat until all commits are completed
```

**Execution Agent Instructions:**

- Precise staging of specified files
- Execute GPG-signed commits
- Immediate verification of commit signatures
- Report execution status in Japanese
- Proper handling of errors

**STEP 5**: Final verification and result reporting

- Verify signatures of all commits
- Confirm created commits
- Report completion status in Japanese

## Commit Message Format

YOU MUST: Follow Conventional Commits standards with this specific format:

```text
<type> <emoji>: <commit message>
```

## Commit Signing

YOU MUST: Sign all commits with GPG when creating commits
YOU MUST: Always use `git commit -S` command via Bash tool for GPG signing
YOU MUST: Use `git add` via Bash tool to stage files before committing
YOU MUST: Verify that commit signing is properly configured before proceeding
YOU MUST: Check that each commit shows GPG signature verification after creation using `git log --show-signature -1`

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

### ✅ Good Commit Examples

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

### 💡 Smart Bundling Examples

**Feature with Supporting Changes:**

- Feature implementation + related config + documentation
- Component + its styles + tests
- API endpoint + validation + error handling

**Avoid These Combinations:**

- Multiple unrelated features
- Bug fix + new feature
- Large refactoring + new functionality

## Commit Analysis Template

**MANDATORY USAGE**: Use this template for EVERY commit analysis (ALWAYS IN JAPANESE):

```text
## コミット分析レポート

### 変更ファイル:
[変更されたファイルを修正タイプと共にリスト]

### 変更分類:
- **タイプ1の変更**: [タイプ/機能別に関連する変更をグループ化]
- **タイプ2の変更**: [その他のタイプの変更をリスト]
- **無関係な変更**: [独立した変更を識別]

### 提案するコミット戦略:

**コミット1**: [説明]
- ファイル: [このコミットに含むファイルのリスト]
- 提案メッセージ: `[type] [emoji]: [日本語コミットメッセージ]`
- 根拠: [これらの変更が一緒にある理由]

**コミット2**: [説明]
- ファイル: [このコミットに含むファイルのリスト]
- 提案メッセージ: `[type] [emoji]: [日本語コミットメッセージ]`
- 根拠: [これらの変更が一緒にある理由]

[追加のコミットがある場合は続ける...]

### 分離の根拠:
[変更をこのように分割する理由を説明]

### ユーザー確認が必要:
このコミット分離戦略を承認しますか？続行前に確認をお願いします。
```

**ENFORCEMENT**: All commit analysis must use this exact template format (always in Japanese)

## Examples

- `feat ✨: ログイン機能の実装`
- `fix 🐛: データベース接続エラーの修正`
- `docs 📚: README.mdの更新`
- `refactor ♻️: ユーザー認証ロジックのリファクタリング`
