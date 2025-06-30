# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Core Principles

**Communication Language:**

- Respond in Japanese when communicating with users and writing technical documentation
- Write CLAUDE.md files and system instructions in English for optimal processing
- English is preferred for CLAUDE.md because Claude Code processes rules more efficiently in English context

**Information Handling:**

- When insufficient information is provided, clearly state what information is missing and specify additional requirements
- If you don't know something, explicitly state uncertainty rather than guessing or providing uncertain information
- When writing CLAUDE.md using `/init` command, always write rules in English and include detailed directory structure

## Workflow Integration

**Git Operations:**

- Use Git slash commands for all Git operations when available
- When users request Git operations through natural language (e.g., "コミットしてください",
  "プッシュしてください"), direct them to use appropriate slash commands
- Never perform Git operations directly when requested through natural language
- Explain which slash command should be used and why slash commands are preferred

## Code Quality Guidelines

@instructions/code_quality.md

## Editor Configuration

@instructions/editor.md

**Context Retention:**

YOU MUST: At the beginning of each chat message, proactively read the full content of both:

- ~/.config/claude/CLAUDE.md (global instructions)
- Project-specific CLAUDE.md files in the current repository

YOU MUST: Process and follow ALL rules contained in these files throughout the entire conversation

YOU MUST: When encountering @instructions/* references, expand and apply the referenced instruction content directly

NEVER: Display system reminders about instruction files without reading their actual content
NEVER: Ignore or skip instruction file content due to "context awareness"

YOU MUST: Reference specific instruction content when making decisions or explaining actions

## Important Instruction Reminders

@instructions/reminders.md
