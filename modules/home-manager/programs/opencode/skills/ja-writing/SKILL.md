---
name: ja-writing
description: >
  Japanese writing quality enforcement using textlint static analysis and AI-supplementary rules.
  Use when (1) writing any Japanese prose including documentation, README files, commit messages,
  issue/PR descriptions, or code comments, (2) reviewing existing Japanese text for quality issues,
  (3) running textlint to programmatically check Japanese documents.
  Covers: textlint setup and execution, interpretation of lint results, rules textlint cannot detect
  (false-negative patterns), false-positive handling, and writing style standards.
compatibility: |
  Required: Node.js 22+, pnpm
  Packages: see assets/package.json (textlint + ja-specific rule presets)
---

# Japanese Writing Quality — ja-writing

Enforce Japanese writing quality through textlint static analysis combined with AI-supplementary rules.

## Setup

Copy the config files from this skill's `assets/` directory into your working directory, then install dependencies:

```bash
SKILL_ASSETS="$HOME/.config/opencode/skills/ja-writing/assets"
cp "$SKILL_ASSETS/package.json" ./package.json
cp "$SKILL_ASSETS/.textlintrc.json" ./.textlintrc.json
pnpm install
```

Verify all rules are active with the bundled test file:

```bash
SKILL_ASSETS="$HOME/.config/opencode/skills/ja-writing/assets"
pnpm exec textlint "$SKILL_ASSETS/examples-ng.md"
```

Expect errors on every section — this confirms all rules are active.

## Running textlint

```bash
# Lint a single file
pnpm exec textlint path/to/file.md

# Lint all markdown files recursively
pnpm exec textlint "**/*.md"

# Auto-fix fixable errors
pnpm exec textlint --fix path/to/file.md
```

## Interpreting Results

Each error line shows: `line:col  severity  message  (rule-name)`

Example:

```
3:1  error  1文の長さは100文字以下にしてください (preset-ja-technical-writing/sentence-length)
```

Severity levels:
- `error` — must fix
- `warning` — should review

## Suppressing False Positives

When textlint incorrectly flags valid content (proper nouns, code terms, intentional style):

```markdown
<!-- textlint-disable rule-name -->
False positive content here.
<!-- textlint-enable rule-name -->
```

Or for a single line:

```markdown
Content here. <!-- textlint-disable-line rule-name -->
```

Common false-positive cases:
- Long kanji sequences that are proper nouns (e.g., `日本電信電話株式会社`) — suppress `preset-ja-technical-writing/max-kanji-continuous-len`
- List items that intentionally end with a period — suppress `period-in-list-item`

## Rules textlint Cannot Detect (AI Supplement Required)

The following must be checked manually or by AI, as textlint has no coverage:

### Word-ending prolonged sound mark (語尾の長音符号)

`@textlint-ja/no-synonyms` detects orthographic variants via the Sudachi synonym dictionary. This catches word pairs registered in the dictionary (e.g., `サーバー / サーバ`), but the dictionary does not cover all loanwords.

Always omit the trailing long vowel mark (ー) from loanword endings:

| Wrong | Correct |
|---|---|
| サーバー | サーバ |
| コンピューター | コンピュータ |
| ユーザー | ユーザ |
| フォルダー | フォルダ |
| プリンター | プリンタ |

Rule: drop trailing ー when the word ends in a long vowel sound in Japanese. Apply consistently within a document — use `@textlint-ja/no-synonyms` as a first pass, then manually review remaining loanwords.

### Plain form (常体) consistency

The `.textlintrc.json` configures `no-mix-dearu-desumasu` with `preferInBody: "である"`, but does NOT catch:
- Polite form in code comments
- Polite form inside blockquotes
- Mixed style when a document has no body text (e.g., pure list)

Always use plain form (だ・である):
- Correct: `設定する`, `変更できる`, `動作する`
- Wrong: `設定します`, `変更できます`, `動作します`

### Structural AI-writing patterns not in preset

`@textlint-ja/preset-ai-writing` catches many patterns, but may miss:

- Excessive parenthetical remarks `（〜の場合）` stacked in one sentence
- Overuse of `また、` and `なお、` as paragraph openers

---

## Writing Standards Reference

### Plain Form (常体) Only

Use plain form (だ/である) consistently:
- Correct: である、だ、〜する
- Wrong: です、ます (polite form — never use)

### Sentence Length

Maximum 100 characters per sentence. Break long sentences at natural clause boundaries.

### Punctuation

- Sentence ending: always `。` (full-width period)
- Comma: `、` (full-width reading mark)
- Never use `！` or `？` in technical writing
- No half-width `,` or `.` as Japanese punctuation

### Numbers

- Quantities: use Arabic numerals (`3個`, `100文字`)
- Idioms/fixed expressions: kanji OK (`一石二鳥`, `第一`)
- Thousand separator: `,` (`1,000`)

### Alphabet and Katakana

- Always use half-width ASCII (`API`, `GitHub`)
- Never use full-width alphabet (`ＡＰＩ`)
- Always use full-width katakana (`カタカナ`)
- Never use half-width katakana (`ｶﾀｶﾅ`)

### Spacing

- No space between full-width and half-width characters: `最新のAPI仕様` (not `最新の API 仕様`)
- No space between full-width characters

### Prohibited Grammar

| Pattern | Wrong | Correct |
|---|---|---|
| Double negative | ないわけではない | 肯定表現に書き換える |
| Ra-nuki | 見れる、食べれる | 見られる、食べられる |
| I-nuki | 開発してます | 開発しています |
| Re-tashi (れ足す) | 飲めれない | 飲めない |
| Sa-ire/nuki | 暖かさそう | 暖かそう |
| Single tari | 読んだりする | 読んだり〜したりする |
| Weak expression | かもしれない、と思います | 断定表現、または根拠を示す |
| Redundancy | することができる | できる |
| Consecutive ga | AだがBだが | 接続詞を変える |
| Consecutive conjunction | しかし〜しかし | 接続詞を変える |
