---
name: problem-investigation
description: "Use when investigating any bug, failure, performance issue, or unexpected behavior — including when a hypothesis already exists or the problem appears simple. Provides isolation patterns and root cause analysis."
compatibility: No external dependencies. Works in all environments.
---

# Problem Investigation

Structured thinking patterns for investigating and isolating problems. Apply these patterns in order when diagnosing bugs, performance issues, or unexpected behavior.

## CRITICAL: Never Skip This Skill

YOU MUST load and apply this skill whenever any of the following conditions are met:
- Unexpected behavior between environments (e.g., "works in X but not in Y")
- Root cause is not immediately known with certainty
- Any behavior regression or anomaly

YOU MUST NOT skip this skill for these reasons:
- "I already have a hypothesis" — a hypothesis is not a confirmed fact; it still requires systematic verification
- "This seems straightforward" — apparent simplicity is a leading cause of wasted investigation cycles
- "I can figure this out without it" — self-assessment of problem difficulty is unreliable

## Pattern 1: Start with the Whole Picture

YOU MUST: Grasp the overall structure before examining any specific part.
NEVER: Immediately suspect a single component without understanding the full context.

Look at the system structure, not just the symptom location.

## Pattern 2: Predict Before You Look

YOU MUST: Articulate a hypothesis ("most likely here because...") before opening logs or code.
NEVER: Start digging without a stated hypothesis.

Observation without hypothesis leads to missing anomalies.

**Template:**
```
Hypothesis: [specific component/layer] because [reason].
Expected to find: [specific evidence that confirms or refutes].
```

## Pattern 3: Narrow from Outside In

YOU MUST: Narrow scope in layers — system → service boundary → component → code.
NEVER: Jump straight into reading code.

Move from outer layers inward, eliminating each layer before going deeper.

**Order:**
1. System/infrastructure level
2. Service boundaries (network, API)
3. Component level (module, class)
4. Code level (function, line)

## Pattern 4: Measure Before Acting

YOU MUST: Obtain actual measurements (APM, dashboards, logs, profiling) before making changes.
NEVER: Fix something that "seems slow" or "looks suspicious" without data.

Gut feeling is not a valid basis for a fix.

## Pattern 5: Look for What Changed

YOU MUST: When something was working yesterday but not today, identify what changed.
NEVER: Treat a regression as a new, unrelated problem without first checking for changes.

**Check in this order:**
1. Deployments / code changes
2. Configuration changes
3. Traffic patterns / load changes
4. Dependency / external service updates
5. Infrastructure changes

## Pattern 6: Change One Thing at a Time

YOU MUST: Apply changes one at a time and verify the effect of each.
NEVER: Apply multiple fixes simultaneously.

Simultaneous changes make it impossible to determine which change had which effect.

## Pattern 7: Probe Boundary Conditions

YOU MUST: Find not just "normal vs. abnormal" but "how far until it breaks."
Intentionally test conditions that violate implicit assumptions.

**Questions to ask:**
- What is the maximum input that still works correctly?
- What happens at zero, null, or empty values?
- What is the threshold where behavior changes?

Boundary probing reveals hidden assumptions in the code.

## Pattern 8: Minimize the Reproduction Case

YOU MUST: Reduce the reproduction steps to the smallest possible case before investigating.
NEVER: Investigate using complex, multi-step reproduction procedures.

**Steps:**
1. Identify the minimum set of conditions that trigger the issue
2. Remove unrelated code, dependencies, and configuration
3. Verify the minimal case still reproduces the issue

Noise elimination makes the root cause visible.
