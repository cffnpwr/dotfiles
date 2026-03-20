# Eval Schemas

JSON schemas for all eval framework data files.

## evals.json

Test case definitions for a skill. Lives at `evals/evals.json` within the skill directory.

```json
{
  "skill": "string — skill name (must match SKILL.md name field)",
  "version": "string — skill version (semver recommended, e.g. \"1.0.0\")",
  "cases": [
    {
      "id": "string — unique identifier, kebab-case (e.g. \"rotate-basic\")",
      "description": "string — human-readable description of what this case tests",
      "prompt": "string — the exact prompt given to the agent",
      "setup": {
        "files": [
          {
            "source": "string — path relative to skill root (e.g. \"assets/sample.pdf\")",
            "dest": "string — filename in working directory (e.g. \"sample.pdf\")"
          }
        ]
      },
      "expectations": [
        "string — natural language assertion about the expected outcome"
      ],
      "tags": ["string — optional category labels for filtering"]
    }
  ]
}
```

**Notes:**
- `setup` is optional; omit if no files are needed
- `setup.files` entries copy skill assets into the per-case working directory before execution
- `expectations` are evaluated by the Grader agent — write them as observable, verifiable statements
- `tags` are optional but useful for running subsets (e.g. `--tag smoke`)

**Minimal example:**

```json
{
  "skill": "pdf-editor",
  "version": "1.0.0",
  "cases": [
    {
      "id": "rotate-basic",
      "description": "Rotate a single-page PDF 90 degrees clockwise",
      "prompt": "Rotate sample.pdf 90 degrees clockwise and save as rotated.pdf",
      "expectations": [
        "rotated.pdf exists in the working directory",
        "rotated.pdf is a valid PDF file"
      ]
    }
  ]
}
```

---

## grading.json

Output from the Grader agent for a single eval case. Written to
`evals/runs/run-NNN/case-ID/grading.json`.

```json
{
  "expectations": [
    {
      "text": "string — the expectation text from evals.json",
      "passed": "boolean",
      "evidence": "string — quote or description of evidence supporting the verdict"
    }
  ],
  "summary": {
    "passed": "integer — number of passed expectations",
    "failed": "integer — number of failed expectations",
    "total": "integer — total expectations",
    "pass_rate": "number — passed / total (0.0–1.0)"
  },
  "execution_metrics": {
    "tool_calls": {
      "ToolName": "integer — count of calls to this tool"
    },
    "total_tool_calls": "integer",
    "total_steps": "integer",
    "errors_encountered": "integer",
    "output_chars": "integer — total characters in output files",
    "transcript_chars": "integer — total characters in transcript"
  },
  "claims": [
    {
      "claim": "string — implicit claim extracted from output",
      "type": "string — \"factual\" | \"process\" | \"quality\"",
      "verified": "boolean",
      "evidence": "string"
    }
  ],
  "user_notes_summary": {
    "uncertainties": ["string"],
    "needs_review": ["string"],
    "workarounds": ["string"]
  },
  "eval_feedback": {
    "suggestions": [
      {
        "assertion": "string — the assertion being critiqued",
        "reason": "string — why this assertion is weak or missing"
      }
    ],
    "overall": "string — summary assessment of eval quality"
  }
}
```

**Notes:**
- `execution_metrics` is populated from transcript data; omit fields that cannot be determined
- `claims` is optional; omit if no implicit claims were extracted
- `user_notes_summary` is optional; omit if `user_notes.md` does not exist
- `eval_feedback` is optional; omit entirely if there are no suggestions worth raising

---

## benchmark.json

Aggregated results for all cases in a single eval run. Written to
`evals/runs/run-NNN/benchmark.json` by `scripts/aggregate_benchmark.py`.

```json
{
  "skill": "string — skill name",
  "version": "string — skill version",
  "run_id": "string — e.g. \"run-001\"",
  "timestamp": "string — ISO 8601 datetime (e.g. \"2025-01-15T10:30:00Z\")",
  "description_snapshot": "string | null — the description text passed via --description, or null if omitted",
  "run_type": "string — \"with_skill\" | \"without_skill\"",
  "summary": {
    "total_cases": "integer",
    "passed_cases": "integer",
    "failed_cases": "integer",
    "pass_rate": "number — 0.0–1.0",
    "avg_tool_calls": "number",
    "avg_steps": "number",
    "total_errors": "integer"
  },
  "cases": [
    {
      "id": "string — case id from evals.json",
      "description": "string — case description",
      "passed": "boolean — true if all expectations passed; false if any failed or if there are zero expectations",
      "pass_rate": "number — fraction of expectations that passed",
      "expectations_total": "integer",
      "expectations_passed": "integer",
      "tool_calls": "integer",
      "steps": "integer",
      "errors": "integer",
      "tags": ["string — only present if tags were defined for this case in evals.json"]
    }
  ]
}
```

---

## comparison.json

Output from the Comparator agent. Written to a comparison output path.

```json
{
  "prompt": "string — the task prompt given to both executions",
  "criteria": [
    {
      "name": "string — criterion name (e.g. \"accuracy\")",
      "score_a": "integer — 1–5",
      "score_b": "integer — 1–5",
      "winner": "string — \"A\" | \"B\" | \"tie\"",
      "justification": "string — evidence-based explanation"
    }
  ],
  "summary": {
    "winner": "string — \"A\" | \"B\" | \"tie\"",
    "score_a": "integer — sum of scores",
    "score_b": "integer — sum of scores",
    "total_possible": "integer — maximum achievable score (number of criteria × 5)",
    "reasoning": "string — overall explanation of the verdict"
  }
}
```

---

## timing.json

Optional supplementary file capturing detailed timing data for a single case execution.
Written alongside `grading.json` when timing instrumentation is available.

```json
{
  "case_id": "string",
  "start_time": "string — ISO 8601",
  "end_time": "string — ISO 8601",
  "elapsed_seconds": "number",
  "tool_timings": [
    {
      "tool": "string — tool name",
      "call_index": "integer — 0-based index of this call",
      "elapsed_seconds": "number"
    }
  ]
}
```

**Note:** `timing.json` is optional. Most eval workflows do not require per-tool timing.
Include it only when optimizing for execution speed is a goal.
