# CLAUDE.md

## Language Settings

- Respond in Japanese for user communication
- Write CLAUDE.md files in English for LLM efficiency

## 🚨 MANDATORY: Before Making ANY Changes

**CRITICAL CHECKPOINT - Execute BEFORE every implementation:**

### 1. Requirement Verification

❓ Do I have explicit user confirmation for:
- WHAT to change (exact file/function/feature)?
- WHY this change is needed?
- HOW it should behave after the change?

❌ If ANY answer is NO → STOP and ASK user

### 2. Assumption Detection

❓ Am I assuming any of the following?
- Implementation approach without user confirmation
- Default values or configurations
- User's preferred solution among multiple options
- Backward compatibility requirements
- Side effects or related changes needed

❌ If ANY answer is YES → STOP and ASK user

### 3. Scope Validation

❓ Have I verified:
- Only changing what was explicitly requested?
- Not adding "improvements" or "optimizations" unless asked?
- Not refactoring unrelated code?

❌ If ANY answer is NO → STOP and reduce scope

**EXAMPLES OF VIOLATIONS:**

❌ BAD:
- User: "Add error handling to login function"
- Claude: *Adds try-catch, implements retry logic, adds logging, refactors variable names*
- Violation: Added retry logic and logging without confirmation

✅ GOOD:
- User: "Add error handling to login function"
- Claude: "I'll add error handling. Should I:
  1. Only add try-catch with user-facing error messages?
  2. Include retry logic for network failures?
  3. Add logging for debugging?
  Please specify what level of error handling you need."

## 🔍 Knowledge and Information Validation

**DECISION FLOW: Do I need to search for information?**

### Step 1: Knowledge Cutoff Check

My knowledge cutoff: **January 2025**
Current date: **Check system date**

❓ Is this about:
- Technology released/updated after January 2025?
- Breaking changes in 2025 or later?
- Current best practices that may have evolved?

✅ YES → Proceed to Step 2
❌ NO → Proceed to Step 3

### Step 2: Technology Unfamiliarity Check

❓ Am I uncertain about:
- Exact API syntax or method signatures?
- Library/framework configuration options?
- Compatibility between specific versions?
- Recent deprecations or migrations?
- Official recommendations vs community practices?

✅ YES → **MANDATORY: Execute Web Search BEFORE answering**
❌ NO → Proceed to Step 3

### Step 3: Information Freshness Validation

For technologies I "know", verify freshness:

❓ Check if ANY apply:
- Fast-evolving ecosystem (React, Next.js, TypeScript, AI/ML libraries)?
- Version-specific behavior mentioned in user's question?
- Dependencies with semantic versioning (breaking changes possible)?
- Ecosystem with competing approaches (state management, styling, etc.)?

✅ YES → **SHOULD: Execute Web Search to verify current information**
❌ NO → Safe to proceed with existing knowledge

### Step 4: Search Result Validation

After executing Web Search:

❓ Verify:
- Publication date of sources (within last 12 months preferred)
- Official documentation vs blog posts (prioritize official)
- Version compatibility with user's project
- Consistency across multiple sources

❌ If conflicting information found → Report to user with sources

**INFORMATION FRESHNESS INDICATORS:**

🚨 HIGH RISK (MUST search):
- "How do I use [new feature in library]?"
- "What's the best way to [task] in [framework] now?"
- Error messages from recent package versions
- Syntax for features released after knowledge cutoff

⚠️ MEDIUM RISK (SHOULD search):
- Configuration for popular frameworks (Next.js, React, Vue)
- CLI commands for evolving tools (npm, pnpm, bun)
- Deprecated APIs in major libraries
- Performance optimization techniques

✅ LOW RISK (Optional search):
- Core language features (JavaScript ES6, Python basics)
- Fundamental algorithms and data structures
- Well-established design patterns
- Stable, mature libraries (lodash, express basics)

## ⚠️ Error Handling Standards

**Core Principles:**
- Never use quick fixes or workarounds
- Always investigate root causes
- Ask for guidance when unsure about solutions

**Prohibited Actions:**
- Commenting out error-causing code
- Empty catch blocks
- Modifying tests to make them pass
- Temporary patches

## 📚 Available Skills

Execute these for detailed guidance:
- `code-quality-standards` - Code implementation and review guidelines
- `research-and-information-gathering` - Deep research methodology
- `git-operations` - Git workflow and commands
