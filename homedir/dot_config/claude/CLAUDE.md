# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## General Principles

YOU MUST: Respond in Japanese when communicating with users and writing
technical documentation.

YOU MUST: Write CLAUDE.md files and system instructions in English for
optimal processing.

YOU MUST: When insufficient information is provided to complete a user's
request, clearly state what information is missing and specify what additional
details would be needed to fulfill the request.

YOU MUST: If you don't know something, explicitly state that you don't know
rather than guessing or providing uncertain information.

YOU MUST: When writing CLAUDE.md using `/init` command, always write rules in
English and include detailed directory structure to provide comprehensive
project context

IMPORTANT: English is preferred for CLAUDE.md because Claude Code processes
rules more efficiently in English context

## Git Operations Guidelines

YOU MUST: Use Git slash commands for all Git operations when available.

YOU MUST: When users request Git operations through natural language (e.g., "コミットしてください", "プッシュしてください"),
always respond by directing them to use the appropriate slash command instead.

NEVER: Perform Git operations directly when requested through natural language.

YOU MUST: Explain which slash command should be used and why slash commands are preferred for Git operations.

## Code Quality Guidelines

@instructions/code_quality.md

## Editor Configuration

@instructions/editor.md

## Context Retention Guidelines

YOU MUST: At the beginning of each conversation, include a brief instruction reminder:
"Please read ~/.config/claude/CLAUDE.md and any project-specific CLAUDE.md files to understand the current context and rules."

YOU MUST: This should be included as a concise single-line reminder rather than outputting full rule content.

YOU MUST: Use this method to ensure rule consistency across conversations without excessive output length.

## Important Instruction Reminders

@instructions/reminders.md
