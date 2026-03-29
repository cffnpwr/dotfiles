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
  Required: Node.js 22+, pnpm (or Nix for auto-provisioning via nix-shell)
  Packages: see assets/package.json (textlint + ja-specific rule presets)
  Note: assets/ is inside the Nix store (read-only) — do not run pnpm install against it directly
---

# Japanese Writing Quality — ja-writing

Enforce Japanese writing quality through textlint static analysis combined with AI-supplementary rules.

## Setup

### Step 1 — Determine how to run pnpm

Check runtime availability in this order:

1. **pnpm and node are available in PATH** — use them directly (proceed to Step 2)
2. **pnpm/node not found, `nix` command is available** — use `nix-shell` for a temporary environment.
   Prepend all pnpm commands with:
   ```bash
   nix-shell -p nodejs pnpm --run "<command>"
   ```
   Also note: in Nix-managed environments `assets/` is inside the Nix store and **read-only** —
   proceed to the Nix-specific install instructions below.
3. **pnpm/node not found, Nix not available** — report to the user that Node.js 22+ and pnpm are
   required and cannot be installed automatically in this environment

### Step 2 — Install dependencies

**Normal environment** (assets/ is writable):

```bash
SKILL_ASSETS="$HOME/.claude/skills/ja-writing/assets"
pnpm install --dir "$SKILL_ASSETS"
```

**Nix environment** (assets/ is read-only — copy to a writable cache directory first):

```bash
SKILL_ASSETS="$HOME/.claude/skills/ja-writing/assets"
WORK_DIR="$HOME/.cache/ja-writing-linter"
mkdir -p "$WORK_DIR"
cp "$SKILL_ASSETS/package.json" "$SKILL_ASSETS/pnpm-lock.yaml" "$WORK_DIR/"
nix-shell -p nodejs pnpm --run "pnpm install --dir \"$WORK_DIR\""
```

After installing, set `WORK_DIR` to the directory that contains `node_modules/`:

- Normal: `WORK_DIR="$SKILL_ASSETS"`
- Nix: `WORK_DIR="$HOME/.cache/ja-writing-linter"`

### Step 3 — Verify installation

```bash
SKILL_ASSETS="$HOME/.claude/skills/ja-writing/assets"
# WORK_DIR set as above
pnpm --dir "$WORK_DIR" exec textlint --config "$SKILL_ASSETS/.textlintrc.json" "$SKILL_ASSETS/examples-ng.md"
```

Expect errors on every section — this confirms all rules are active.

## Running textlint

Use `SKILL_ASSETS` and `WORK_DIR` as set during Setup.

```bash
# Lint a single file
pnpm --dir "$WORK_DIR" exec textlint --config "$SKILL_ASSETS/.textlintrc.json" /absolute/path/to/file.md

# Lint all markdown files recursively
pnpm --dir "$WORK_DIR" exec textlint --config "$SKILL_ASSETS/.textlintrc.json" "**/*.md"

# Auto-fix fixable errors
pnpm --dir "$WORK_DIR" exec textlint --fix --config "$SKILL_ASSETS/.textlintrc.json" /absolute/path/to/file.md
```

In Nix environment, wrap with nix-shell:

```bash
nix-shell -p nodejs pnpm --run \
  "pnpm --dir \"$WORK_DIR\" exec textlint --config \"$SKILL_ASSETS/.textlintrc.json\" /absolute/path/to/file.md"
```

> **Hint for Markdown files**: When linting `.md` files, also run `markdownlint` to catch structural
> Markdown issues (heading levels, list formatting, etc.) that textlint does not cover. See the
> `markdown-standards` skill for details.

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

| Wrong          | Correct      |
| -------------- | ------------ |
| サーバー       | サーバ       |
| コンピューター | コンピュータ |
| ユーザー       | ユーザ       |
| フォルダー     | フォルダ     |
| プリンター     | プリンタ     |

Rule: drop trailing ー when the word ends in a long vowel sound in Japanese. Apply consistently within a document — use `@textlint-ja/no-synonyms` as a first pass, then manually review remaining loanwords.

### Style consistency (文体統一)

The `.textlintrc.json` configures `no-mix-dearu-desumasu` to detect mixing of plain and polite form within
a document. It does NOT catch:

- Style mix in code comments
- Style mix inside blockquotes
- Mixed style when a document has no body text (e.g., pure list)

Either style is acceptable — choose one and apply it consistently throughout the document:

- Plain form (常体): `設定する`, `変更できる`, `動作する`
- Polite form (敬体): `設定します`, `変更できます`, `動作します`

Typical conventions: READMEs and user-facing documents often use polite form; technical specs and
internal docs typically use plain form.

### Structural AI-writing patterns not in preset

`@textlint-ja/preset-ai-writing` catches many patterns, but may miss:

- Excessive parenthetical remarks `（〜の場合）` stacked in one sentence
- Overuse of `また、` and `なお、` as paragraph openers

---

## Writing Standards Reference

### Writing Style (文体)

Choose either plain form (常体) or polite form (敬体) and apply it consistently throughout the document.
Mixing styles within a document is prohibited.

- Plain form (常体): である、だ、〜する — typical for technical specs, internal docs
- Polite form (敬体): です、ます — typical for READMEs, user-facing documentation

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

| Pattern                 | Wrong                    | Correct                    |
| ----------------------- | ------------------------ | -------------------------- |
| Double negative         | ないわけではない         | 肯定表現に書き換える       |
| Ra-nuki                 | 見れる、食べれる         | 見られる、食べられる       |
| I-nuki                  | 開発してます             | 開発しています             |
| Re-tashi (れ足す)       | 飲めれない               | 飲めない                   |
| Sa-ire/nuki             | 暖かさそう               | 暖かそう                   |
| Single tari             | 読んだりする             | 読んだり〜したりする       |
| Weak expression         | かもしれない、と思います | 断定表現、または根拠を示す |
| Redundancy              | することができる         | できる                     |
| Consecutive ga          | AだがBだが               | 接続詞を変える             |
| Consecutive conjunction | しかし〜しかし           | 接続詞を変える             |
