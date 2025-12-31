---
name: writing-japanese-documents
description: Comprehensive Japanese document quality standards based on all textlint-ja presets (ai-writing, ja-technical-writing, JTF-style, japanese, ja-spacing) and additional rules. Use when writing any Japanese text content including documentation, technical writing, README files, commit messages, issue descriptions, pull request descriptions, comments, or any other Japanese prose. Enforces plain form (常体), proper grammar, no word-ending prolonged sound marks (長音符号), consistent character usage, appropriate spacing, and natural expression patterns.
---

# Japanese Document Writing Standards

## Overview

Apply comprehensive Japanese writing standards based on all textlint-ja presets and community rules. These standards ensure clarity, consistency, natural expression, and professional quality in all Japanese text.

## Core Writing Principles

### Text Emphasis (ai-writing)

NEVER use bold, italic, or underline formatting in normal writing:

- Bold (**太字**), italic (*斜体*), underline are special emphasis tools reserved for critical information only
- NEVER use them for headings, element names, list items, or routine text
- Mechanical emphasis patterns (e.g., **重要**, ✅, ❌) indicate AI-generated text

### Emojis (ai-writing)

NEVER use emojis in professional writing:

- Professional documents do not contain emojis
- Use clear, descriptive text instead
- Emoji usage is a hallmark of AI-generated content

### Hype and Exaggeration (ai-writing)

Avoid exaggerated or hyperbolic expressions:

- ❌ 革命的な、ゲームチェンジャー、完全に解決
- ✅ Use measured, factual language
- Avoid overly enthusiastic marketing-style language

### Colon Continuation Pattern (ai-writing)

Avoid English-style structural patterns:

- ❌ 述語で終わる文：（colon followed by block elements）
- ✅ Use natural Japanese structure without colons for continuation

## Writing Style

### Plain Form (常体) Only

Use plain form (だ/である) consistently throughout:

- ✅ である、だ、～する
- ❌ NEVER use polite form (敬体: です/ます)
- ❌ NEVER mix plain and polite forms

### Headings

Use plain form or noun endings (体言止め) for headings:

- ✅ 設定方法
- ✅ インストール手順
- ❌ 設定します

## Sentence Structure

### Length Limits (ja-technical-writing, japanese)

Limit sentence length for readability:

- Maximum 100 characters per sentence
- Break long sentences into multiple shorter ones

### Punctuation Density (ja-technical-writing, japanese)

Limit punctuation marks per sentence:

- Maximum 3 reading marks (、) per sentence
- Excessive punctuation indicates overly complex sentences

### Kanji Density (ja-technical-writing)

Avoid consecutive kanji characters:

- Maximum 6 consecutive kanji characters
- Insert hiragana or punctuation to break up long kanji sequences
- Example: ❌ 提供利用規約同意確認 → ✅ 提供する利用規約への同意確認

### Sentence Endings (ja-technical-writing, JTF-style)

Use consistent sentence endings:

- Always end sentences with periods (。)
- Use full-width period (。) not half-width (.)
- NEVER use exclamation marks (！) or question marks (？) in technical writing
- Exception: Direct quotations may retain original punctuation

## Grammar and Expression Quality

### Prohibited Patterns (japanese, ja-technical-writing)

NEVER use these grammatical patterns:

**Double negatives (二重否定):**

- ❌ ないわけではない、なくはない
- ✅ Use affirmative expressions

**Ra-nuki expressions (ら抜き言葉):**

- ❌ 見れる、食べれる、来れる
- ✅ 見られる、食べられる、来られる

**Consecutive adversative が:**

- ❌ AだがBだがC
- ✅ Restructure with varied conjunctions

**Repeated conjunctions:**

- ❌ しかし...しかし...
- ✅ Use varied transitions (ただし、一方で、etc.)

**Repeated particles (助詞の重複):**

- ❌ 彼は本を買って本を読んだ
- ✅ 彼は本を買って読んだ
- Check for consecutive use of same particle within a sentence

### Tari-Tari Pattern (prefer-tari-tari)

Use parallel たり...たり expressions correctly:

- ✅ 本を読んだり、音楽を聴いたりする
- ❌ 本を読んだりする (single たり without pair)

### Weak Expressions (ja-technical-writing)

Avoid uncertain or weak expressions:

- ❌ かもしれない (might be)
- ❌ だろう (probably)
- ✅ Use definitive statements or qualify uncertainty explicitly

### Redundancy (ja-technical-writing)

Eliminate redundant expressions:

- ❌ 約10分程度
- ✅ 約10分 or 10分程度
- Check for word duplication and unnecessary repetition

### Common Misusage (ja-no-abusage)

Avoid common Japanese errors:

- ❌ 適応する (when meaning "apply") → ✅ 適用する
- ❌ 値を返却する → ✅ 値を返す
- ❌ 例外を補足する → ✅ 例外を捕捉する
- Check morphological correctness

### Word Synonyms and Consistency (no-synonyms)

Use consistent terminology without variation:

- ❌ Mixing サーバー and サーバ in same document
- ✅ Choose one form and use consistently
- **Prolonged sound mark rule**: NEVER use prolonged sound marks (長音符号) at word endings
  - ❌ サーバー、コンピューター、ユーザー
  - ✅ サーバ、コンピュータ、ユーザ

## Character and Symbol Standards (JTF-style)

### Punctuation Marks

Use full-width Japanese punctuation:

- ✅ 句読点: 、(comma) and 。(period)
- ❌ NEVER use half-width ., (period and comma)

### Numbers

Use half-width Arabic numerals:

- ✅ 123, 456
- ❌ １２３ (full-width)
- ❌ 一二三 (kanji for quantities)

**Kanji numbers allowed for:**

- Idioms: 一石二鳥
- Formal expressions: 第一、一つ
- Quantities with specific counters following JTF guidelines

**Number formatting:**

- Thousand separators: Use comma (123,456)
- Decimal point: Use period (3.14)

### Alphabetic Characters

Use half-width alphabetic characters:

- ✅ ASCII, API, GitHub
- ❌ ＡＳＣＩＩ (full-width)

### Prohibited Characters (japanese, ja-technical-writing)

NEVER use these character types:

- Half-width katakana (ｶﾀｶﾅ) → Use full-width (カタカナ)
- NFD UTF8-MAC濁点 → Use normal combining characters
- Invalid control characters
- Zero-width spaces
- Kangxi radicals

### Brackets and Parentheses (JTF-style, ja-spacing)

Use appropriate bracket styles:

- 丸括弧 (parentheses): （）for supplementary information
- かぎ括弧 (corner brackets): 「」for quotations
- 二重かぎ括弧 (double corner brackets): 『』for nested quotations or titles

NO spaces around brackets:

- ✅ 例（サンプル）です
- ❌ 例 （サンプル） です

## Spacing Rules (ja-spacing)

### Between Full-width and Half-width Characters

NO spaces between full-width and half-width characters:

- ✅ 最新のAPI仕様
- ❌ 最新の API 仕様
- ❌ 最新の API 仕様 (multiple spaces)

### Between Full-width Characters

NO spaces between full-width characters:

- ✅ 日本語文書作成
- ❌ 日本語　文書　作成

### Katakana Word Separation

Use middle dot (・) or half-width space between katakana words:

- ✅ ソフトウェア・エンジニアリング
- ✅ ソフトウェア エンジニアリング
- Choose one style and use consistently

### Around Exclamation and Question Marks

If using exclamation (！) or question marks (？) in non-technical writing:

- Insert full-width space after mark when another sentence follows
- ✅ 本当か！　次の文が続く
- Not applicable to technical writing (these marks are prohibited)

### Around Inline Code (Optional)

For technical documentation with inline code:

- Configure spacing preference around `code` blocks
- Default: Follow the spacing rules for half-width characters (no space)

### Around Links (Optional)

For documents with hyperlinks:

- Configure spacing preference around [links]
- Default: Follow the spacing rules for text content

## List Formatting

Use natural list formatting:

- NO mechanical emphasis in list items
- NO emoji markers (✅, ❌, ⭐)
- Use plain text bullet points or numbered lists
- Each item should use consistent grammar and style

## Application Guidelines

Apply these standards to all Japanese writing:

- Technical documentation
- README files and project documentation
- Git commit messages
- Issue and pull request descriptions
- Code comments in Japanese
- User-facing text and UI copy
- Email and business communication

When editing existing text, apply all applicable rules while preserving the intended meaning. Prioritize natural Japanese expression over mechanical patterns.
