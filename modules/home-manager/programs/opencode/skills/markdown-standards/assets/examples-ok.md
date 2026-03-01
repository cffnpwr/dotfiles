# markdownlint-cli2 rule verification file (OK examples)

This file verifies that all markdownlint-cli2 rules are working correctly.
Run markdownlint-cli2 against this file — no errors should be reported.

## How to run

```bash
SKILL_ASSETS="$HOME/.config/opencode/skills/markdown-standards/assets"
npx markdownlint-cli2 --config "$SKILL_ASSETS/.markdownlint-cli2.yaml" "$SKILL_ASSETS/examples-ok.md"
```

---

## MD001 — Heading levels increment by one

Headings must increment by one level at a time:

```markdown
## Level 2
### Level 3
#### Level 4
```

---

## MD003 — Heading style (ATX)

## This heading uses ATX style

---

## MD004 — Unordered list style (consistent)

- Item A
- Item B
- Item C

---

## MD005 — List indentation consistent

- Item 1
  - Nested item

---

## MD007 — Unordered list indentation (2 spaces)

- Top level
  - Nested with 2 spaces

---

## MD009 — No trailing spaces

This line has no trailing spaces.

---

## MD010 — No hard tabs

```text
This code block uses spaces, not tabs.
```

---

## MD011 — No reversed link syntax

[Correct link](https://example.com)

---

## MD012 — No multiple consecutive blank lines

One blank line between paragraphs.

Another paragraph here.

---

## MD013 — Line length

Short lines are fine.

---

## MD014 — Dollar signs in shell code blocks (no dollar prefix for commands)

```bash
echo "hello"
ls -la
```

---

## MD018 — Space after hash in ATX heading

## Heading with space after hash

---

## MD019 — No multiple spaces after hash

## Single space only

---

## MD022 — Headings surrounded by blank lines

Paragraph before heading.

## This Heading Has Blank Lines Around It

Paragraph after heading.

---

## MD023 — Headings start at column 1

## No indentation on this heading

---

## MD024 — Duplicate headings allowed under different parents

## Parent A

### Parameters

## Parent B

### Parameters

---

## MD025 — Single top-level heading

(This file uses H2 sections intentionally; H1 is used only at the top.)

---

## MD026 — No trailing punctuation in headings

## Heading Without Trailing Punctuation

---

## MD027 — No multiple spaces after blockquote symbol

> Single space after angle bracket.

---

## MD028 — No blank line inside blockquote

> Line one.
> Line two.

---

## MD029 — Ordered list item prefix (ordered)

1. First
2. Second
3. Third

---

## MD030 — Spaces after list markers

- Item with one space after dash

1. Item with one space after number

---

## MD031 — Fenced code blocks surrounded by blank lines

Paragraph before code block.

```text
code here
```

Paragraph after code block.

---

## MD032 — Lists surrounded by blank lines

Paragraph before list.

- Item

Paragraph after list.

---

## MD033 — No inline HTML

Plain text without inline HTML.

---

## MD034 — No bare URLs

Use a link: [https://example.com](https://example.com)

---

## MD035 — Horizontal rule style (consistent dashes)

---

## MD036 — No emphasis used as heading

This is regular emphasized text used *within* a sentence.

---

## MD037 — No spaces inside emphasis markers

Use *italic* and **bold** without spaces inside the markers.

---

## MD038 — No spaces inside code span

`no spaces inside`

---

## MD039 — No spaces inside link brackets

[link text](https://example.com)

---

## MD040 — Fenced code blocks have a language

```bash
echo "language specified"
```

---

## MD041 — First line is a top-level heading

(Satisfied by the H1 at the top of this file.)

---

## MD042 — No empty links

[Link with destination](https://example.com)

---

## MD043 — Required heading structure

(No required structure configured — rule inactive.)

---

## MD044 — Proper names capitalization

(No proper names configured — rule inactive.)

---

## MD045 — Images have alt text with meaningful description

![Screenshot showing the configuration dialog with timeout field](./screenshot.png)

---

## MD046 — Code block style (fenced)

```text
fenced code block
```

---

## MD047 — File ends with a single newline

(Satisfied by the newline at the end of this file.)

---

## MD048 — Code fence style (consistent backticks)

```text
using backtick fences consistently
```

---

## MD049 — Emphasis style (consistent asterisks)

Use *italic* with asterisks and **bold** with double asterisks consistently.

---

## MD050 — Strong style (consistent double asterisks)

Use **double asterisks** for strong emphasis consistently.

---

## MD051 — Link fragments valid

[Jump to MD040](#md040--fenced-code-blocks-have-a-language)

---

## MD052 — Reference links and images use defined labels

[example][ref-label]

[ref-label]: https://example.com

---

## MD053 — Link and image reference definitions used

[used reference][used-ref]

[used-ref]: https://example.com

---

## MD054 — Link and image style (consistent)

[consistent link style](https://example.com)

---

## MD055 — Table pipe style (consistent leading and trailing pipes)

| Column A | Column B |
|----------|----------|
| Value 1  | Value 2  |

---

## MD056 — Table column count consistent

| Col A | Col B |
|-------|-------|
| 1     | 2     |
| 3     | 4     |
