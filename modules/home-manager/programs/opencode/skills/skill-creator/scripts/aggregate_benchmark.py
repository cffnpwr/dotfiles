#!/usr/bin/env python3
"""
Aggregate grading.json files from a single eval run into benchmark.json.

Reads all grading.json files found under the given run directory, computes
aggregate statistics, and writes benchmark.json to the run root.

Usage:
    python scripts/aggregate_benchmark.py evals/runs/run-001/
    python scripts/aggregate_benchmark.py evals/runs/run-001/ --run-type without_skill
    python scripts/aggregate_benchmark.py evals/runs/run-001/ --skill my-skill --version 1.0.0

Output:
    evals/runs/run-001/benchmark.json

Exit codes:
    0 - Success
    1 - No grading.json files found or argument error

Requires: Python 3.11+
"""

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

if sys.version_info < (3, 11):
    print(
        json.dumps(
            {
                "error": "Python 3.11+ required",
                "current_version": f"{sys.version_info.major}.{sys.version_info.minor}",
            }
        ),
        file=sys.stderr,
    )
    sys.exit(1)


def load_grading_files(run_dir: Path) -> list[tuple[Path, dict]]:
    """
    Find and load all grading.json files under run_dir.

    Returns a list of (grading_path, grading_data) tuples sorted by case directory name.
    """
    grading_files = sorted(run_dir.glob("*/grading.json"))
    if not grading_files:
        # Also try one level deeper (case-ID/grading.json inside case directories)
        grading_files = sorted(run_dir.glob("**/grading.json"))

    results = []
    for path in grading_files:
        try:
            data = json.loads(path.read_text())
            results.append((path, data))
        except (json.JSONDecodeError, OSError) as e:
            print(f"Warning: skipping {path}: {e}", file=sys.stderr)

    return results


def case_id_from_path(grading_path: Path, run_dir: Path) -> str:
    """Derive a case ID from the grading.json path relative to run_dir."""
    # grading.json is at run_dir/case-ID/grading.json
    # or run_dir/case-ID/outputs/../grading.json (sibling of outputs dir)
    relative = grading_path.relative_to(run_dir)
    parts = relative.parts
    # parts[0] is the case directory name
    return parts[0] if parts else grading_path.parent.name


def load_evals_json(run_dir: Path) -> dict[str, dict]:
    """
    Load evals/evals.json relative to run_dir and return a dict keyed by case ID.

    Walks up from run_dir to find evals.json (expected at evals/evals.json, two levels up
    from a run-NNN directory). Returns an empty dict if the file cannot be found or parsed.
    """
    # run_dir is typically skill-root/evals/runs/run-NNN/
    # evals.json is at skill-root/evals/evals.json
    candidate = run_dir
    for _ in range(4):
        evals_path = candidate / "evals.json"
        if evals_path.exists():
            try:
                data = json.loads(evals_path.read_text())
                return {c["id"]: c for c in data.get("cases", []) if "id" in c}
            except (json.JSONDecodeError, OSError) as e:
                print(f"Warning: could not read {evals_path}: {e}", file=sys.stderr)
                return {}
        candidate = candidate.parent
    return {}


def extract_case_row(case_id: str, grading: dict, case_meta: dict | None = None) -> dict:
    """Build a single case entry for benchmark.json from a grading.json dict.

    case_meta is the matching entry from evals.json (if available), used to populate
    description and tags which are not present in grading.json.
    """
    summary = grading.get("summary", {})
    metrics = grading.get("execution_metrics", {})
    meta = case_meta or {}

    expectations_total = summary.get("total", 0)
    expectations_passed = summary.get("passed", 0)
    # A case with zero expectations is treated as failed (no evidence of success).
    passed = expectations_total > 0 and expectations_passed == expectations_total
    pass_rate = summary.get("pass_rate", 0.0)

    row: dict = {
        "id": case_id,
        "description": meta.get("description", ""),
        "passed": passed,
        "pass_rate": pass_rate,
        "expectations_total": expectations_total,
        "expectations_passed": expectations_passed,
        "tool_calls": metrics.get("total_tool_calls", 0),
        "steps": metrics.get("total_steps", 0),
        "errors": metrics.get("errors_encountered", 0),
    }

    tags = meta.get("tags")
    if tags:
        row["tags"] = tags

    return row


def aggregate(
    run_dir: Path,
    skill: str,
    version: str,
    run_type: str,
    description_snapshot: str | None,
) -> dict:
    """Load all grading files and produce the benchmark dict."""
    grading_entries = load_grading_files(run_dir)

    if not grading_entries:
        print(f"Error: no grading.json files found under {run_dir}", file=sys.stderr)
        sys.exit(1)

    # Load evals.json to enrich case rows with description and tags
    case_meta_by_id = load_evals_json(run_dir)

    cases = []
    total_tool_calls = 0
    total_steps = 0
    total_errors = 0

    for grading_path, grading in grading_entries:
        case_id = case_id_from_path(grading_path, run_dir)
        row = extract_case_row(case_id, grading, case_meta_by_id.get(case_id))
        cases.append(row)
        total_tool_calls += row["tool_calls"]
        total_steps += row["steps"]
        total_errors += row["errors"]

    total_cases = len(cases)
    passed_cases = sum(1 for c in cases if c["passed"])
    failed_cases = total_cases - passed_cases
    pass_rate = passed_cases / total_cases if total_cases > 0 else 0.0
    avg_tool_calls = total_tool_calls / total_cases if total_cases > 0 else 0.0
    avg_steps = total_steps / total_cases if total_cases > 0 else 0.0

    run_id = run_dir.name

    benchmark: dict = {
        "skill": skill,
        "version": version,
        "run_id": run_id,
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "description_snapshot": description_snapshot,
        "run_type": run_type,
        "summary": {
            "total_cases": total_cases,
            "passed_cases": passed_cases,
            "failed_cases": failed_cases,
            "pass_rate": round(pass_rate, 4),
            "avg_tool_calls": round(avg_tool_calls, 2),
            "avg_steps": round(avg_steps, 2),
            "total_errors": total_errors,
        },
        "cases": cases,
    }

    return benchmark


def infer_skill_name(run_dir: Path) -> str:
    """Walk up from run_dir to find a SKILL.md and read the name field."""
    candidate = run_dir
    for _ in range(6):  # don't walk too far up
        skill_md = candidate / "SKILL.md"
        if skill_md.exists():
            try:
                # Minimal frontmatter parse — avoid importing utils to keep this self-contained
                lines = skill_md.read_text().split("\n")
                for line in lines:
                    if line.startswith("name:"):
                        return line[len("name:"):].strip().strip('"').strip("'")
            except OSError:
                pass
        candidate = candidate.parent

    return "unknown"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Aggregate grading.json files into benchmark.json for one eval run."
    )
    parser.add_argument(
        "run_dir",
        type=Path,
        help="Path to the run directory (e.g. evals/runs/run-001/)",
    )
    parser.add_argument(
        "--skill",
        default=None,
        help="Skill name (inferred from SKILL.md if omitted)",
    )
    parser.add_argument(
        "--version",
        default="0.0.0",
        help="Skill version (default: 0.0.0)",
    )
    parser.add_argument(
        "--run-type",
        default="with_skill",
        choices=["with_skill", "without_skill"],
        help="Whether this run used the skill (default: with_skill)",
    )
    parser.add_argument(
        "--description",
        default=None,
        help="Snapshot of the skill description used during this run (optional)",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Output path for benchmark.json (default: <run_dir>/benchmark.json)",
    )

    args = parser.parse_args()

    run_dir: Path = args.run_dir.resolve()
    if not run_dir.is_dir():
        print(f"Error: {run_dir} is not a directory", file=sys.stderr)
        sys.exit(1)

    skill = args.skill or infer_skill_name(run_dir)
    output_path = args.output or (run_dir / "benchmark.json")

    benchmark = aggregate(
        run_dir=run_dir,
        skill=skill,
        version=args.version,
        run_type=args.run_type,
        description_snapshot=args.description,
    )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(benchmark, indent=2) + "\n")

    total = benchmark["summary"]["total_cases"]
    passed = benchmark["summary"]["passed_cases"]
    rate = benchmark["summary"]["pass_rate"]
    print(f"benchmark.json written to {output_path}")
    print(f"  {passed}/{total} cases passed ({rate:.0%})")


if __name__ == "__main__":
    main()
