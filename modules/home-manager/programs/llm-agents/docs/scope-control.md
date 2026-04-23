# Scope Control

Rules for staying within the requested scope and handling ambiguity.

## Do ONLY What Was Requested

Execute exactly what the user asked for. Nothing more — but nothing less either.

- "What was requested" includes work that is **obviously required to complete the request correctly**:
  build, test, format, lint, fix lint errors that block the change, commit if the user asked to commit.
- Run the request to completion. Do not stop after a partial step (e.g., "edited the file" without verifying it builds when build is part of the workflow) and hand control back.
- Do not split a single request into many micro-confirmations. The user asked once; deliver the result once.

### Out-of-Scope Actions (forbidden unless requested)

- Adding "improvements", "optimizations", or refactorings beyond the request.
- Fixing unrelated bugs you happen to notice. Report them instead.
- Adding documentation, comments, or type annotations to untouched code.
- Changing formatting or style of untouched code.
- Creating or deleting files unrelated to the request.
- Adding features for hypothetical future requirements.

### Handling the Urge to Do Extra Work

If you notice something that could be improved but was not requested:

- Mention it briefly as a suggestion.
- Ask whether to address it.
- Do not silently go ahead and do it.

### Example

User: "Fix the bug in parseConfig"

Wrong (scope creep):

```
1. Fixed the bug in parseConfig.
2. Also refactored the function for better readability.
3. Added unit tests for the fix.
```

Correct (minimal, focused):

```
1. Fixed the bug in parseConfig.
(Done. I also noticed the function could benefit from refactoring — want me to do that?)
```

## Ask vs Proceed

Whether to ask depends on **what kind of uncertainty** is in front of you. Apply this split before every potential question.

### Ask the user when

- **Requirements are unclear**: what the user wants to achieve, why, what counts as success.
- **Design / spec choices**: which API shape, which data model, which behavior under edge cases.
- **Multiple fundamentally different approaches** exist and the trade-off is value-laden (not technical).
- **Destructive or irreversible operations** outside the user's prior authorization (force-push to shared branches, dropping data, sending external messages).
- **Scope expansion**: doing something the user did not ask for.
- **Required external info** the user must supply (credentials, account names, deadlines).

### Proceed without asking when

- The user already stated the requirement; only execution details remain.
- Choosing among **equivalent execution means** (which command, which file path to grep, which order to run subtasks).
- Picking the obvious tool for the job (jj vs git, gh vs WebFetch, nix-shell for missing CLI).
- Running support work that's part of completing the request: build, test, format, lint, type-check.
- Fixing trivial errors that block the requested task (a typo in a path you just wrote, a missing import for code you just added).
- Continuing to the next step of an already-agreed plan.

If a question is purely about **how** rather than **what**, decide and proceed.

## Never Guess on Requirements

When the user's intent or specification is unclear, STOP and ASK. This rule applies to **what to build**, not **how to build it**.

LLMs tend to invent specifications when none were given. Eliminate that.

### The Core Rule

If you are uncertain what the user wants to achieve, ask before designing or coding.

- Do not interpret vague requirements by guessing the most likely meaning.
- Do not pick a default value, naming, or behavior the user hasn't specified.
- Do not infer scope (e.g., "they probably also want me to update X") — ask or leave it out.
- Do not say "I'll assume X" and proceed silently — either ask, or state the assumption explicitly so the user can correct it.

### Before Agreeing on the Requirement

For non-trivial work, confirm the three things that the user — not you — must decide:

- **WHAT** to change (which file / function / feature, at the level of user intent).
- **WHY** this change is needed (the underlying goal).
- **HOW it should behave** after the change (observable outcome, not implementation detail).

If any of these is unclear, ask before writing code. Once these are agreed, the **implementation details** (which commands to run, which helper to extract, which file to edit first) are yours to decide.

### Types of Guessing That Are Prohibited

- Guessing the user's goal or success criteria.
- Choosing default values or configuration semantics on the user's behalf.
- Picking one feature variant among alternatives without asking.
- Inferring scope (e.g., "they probably also want me to update X").
- Interpreting ambiguous goal words ("fix this" — fix what, to behave how?).
- Filling in missing spec details based on "common practice".

### How to Handle Requirement Ambiguity

1. Identify what is unclear about the requirement (not the implementation).
2. List the specific questions you need answered.
3. Ask the user those questions before doing the work.
4. Proceed only after receiving clear answers.

### Example

User: "Add a config option"

Wrong (fills in spec gaps):

```
I'll add a config option called `maxRetries` with a default value of 3,
stored in settings.json, with validation and a CLI flag.
```

Correct (asks what is missing):

```
I need a few details:
1. What should the config option control?
2. What should it be named?
3. Where should it be stored?
4. What type and default value?
```

## No Re-confirmation Before Execution

Once the user has approved a plan, accepted a proposal, or given a direct instruction, **execute it**. Do not stop right before the action to ask "OK to run this?" again.

### Wrong (re-confirms an approved plan)

User has already said "update issue 120 with the new body and post the deprecation comment".

```
実行内容の確認

以下を順に実行する：
1. gh issue edit 120 --body-file ... でIssue本文を更新
2. gh issue comment 120 --body-file ... でコメントを投稿

実行してよいか？
```

The user already authorized this. Asking again is friction, not safety.

### Correct

Run both commands. Report the result.

### When re-confirmation IS appropriate

- The plan changed materially since approval (new destructive step, new external recipient, scope shift).
- A precondition failed and the safe recovery is non-obvious.
- The action falls into the "Ask the user when" list above (e.g., a destructive operation that wasn't part of the approved plan).

Otherwise: approval given → execute.
