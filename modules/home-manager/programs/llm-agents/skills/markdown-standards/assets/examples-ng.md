# markdownlint-cli2 rule verification file (NG examples)

This file verifies that all markdownlint-cli2 rules are working correctly.
Run markdownlint-cli2 against this file — errors should be reported for each NG section.

## How to run

```bash
SKILL_ASSETS="$HOME/.config/opencode/skills/markdown-standards/assets"
npx markdownlint-cli2 --config "$SKILL_ASSETS/.markdownlint-cli2.yaml" "$SKILL_ASSETS/examples-ng.md"
```

Expect errors on every NG section — this confirms all rules are active.

---

## MD001 — Heading levels increment by one

NG example (skips from H2 to H4):

## Level 2

#### Level 4 (skipped level 3)

---

## MD003 — Heading style (ATX)

NG example (setext-style heading):

Setext Heading
--------------

---

## MD004 — Unordered list style (consistent)

NG example (mixed markers):

- Item with dash
* Item with asterisk
+ Item with plus

---

## MD007 — Unordered list indentation (2 spaces)

NG example (4-space indentation):

- Top level
    - Nested with 4 spaces (should be 2)

---

## MD009 — No trailing spaces

NG example (trailing spaces at end of line):

This line has trailing spaces.   

---

## MD011 — No reversed link syntax

NG example (reversed link syntax):

(Reversed link)[https://example.com]

---

## MD012 — No multiple consecutive blank lines

NG example (two consecutive blank lines):

Paragraph.



Another paragraph.

---

## MD013 — Line length

NG example (line exceeds 80 characters default):

This is an intentionally very long line that exceeds the default line length limit of eighty characters.

---

## MD014 — Dollar signs in shell code blocks

NG example (dollar sign prefix on commands):

```bash
$ echo "hello"
$ ls -la
```

---

## MD018 — Space after hash in ATX heading

NG example (no space after hash):

##Heading without space

---

## MD019 — No multiple spaces after hash

NG example (multiple spaces after hash):

##  Multiple spaces after hash

---

## MD022 — Headings surrounded by blank lines

NG example (no blank line before heading):
## This Heading Has No Blank Line Before It

---

## MD023 — Headings start at column 1

NG example (indented heading):

   ## Indented heading

---

## MD024 — No duplicate headings (siblings_only: true)

NG example (duplicate headings under the same parent):

## Duplicate

### Same Parent

### Same Parent

---

## MD026 — No trailing punctuation in headings

NG example (heading with trailing period):

## Heading With Trailing Period.

---

## MD027 — No multiple spaces after blockquote symbol

NG example (multiple spaces after `>`):

>  Two spaces after angle bracket.

---

## MD029 — Ordered list item prefix

NG example (non-sequential numbering):

1. First
3. Third (skipped 2)
2. Second (out of order)

---

## MD030 — Spaces after list markers

NG example (two spaces after dash):

-  Item with two spaces after dash

---

## MD031 — Fenced code blocks surrounded by blank lines

NG example (no blank line before code block):
```text
no blank line before this block
```

---

## MD033 — No inline HTML (allowed: details, summary)

NG example (non-allowed inline HTML — note: <details>/<summary> are allowed and must NOT appear here):

<br>Line break via HTML.

---

## MD034 — No bare URLs

NG example (bare URL without angle brackets or link syntax):

Visit https://example.com for more information.

---

## MD036 — No emphasis used as heading

NG example (bold used as a heading substitute):

**This Bold Line Is Used as a Heading**

---

## MD037 — No spaces inside emphasis markers

NG example (spaces inside asterisks — shown in code to avoid MD004 list confusion):

<!-- markdownlint-disable-next-line MD040 -->
```
* spaces inside *
** spaces inside **
```

Actual violation (inline): * spaces inside *

---

## MD038 — No spaces inside code span

NG example (spaces inside backticks):

` spaces inside `

---

## MD039 — No spaces inside link brackets

NG example (spaces inside brackets):

[ link text ](https://example.com)

---

## MD040 — Fenced code blocks have a language

NG example (no language specified):

```
no language specified
```

---

## MD042 — No empty links

NG example (empty link destination):

[Link with no destination]()

---

## MD045 — Images have alt text

NG example (no alt text):

![](./screenshot.png)

---

## MD046 — Code block style (fenced)

NG example (indented code block instead of fenced):

    indented code block (not fenced)

---

## MD048 — Code fence style (consistent backticks)

NG example (mixing tildes with backticks used elsewhere):

~~~text
using tilde fences (inconsistent)
~~~

---

## MD049 — Emphasis style (consistent asterisks)

NG example (underscore emphasis when asterisks used elsewhere):

_italic with underscores_

---

## MD050 — Strong style (consistent double asterisks)

NG example (double underscore strong when double asterisks used elsewhere):

__strong with underscores__

---

## MD055 — Table pipe style

NG example (inconsistent pipe style — first row has pipes, second row drops them):

| Column A | Column B |
|----------|----------|
Value 1 | Value 2

---

## MD056 — Table column count consistent

NG example (inconsistent column count):

| Col A | Col B |
|-------|-------|
| 1     | 2     | 3 |
