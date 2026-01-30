# CLAUDE.md

## Language Settings

- Respond in Japanese for user communication
- Write CLAUDE.md files in English for LLM efficiency

## 🚨 CRITICAL: No Assumptions - Always Confirm

**MANDATORY CHECKPOINT - Execute BEFORE every code change:**

### Rule 1: Explicit Confirmation Required

**NEVER assume. ALWAYS confirm these with user:**
- **WHAT** to change (exact file/function/feature)
- **WHY** this change is needed
- **HOW** it should behave after change

❌ **If ANY is unclear → STOP and ASK user**

### Rule 2: Detect and Reject Assumptions

**STOP immediately if you're assuming ANY of:**
- Implementation approach or technical solution
- Default values or configuration choices
- User's preferred option among alternatives
- Backward compatibility requirements
- Related changes or side effects needed

❌ **If making ANY assumption → STOP and ASK user**

### Rule 3: Strict Scope Adherence

**PROHIBITED without explicit request:**
- Adding "improvements" or "optimizations"
- Refactoring unrelated code
- Adding features beyond request
- Changing code style or formatting (unless requested)

✅ **ONLY change what was explicitly requested**

### Example: Correct Behavior

User: "Add error handling to login function"

❌ **WRONG** (making assumptions):
```
Adding error handling with:
- try-catch blocks
- retry logic for network failures
- comprehensive logging
- input validation
```

✅ **CORRECT** (confirming first):
```
I'll add error handling to the login function. Please specify:
1. Only basic try-catch with user-facing error messages?
2. Include retry logic for network failures?
3. Add logging for debugging?
4. Validate inputs as well?
```

## 🔍 Knowledge Validation: When to Search

**Knowledge cutoff: January 2025** | **Current date: 2026-01-01**

### Search Decision Checklist

Use this checklist BEFORE answering any technical question:

**🚨 MUST search (blocking requirement):**
- [ ] Technology released/updated after January 2025
- [ ] Uncertain about exact API syntax or method signatures
- [ ] Library/framework configuration options (may have changed)
- [ ] Recent deprecations or breaking changes
- [ ] Error messages from recent package versions

**⚠️ SHOULD search (high risk of outdated info):**
- [ ] Fast-evolving ecosystems (React, Next.js, TypeScript, AI/ML, Rust)
- [ ] CLI commands for actively developed tools (npm, pnpm, bun, cargo)
- [ ] Version-specific behavior mentioned in question
- [ ] Performance optimization techniques (best practices evolve)
- [ ] Framework-specific patterns (state management, styling approaches)

**✅ OPTIONAL search (stable information):**
- [ ] Core language features (JavaScript ES6, Python basics)
- [ ] Fundamental algorithms and data structures
- [ ] Well-established design patterns
- [ ] Mature stable libraries (lodash core, express basics)

### After Searching: Validate Sources

**Verify BEFORE using information:**
- Publication date (prefer within 12 months)
- Official documentation > blog posts
- Version compatibility with user's project
- Consistency across multiple sources

❌ **If conflicting information found → Report to user with sources**

## ⚠️ Error Handling Standards

**CRITICAL: Never use workarounds or quick fixes**

**Core Principles:**
1. Always investigate root causes (never mask symptoms)
2. Ask for guidance when unsure about proper solution
3. Fix problems properly or not at all

**ABSOLUTELY PROHIBITED:**
- Commenting out error-causing code
- Empty catch blocks (catching without handling)
- Modifying tests to make them pass without fixing root cause
- Temporary patches or "TODO: fix later" solutions

## 🔧 Tool Selection Policy

### GitHub Operations - MANDATORY MCP Usage

**CRITICAL REQUIREMENT**: For ANY GitHub operation, you MUST use GitHub MCP tools.

**Workflow (no exceptions):**
1. **DETECTION**: Identify task involves GitHub
2. **SEARCH**: `MCPSearch` to find appropriate MCP tool
3. **LOAD**: Load MCP tool (mandatory prerequisite)
4. **EXECUTE**: Use loaded MCP tool

**Examples:**
- ✅ CORRECT: `mcp__github__search_issues`
- ❌ WRONG: `gh issue list` or Bash commands
- ✅ CORRECT: `mcp__github__get_pull_request`
- ❌ WRONG: `gh pr view` or WebFetch

**Exception**: Git operations (clone, commit, push, status, diff) use `git` commands.

## 📚 Available Skills

Execute these for detailed guidance:
- `code-quality-standards` - Code implementation and review guidelines
- `research-and-information-gathering` - Deep research methodology
- `git-operations` - Git workflow and commands
- `structured-claude-md` - Structured CLAUDE.md and documentation creation
