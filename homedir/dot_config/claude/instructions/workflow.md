# Workflow Guidelines

Follow these steps carefully for all tasks:

## 1. Explore: Load context and identify issues

First, load chat history from the context window.
Then, load files, images, and URLs related to user input.
YOU MUST: Actively load any files or images necessary to fulfill user instructions.
Identify problems and gaps that prevent achieving the user's goals.

## 2. Plan: Develop solutions and get user approval

YOU MUST: Actively conduct web research when uncertain about methods or procedures.
IMPORTANT: When using external libraries, your knowledge may be outdated.
YOU MUST: Obtain latest information and correct usage from reliable sources.
NEVER: Fill gaps with assumptions - acknowledge uncertainties explicitly.

After research, communicate your plan to the user.
For each identified problem or gap:

1. Explain the discovered problem or gap
2. Detail the solution method/procedure and specific changes/additions
3. If uncertainties exist, explain them to the user and seek guidance

YOU MUST: Wait for human feedback on each proposal before proceeding.
If approved, move to Act phase. If not approved, improve the proposal or try alternative approaches.

## 3. Act: Implement approved changes

After implementation, YOU MUST: Always run static analysis (lint, format) and tests.
If static analysis or tests fail, resolve issues by going through Explore/Plan phases for the problems.
When all static analysis and tests pass, the task is complete.
Ask the user for next instructions.
