# Eval Guide

Complete workflow for testing, measuring, and improving skills using the eval framework.

## Overview

Evals measure whether a skill actually improves agent behavior. The workflow:

1. **Define** test cases in `evals/evals.json`
2. **Run** each case with and without the skill
3. **Grade** results using `agents/grader.md`
4. **Aggregate** into `benchmark.json`
5. **Analyze** trends using `agents/analyzer.md`
6. **Improve** the skill and repeat

Evals are stored in `evals/` inside the skill directory and are **excluded from packaging**
(they are development artifacts, not runtime dependencies).

## Directory Structure

```
my-skill/
└── evals/
    ├── evals.json          # Test case definitions
    ├── runs/               # Per-run output directories (gitignore recommended)
    │   ├── run-001/
    │   │   ├── case-01/
    │   │   │   ├── outputs/        # Files produced by the agent
    │   │   │   ├── transcript.md   # Execution transcript
    │   │   │   └── grading.json    # Grader output
    │   │   └── benchmark.json      # Aggregated run results
    │   └── run-002/
    │       └── ...
    └── benchmarks/         # Archived benchmark.json files for trend analysis
        ├── 2025-01-10.json
        └── 2025-01-15.json
```

## Step 1: Define Test Cases

Create `evals/evals.json` following the schema in [schemas.md](schemas.md#evalsjson).

### Principles for Good Eval Cases

**Test real usage, not toy examples.**
Cases should reflect what users actually ask. Trivial cases pass trivially and provide no signal.

**Write expectations that require genuine task completion.**
"The output file exists" passes even if the file is empty.
"The output file contains a valid JSON object with all required keys" is better.

**Cover the triggering conditions.**
If your skill's description mentions five scenarios, write at least one case per scenario.
If the skill never triggers for a case, that's a coverage gap.

**Include edge cases and failure modes.**
What happens with empty input? Unicode? Very large input? These cases often reveal real bugs.

**Keep cases independent.**
Each case should run without assuming state from previous cases.

### Example

```json
{
  "skill": "pdf-editor",
  "version": "1.0.0",
  "cases": [
    {
      "id": "rotate-basic",
      "description": "Rotate a single-page PDF 90 degrees clockwise",
      "prompt": "Rotate the file sample.pdf 90 degrees clockwise and save as rotated.pdf",
      "setup": {
        "files": [
          {"source": "assets/sample.pdf", "dest": "sample.pdf"}
        ]
      },
      "expectations": [
        "rotated.pdf exists in the working directory",
        "rotated.pdf is a valid PDF file",
        "The page dimensions of rotated.pdf are swapped compared to sample.pdf"
      ],
      "tags": ["rotation", "basic"]
    }
  ]
}
```

## Step 2: Run Eval Cases

### Environment Setup

Before running, detect your agent environment:

```bash
python scripts/detect_env.py
```

Output tells you the `headless_command` for your environment.

### Execution Pattern

For each case in `evals.json`:

1. Create an isolated working directory under `evals/runs/run-NNN/case-ID/`
2. Copy any `setup.files` into the working directory
3. Run the agent with the case prompt (with skill loaded)
4. Capture transcript and output files
5. Optionally run without the skill (for baseline comparison)

### With-Skill vs Without-Skill

To measure the skill's actual contribution, run each case twice:

| Run type | Description |
|---|---|
| `with_skill` | Agent has skill loaded |
| `without_skill` | Agent runs without skill (baseline) |

Compare pass rates between the two to quantify the skill's impact.

### Headless Execution by Environment

| Agent | Command |
|---|---|
| Claude Code | `claude -p "<prompt>"` |
| opencode | `opencode run "<prompt>"` |
| Amp | `amp -x "<prompt>"` |
| Goose | `goose run --text "<prompt>"` |
| Codex CLI | `codex exec "<prompt>"` |

Use `detect_env.py` to get the correct command automatically rather than hardcoding.

**Note:** description optimization scripts that loop over headless commands require
`"subagent_support": true` in `detect_env.py` output. Check before running optimization loops.

## Step 3: Grade Results

For each case, invoke the Grader agent:

```
Use the grader agent at agents/grader.md with:
- expectations: [list from evals.json case]
- transcript_path: evals/runs/run-NNN/case-ID/transcript.md
- outputs_dir: evals/runs/run-NNN/case-ID/outputs/
```

The grader writes `grading.json` to `evals/runs/run-NNN/case-ID/`.
**Note:** `outputs_dir` must be a direct subdirectory of the case directory (e.g., `case-ID/outputs/`).
The grader writes `grading.json` to `{outputs_dir}/..` — which resolves to `case-ID/grading.json`.
This path is required for `aggregate_benchmark.py` to locate grading results.

### Grading at Scale

When running many cases, use parallel SubAgents (one per case) if your environment supports it
(check `subagent_support` from `detect_env.py`).

## Step 4: Aggregate into Benchmark

After all cases are graded, aggregate into `benchmark.json`:

```bash
python scripts/aggregate_benchmark.py evals/runs/run-NNN/
```

This reads all `grading.json` files and writes `evals/runs/run-NNN/benchmark.json`.

Archive the benchmark for trend analysis:

```bash
cp evals/runs/run-NNN/benchmark.json evals/benchmarks/$(date +%Y-%m-%d).json
```

## Step 5: Analyze Results

### Single Run Review

Read `benchmark.json` and review:

- Overall `pass_rate`
- Which cases failed and why (from `grading.json`)
- Eval feedback: are any assertions weak?

### Trend Analysis (Multiple Runs)

Use the Analyzer agent when you have two or more benchmark files:

```
Use the analyzer agent at agents/analyzer.md with:
- benchmark_paths: [evals/benchmarks/2025-01-10.json, evals/benchmarks/2025-01-15.json]
- skill_name: my-skill
```

The analyzer identifies regressions, improvements, and patterns across runs.

## Step 6: Improve the Skill

Based on analysis findings:

### Description Optimization

If cases are failing because the skill is not triggering (or triggering incorrectly):

1. Review which cases failed with `with_skill` but passed `without_skill` (or vice versa)
2. Check whether the skill loaded for those cases (look in transcript)
3. Revise the description to better cover triggering conditions
4. Re-run the affected cases

**Description optimization loop** (requires `"subagent_support": true` from `detect_env.py`):

```
1. Run all cases with current description → record pass_rate
2. Ask model to suggest 3 description variants targeting weak triggers
3. Run cases with each variant → compare pass_rates
4. Keep the best-performing variant
5. Repeat up to 5 iterations or until pass_rate plateaus
```

### Skill Content Improvement

If cases fail due to incorrect skill guidance (not trigger issues):

1. Identify the failing expectations
2. Find the SKILL.md section responsible for that guidance
3. Revise with clearer instructions or better examples
4. Re-run the affected cases

### Eval Improvement

If the Grader flagged weak assertions:

1. Review `eval_feedback.suggestions` in `grading.json`
2. Strengthen assertions in `evals.json`
3. Re-run to get accurate signal (expect pass rate to drop initially — that's correct)

## Common Pitfalls

**Optimizing on the evals instead of for real tasks.**
If you keep tweaking the description to pass specific test cases, you risk overfitting.
Add new cases from real usage to prevent this.

**Ignoring eval feedback from the Grader.**
Weak assertions give false confidence. A 100% pass rate on trivial assertions means nothing.

**Running only with-skill.**
Without a baseline, you can't tell if the skill is helping or if the agent would have succeeded anyway.

**Not archiving benchmarks.**
Without historical data, you can't detect regressions. Archive every benchmark run.

**Skipping the Grader critique step.**
The Grader's `eval_feedback` section often catches the most valuable issues.
