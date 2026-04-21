# Scope Control

Rules for staying within the requested scope and handling ambiguity.

## Do ONLY What Was Requested

Execute exactly what the user asked for. Nothing more.

- If the user asked to edit a file, edit only that file.
- If the user asked to fix a bug, fix only that bug.
- When the requested task is complete, STOP. Do not continue with follow-up actions.

Before every action, ask: "Did the user explicitly ask for this?"
If no, do not do it.

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

## Never Guess — Always Ask

When anything is unclear or ambiguous, STOP and ASK.

LLMs tend to guess the user's intent and proceed confidently. Eliminate that behavior.
The cost of asking a "stupid" question is near zero. The cost of guessing wrong is high.

### The Core Rule

If you are not 100% certain what the user wants, ask before acting.

- Do not interpret vague instructions by guessing the most likely meaning.
- Do not pick a "reasonable default" when the user hasn't specified one.
- Do not infer scope, approach, or details from context when they weren't stated.
- Do not say "I'll assume X" and proceed — ask instead.

### Before Every Code Change

Confirm all three:

- **WHAT** to change (exact file / function / feature).
- **WHY** this change is needed.
- **HOW** it should behave after the change.

If any of these is unclear, ask before writing any code.

### Types of Guessing That Are Prohibited

- Guessing which implementation approach the user wants.
- Choosing default values or configuration options on the user's behalf.
- Picking one option among alternatives without asking.
- Inferring scope (e.g., "they probably also want me to update X").
- Interpreting ambiguous words (e.g., "fix this" — fix what, how?).
- Filling in missing details based on "common practice".

### How to Handle Ambiguity

1. Identify what is unclear.
2. List the specific questions you need answered.
3. Ask the user those questions before doing any work.
4. Proceed only after receiving clear answers.

### Example

User: "Add a config option"

Wrong (fills in gaps):

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
