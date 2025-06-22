# Workflow Guidelines

## CRITICAL WORKFLOW ENFORCEMENT

**ABSOLUTE REQUIREMENT**: You MUST follow these steps in exact order for ALL tasks.
**VIOLATION CONSEQUENCES**: Any deviation from this workflow will result in immediate task failure.

## MANDATORY 3-PHASE WORKFLOW WITH FORCED CHECKPOINTS

### Phase 1: EXPLORE (Information Gathering)

**MANDATORY CHECKPOINT INITIALIZATION:**
YOU MUST: Start Phase 1 by executing TodoWrite with task breakdown

**REQUIRED ACTIONS:**
1. **Load Context**: Read ALL relevant files using concurrent tool calls
2. **Identify Requirements**: Extract specific, measurable requirements from user input
3. **Gap Analysis**: List what information is missing or unclear
4. **Web Research**: MANDATORY for unfamiliar technologies/APIs

**COMPLETION CRITERIA**: You must have concrete answers to:
- What exactly needs to be done?
- What files/components are involved?
- What are the technical constraints?
- What information is still missing?

**MANDATORY PHASE 1 COMPLETION PROTOCOL:**
YOU MUST: End Phase 1 with exactly: "✅ Phase 1 complete. Proceeding to planning."
YOU MUST: Update TodoWrite marking exploration as completed

### Phase 2: PLAN (Solution Design & Approval)

**MANDATORY CHECKPOINT PROTOCOL:**
YOU MUST: Mark planning todo as in_progress before starting Phase 2

**REQUIRED ACTIONS:**
1. **Solution Design**: Create step-by-step implementation plan
2. **Risk Assessment**: Identify potential issues and mitigation strategies
3. **Resource Requirements**: List all files, tools, and dependencies needed
4. **User Approval**: MANDATORY - Present plan and wait for explicit approval

**IMPLEMENTATION BLOCKER ENFORCEMENT:**
YOU MUST: End Phase 2 response with exactly: "🔴 IMPLEMENTATION BLOCKED - Awaiting approval"
NEVER: Continue to Phase 3 in the same response
NEVER: Start any implementation without explicit approval

**AUTO-APPROVAL CHECK SYSTEM:**
After presenting plan, scan next user message for:
- ✅ Explicit approval: "OK", "承認", "進めて", "やって", "続けて"
- 🔄 Modifications: "変更", "修正", "調整" → Return to planning
- ❌ Rejection: "だめ", "NG", "待って", "やめて" → Stop entirely

### Phase 3: ACT (Implementation)

**MANDATORY IMPLEMENTATION START PROTOCOL:**
YOU MUST: Begin Phase 3 with exactly: "✅ Approval received. Beginning implementation."
YOU MUST: Mark implementation todo as in_progress

**REQUIRED ACTIONS:**
1. **Implementation**: Execute approved plan step-by-step
2. **Quality Checks**: Run lint, format, tests for ALL changes
3. **Verification**: Confirm implementation meets requirements
4. **Error Resolution**: If issues arise, return to EXPLORE phase

**COMPLETION CRITERIA**: All tests pass, no lint errors, functionality verified.

**MANDATORY COMPLETION PROTOCOL:**
YOU MUST: End Phase 3 with exactly: "✅ Implementation complete."
YOU MUST: Mark all todos as completed using TodoWrite

## VIOLATION DETECTION & PENALTIES

**IMMEDIATE TASK FAILURE CONDITIONS:**
- Implementing without explicit user approval
- Skipping mandatory checkpoint protocols
- Not using TodoWrite for phase tracking
- Proceeding without proper approval keywords
- Combining Phase 2 and Phase 3 in single response

**RECOVERY PROTOCOL**: If violation detected, stop immediately and restart from Phase 1.

## COGNITIVE ASSISTANCE ENFORCEMENT

**MANDATORY TODO INTEGRATION:**
YOU MUST: Use TodoWrite at every phase transition
YOU MUST: Track phase completion status in real-time
YOU MUST: Never batch multiple phase completions

**FORCED RESPONSE TERMINATION:**
YOU MUST: Stop response after Phase 2 completion
YOU MUST: Wait for user approval before continuing
YOU MUST: Never assume user approval

**APPROVAL DETECTION FAILURE PROTOCOL:**
If user response doesn't contain approval keywords:
1. Ask for explicit confirmation
2. Do NOT proceed to implementation
3. Clarify what approval looks like