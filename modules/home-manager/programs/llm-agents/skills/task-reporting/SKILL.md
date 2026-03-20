---
name: task-reporting
description: Provides standardized format for reporting completed tasks and implementations. Use when task/feature implementation is complete, user requests summary of changes, or verification steps need to be documented. Ensures clear communication of what changed, why it changed, and how to verify changes. Includes bilingual format (English/Japanese) with absolute paths, code snippets, and actionable verification steps.
compatibility: No external dependencies. Works in all environments.
---

# Task Reporting

Standardized format and guidelines for reporting completed tasks, implementations, and code changes.

## When to Use This Skill

Trigger this skill when:
- A task or feature implementation is completed
- User asks for a summary of changes made
- Need to provide verification steps for changes
- Documenting what was done in a session
- User requests "まとめ" (summary) or "完了報告" (completion report)

## Core Principles

**Three Essential Components:**

1. **What was done** (具体的な変更内容) - Concrete list of changes
2. **Why it was done** (変更理由) - Context and purpose
3. **How to verify** (検証方法) - Actionable verification steps

**Quality Standards:**
- Use **absolute paths** for all file references
- Include relevant code snippets showing key changes
- Provide specific verification commands
- Reference original user request for context
- Be concise but comprehensive

## Standard Format

### Template Structure

```markdown
## 完了しました

### 変更内容
- `/absolute/path/to/file1.ts:42` - [Brief description of change]
- `/absolute/path/to/file2.py:108` - [Brief description of change]

### 変更箇所
[Code snippet showing key changes]

### 変更理由
[Reference to user request and explanation of problem solved]

### 検証方法
[Commands to run tests or verify behavior]

期待される動作: [Expected behavior after changes]
```

### Complete Example

```markdown
## 完了しました

### 変更内容
- `/Users/project/src/auth/login.ts:45` - エラーハンドリングを追加
- `/Users/project/src/auth/login.test.ts:23` - エラーケースのテストを追加

### 変更箇所
```typescript
// /Users/project/src/auth/login.ts:45
try {
  const response = await api.login(credentials);
  return response;
} catch (error) {
  throw new Error('Login failed: ' + error.message);
}
```

### 変更理由
ユーザーからのリクエスト: "ログイン失敗時にわかりやすいエラーメッセージを表示したい"

現在の問題: ログイン失敗時に生のAPIエラーが表示され、ユーザーにとって理解しにくい
解決方法: try-catchでエラーをキャッチし、ユーザーフレンドリーなメッセージに変換

### 検証方法
```bash
npm test
```

期待される動作: ログイン失敗時に「Login failed: Invalid credentials」のようなユーザーフレンドリーなエラーメッセージが表示される
```

## Required Elements

### 1. File References with Absolute Paths

**Always use absolute paths:**
```
✅ CORRECT: `/Users/opm008368/project/src/app.ts:42`
❌ WRONG: `./src/app.ts:42`
❌ WRONG: `src/app.ts:42`
```

**Format:** `/absolute/path/to/file.ext:line_number` - Description

### 2. Code Snippets

**Show key changes with context:**
- Include enough surrounding code for clarity
- Use proper syntax highlighting (language tags)
- Add file path and line number in comments
- Show before/after if relevant to understanding

**Example:**
```typescript
// /absolute/path/to/file.ts:45-52
async function processData(input: string): Promise<Result> {
  // Validate input before processing
  if (!input || input.trim().length === 0) {
    throw new Error('Input cannot be empty');
  }
  return await process(input);
}
```

### 3. Change Context (Why)

**Include:**
- Original user request (direct quote or paraphrase)
- Problem being solved
- Approach taken and reasoning

**Example:**
```
ユーザーリクエスト: "空の入力を処理する際にエラーが発生する"
問題: input validationが不足していた
解決: processData関数の先頭でinput validationを追加
```

### 4. Verification Steps

**Provide specific commands:**
```bash
# Run tests
npm test

# Or specific test file
npm test src/auth/login.test.ts

# Manual verification
npm run dev
# Then navigate to http://localhost:3000/login and test login flow
```

**Describe expected behavior:**
```
期待される動作:
- 空の入力では "Input cannot be empty" エラーが表示される
- 有効な入力では正常に処理が完了する
- すべてのテストがパスする
```

## Anti-Patterns to Avoid

**❌ Vague statements:**
- "All done"
- "Finished the task"
- "Changes have been made"

**❌ Relative paths:**
- `./src/file.ts`
- `../components/Button.tsx`

**❌ Missing context:**
- Not explaining why changes were made
- Not referencing original request

**❌ No verification:**
- Not providing test commands
- Not describing expected behavior
- No way for user to confirm changes work

## Bilingual Considerations

**Use Japanese for user-facing headers and descriptions:**
- 完了しました (Completed)
- 変更内容 (Changes made)
- 変更箇所 (Changed code)
- 変更理由 (Reason for change)
- 検証方法 (How to verify)
- 期待される動作 (Expected behavior)

**Use English for:**
- Code comments
- Technical terms where appropriate
- Commands and code snippets

## Multiple Files Pattern

**When many files changed, group by category:**

```markdown
### 変更内容

**Authentication システム:**
- `/path/to/auth/login.ts:45` - エラーハンドリング追加
- `/path/to/auth/logout.ts:23` - セッションクリーンアップ改善

**Tests:**
- `/path/to/auth/login.test.ts:12` - エラーケーステスト追加
- `/path/to/auth/logout.test.ts:34` - セッションテスト追加

**Configuration:**
- `/path/to/config/auth.config.ts:5` - タイムアウト設定追加
```

## Large Change Pattern

**For major refactoring or features:**

```markdown
## 完了しました

### 変更概要
認証システムの全面的なリファクタリングを完了しました。

### 主な変更内容
1. **Authentication Flow** - トークンベース認証に移行
2. **Error Handling** - 統一されたエラーハンドリングを実装
3. **Testing** - カバレッジを85%に向上

### 変更ファイル (10 files)
詳細は以下の主要ファイルを参照:
- `/path/to/auth/AuthService.ts:1` - 新しい認証サービス実装
- `/path/to/auth/TokenManager.ts:1` - トークン管理機能
- [他8ファイル - 完全なリストは git diff で確認可能]

### 変更理由
[Explanation of why this refactor was needed]

### 検証方法
```bash
npm run test:auth
npm run test:integration
```

期待される動作:
- すべての認証テストがパス
- 既存の認証フローが正常に動作
- 新しいトークンベース認証が利用可能
```

## Workflow

1. **Identify completion** - Task is done, ready to report
2. **Gather information:**
   - List all changed files with absolute paths
   - Identify key code changes to highlight
   - Review original user request
   - Determine verification steps
3. **Format report** using standard template
4. **Include code snippets** for key changes
5. **Provide verification** with specific commands and expected results

## Summary

**Always provide when task completes:**
- ✅ What changed (absolute paths + descriptions)
- ✅ Code snippets showing key changes
- ✅ Why changes were made (original request context)
- ✅ How to verify (commands + expected behavior)

**Never:**
- ❌ Use relative paths
- ❌ Provide vague "all done" messages
- ❌ Skip verification steps
- ❌ Omit context about why changes were made
