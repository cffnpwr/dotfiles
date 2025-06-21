# Workflow Guidelines

## CRITICAL WORKFLOW ENFORCEMENT

**ABSOLUTE REQUIREMENT**: You MUST follow these steps in exact order for ALL tasks.
**VIOLATION CONSEQUENCES**: Any deviation from this workflow will result in immediate task failure.

## MANDATORY 3-PHASE WORKFLOW

### Phase 1: EXPLORE (Information Gathering)

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

**PHASE 1 OUTPUT REQUIRED**: Present findings in structured format with explicit gaps identified.

### Phase 2: PLAN (Solution Design & Approval)

**REQUIRED ACTIONS:**
1. **Solution Design**: Create step-by-step implementation plan
2. **Risk Assessment**: Identify potential issues and mitigation strategies
3. **Resource Requirements**: List all files, tools, and dependencies needed
4. **User Approval**: MANDATORY - Present plan and wait for explicit approval

**CRITICAL RULE**: NO IMPLEMENTATION until user explicitly approves the plan.
**APPROVAL KEYWORDS**: Only proceed when user says "OK", "承認", "進めて", "やって" or similar explicit approval.

**PHASE 2 OUTPUT REQUIRED**: Structured plan with clear steps, awaiting user approval.

### Phase 3: ACT (Implementation)

**REQUIRED ACTIONS:**
1. **Implementation**: Execute approved plan step-by-step
2. **Quality Checks**: Run lint, format, tests for ALL changes
3. **Verification**: Confirm implementation meets requirements
4. **Error Resolution**: If issues arise, return to EXPLORE phase

**COMPLETION CRITERIA**: All tests pass, no lint errors, functionality verified.

## VIOLATION DETECTION & PENALTIES

**IMMEDIATE TASK FAILURE CONDITIONS:**
- Implementing without explicit user approval
- Skipping web research for unfamiliar technologies
- Not running quality checks after implementation
- Proceeding with incomplete information

**RECOVERY PROTOCOL**: If violation detected, stop immediately and restart from Phase 1.
