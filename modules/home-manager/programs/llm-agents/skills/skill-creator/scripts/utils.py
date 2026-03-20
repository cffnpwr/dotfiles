"""Shared utilities for skill-creator scripts.

Currently exposes:
  parse_skill_md — parses the name and description from a SKILL.md file
                   without requiring a full YAML parser. Available for use
                   by other scripts in this skill; not currently imported
                   by any bundled script (quick_validate.py and
                   package_skill.py use yaml.safe_load directly).

Note: aggregate_benchmark.py intentionally duplicates the minimal name-reading
logic to remain self-contained and importable without this module.
"""

from pathlib import Path


def parse_skill_md(skill_path: Path) -> tuple[str, str, str]:
    """
    Parse a SKILL.md file and return (name, description, full_content).

    Handles both single-line and YAML block scalar (|, >, |-, >-) descriptions.

    Raises:
        ValueError: If frontmatter is missing or malformed.
    """
    content = (skill_path / "SKILL.md").read_text()
    lines = content.split("\n")

    if not lines or lines[0].strip() != "---":
        raise ValueError("SKILL.md missing frontmatter (no opening ---)")

    end_idx = None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            end_idx = i
            break

    if end_idx is None:
        raise ValueError("SKILL.md missing frontmatter (no closing ---)")

    name = ""
    description = ""
    frontmatter_lines = lines[1:end_idx]
    i = 0
    while i < len(frontmatter_lines):
        line = frontmatter_lines[i]

        if line.startswith("name:"):
            name = line[len("name:"):].strip().strip('"').strip("'")

        elif line.startswith("description:"):
            value = line[len("description:"):].strip()
            # Handle YAML block scalars: |  >  |-  >-
            if value in ("|", ">", "|-", ">-"):
                is_folded = value.startswith(">")
                continuation: list[str] = []
                i += 1
                while i < len(frontmatter_lines) and (
                    frontmatter_lines[i].startswith("  ")
                    or frontmatter_lines[i].startswith("\t")
                ):
                    continuation.append(frontmatter_lines[i].strip())
                    i += 1
                # | (literal): preserve newlines; > (folded): fold to spaces
                description = (
                    " ".join(continuation)
                    if is_folded
                    else "\n".join(continuation)
                )
                continue
            else:
                description = value.strip('"').strip("'")

        i += 1

    return name, description, content
