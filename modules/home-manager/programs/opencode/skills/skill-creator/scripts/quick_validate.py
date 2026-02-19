#!/usr/bin/env python3
"""
Quick validation script for skills - Extended version with compatibility checks

Validates:
- SKILL.md exists and has proper YAML frontmatter
- Required fields: name, description, compatibility (NEW)
- Field constraints: naming, length, format
- Script-dependency consistency (NEW)
- Environment check instructions (NEW)

Requires: Python 3.11+, PyYAML
"""

import sys
import re
from pathlib import Path

# Check Python version
if sys.version_info < (3, 11):
    print("Error: Python 3.11+ required")
    print(f"Current version: {sys.version_info.major}.{sys.version_info.minor}")
    sys.exit(1)

try:
    import yaml
except ImportError:
    print("Error: PyYAML is required. Install with: pip3 install PyYAML")
    sys.exit(1)


def validate_compatibility_field(skill_dir, frontmatter):
    """
    Validate compatibility field presence and consistency with scripts.
    This is a NEW validation in improved-skill-creator.
    """
    errors = []
    warnings = []

    # 1. Field existence (REQUIRED)
    if "compatibility" not in frontmatter:
        errors.append(
            "Missing REQUIRED 'compatibility' field in frontmatter. "
            "All skills must declare dependencies explicitly, or state "
            "'No external dependencies'."
        )
        return errors, warnings

    compat = frontmatter["compatibility"]

    # 2. Non-empty check
    if not compat or not str(compat).strip():
        errors.append("'compatibility' field cannot be empty")
        return errors, warnings

    compat_str = str(compat).strip()

    # 3. TODO placeholder check
    if "TODO" in compat_str:
        errors.append(
            "'compatibility' field contains TODO placeholder. "
            "Complete the compatibility assessment before validation."
        )

    # 4. Script consistency check
    scripts_dir = skill_dir / "scripts"
    if scripts_dir.exists() and scripts_dir.is_dir():
        py_files = list(scripts_dir.glob("*.py"))
        js_files = list(scripts_dir.glob("*.js"))
        sh_files = list(scripts_dir.glob("*.sh"))
        rb_files = list(scripts_dir.glob("*.rb"))
        pl_files = list(scripts_dir.glob("*.pl"))
        php_files = list(scripts_dir.glob("*.php"))
        ps1_files = list(scripts_dir.glob("*.ps1"))

        compat_lower = compat_str.lower()

        if py_files and "python" not in compat_lower:
            warnings.append(
                f"Found {len(py_files)} Python file(s) in scripts/ but "
                "'compatibility' doesn't mention Python. "
                f"Files: {', '.join(f.name for f in py_files[:3])}"
                + (" ..." if len(py_files) > 3 else "")
            )

        if js_files and "node" not in compat_lower and "javascript" not in compat_lower:
            warnings.append(
                f"Found {len(js_files)} JavaScript file(s) in scripts/ but "
                "'compatibility' doesn't mention Node.js. "
                f"Files: {', '.join(f.name for f in js_files[:3])}"
                + (" ..." if len(js_files) > 3 else "")
            )

        if sh_files and "bash" not in compat_lower and "shell" not in compat_lower:
            warnings.append(
                f"Found {len(sh_files)} shell script(s) in scripts/ but "
                "'compatibility' doesn't mention Bash. "
                f"Files: {', '.join(f.name for f in sh_files[:3])}"
                + (" ..." if len(sh_files) > 3 else "")
            )

        # Check for other script types
        other_scripts = rb_files + pl_files + php_files + ps1_files
        if other_scripts:
            langs = []
            if rb_files:
                langs.append(f"Ruby ({len(rb_files)})")
            if pl_files:
                langs.append(f"Perl ({len(pl_files)})")
            if php_files:
                langs.append(f"PHP ({len(php_files)})")
            if ps1_files:
                langs.append(f"PowerShell ({len(ps1_files)})")

            warnings.append(
                f"Found scripts in other languages: {', '.join(langs)}. "
                "Ensure they are mentioned in compatibility field."
            )

    # 5. "No external dependencies" check
    has_scripts = (
        scripts_dir.exists() and any(scripts_dir.iterdir())
        if scripts_dir.exists()
        else False
    )

    if not has_scripts:
        no_deps_keywords = [
            "no external",
            "no dependencies",
            "works in all environments",
        ]
        compat_check = compat_str.lower()
        if not any(keyword in compat_check for keyword in no_deps_keywords):
            warnings.append(
                "No scripts found in scripts/ directory. "
                "Consider stating 'No external dependencies. Works in all environments.' "
                "in compatibility field."
            )

    return errors, warnings


def validate_environment_check(skill_dir, frontmatter):
    """
    Validate that environment check instructions exist when dependencies are declared.
    This is a NEW validation in improved-skill-creator.
    """
    warnings = []

    # Check if dependencies are declared
    compat = (
        frontmatter.get("compatibility", "").lower()
        if "compatibility" in frontmatter
        else ""
    )
    has_deps = any(
        keyword in compat
        for keyword in ["required", "python", "node", "bash", "ruby", "perl", "php"]
    )

    if has_deps:
        skill_md = skill_dir / "SKILL.md"
        content = skill_md.read_text().lower()

        # Look for environment-related sections
        env_keywords = [
            "environment",
            "requirements",
            "dependencies",
            "python3 --version",
            "node --version",
            "check",
        ]

        has_env_section = any(keyword in content for keyword in env_keywords)

        if not has_env_section:
            warnings.append(
                "Skill declares dependencies in 'compatibility' field but "
                "SKILL.md doesn't appear to have environment check instructions. "
                "Consider adding an 'Environment Requirements' section with "
                "check commands and installation guidance."
            )

    return warnings


def validate_skill(skill_path):
    """
    Validate a skill's SKILL.md file.

    Returns:
        (success: bool, errors: list, warnings: list)
    """
    skill_path = Path(skill_path)
    errors = []
    warnings = []

    # Check SKILL.md exists
    skill_md = skill_path / "SKILL.md"
    if not skill_md.exists():
        return False, ["SKILL.md not found"], []

    # Read content
    try:
        content = skill_md.read_text()
    except Exception as e:
        return False, [f"Could not read SKILL.md: {e}"], []

    # Check frontmatter format
    if not content.startswith("---"):
        return False, ["No YAML frontmatter found (must start with ---)"], []

    # Extract frontmatter
    match = re.match(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return (
            False,
            ["Invalid frontmatter format (must be enclosed in --- markers)"],
            [],
        )

    frontmatter_text = match.group(1)

    # Parse YAML
    try:
        frontmatter = yaml.safe_load(frontmatter_text)
        if not isinstance(frontmatter, dict):
            return False, ["Frontmatter must be a YAML dictionary"], []
    except yaml.YAMLError as e:
        return False, [f"Invalid YAML in frontmatter: {e}"], []

    # Define allowed properties
    ALLOWED_PROPERTIES = {
        "name",
        "description",
        "compatibility",  # Required
        "license",
        "allowed-tools",
        "metadata",  # Optional
    }

    # Check for unexpected properties
    unexpected_keys = set(frontmatter.keys()) - ALLOWED_PROPERTIES
    if unexpected_keys:
        errors.append(
            f"Unexpected key(s) in frontmatter: {', '.join(sorted(unexpected_keys))}. "
            f"Allowed properties are: {', '.join(sorted(ALLOWED_PROPERTIES))}"
        )

    # Check required fields: name, description
    if "name" not in frontmatter:
        errors.append("Missing required 'name' field in frontmatter")

    if "description" not in frontmatter:
        errors.append("Missing required 'description' field in frontmatter")

    # Validate name
    if "name" in frontmatter:
        name = frontmatter["name"]
        if not isinstance(name, str):
            errors.append(f"'name' must be a string, got {type(name).__name__}")
        else:
            name = name.strip()
            if name:
                # Check naming convention (kebab-case)
                if not re.match(r"^[a-z0-9-]+$", name):
                    errors.append(
                        f"'name' should be kebab-case "
                        "(lowercase letters, digits, and hyphens only). "
                        f"Got: '{name}'"
                    )
                if name.startswith("-") or name.endswith("-") or "--" in name:
                    errors.append(
                        f"'name' cannot start/end with hyphen or contain "
                        f"consecutive hyphens. Got: '{name}'"
                    )
                # Check length
                if len(name) > 64:
                    errors.append(
                        f"'name' is too long ({len(name)} characters). "
                        "Maximum is 64 characters."
                    )

    # Validate description
    if "description" in frontmatter:
        description = frontmatter["description"]
        if not isinstance(description, str):
            errors.append(
                f"'description' must be a string, got {type(description).__name__}"
            )
        else:
            description = description.strip()
            if description:
                # Check for angle brackets
                if "<" in description or ">" in description:
                    errors.append(
                        "'description' cannot contain angle brackets (< or >)"
                    )
                # Check length
                if len(description) > 1024:
                    errors.append(
                        f"'description' is too long ({len(description)} characters). "
                        "Maximum is 1024 characters."
                    )
                # Warn if too short
                if len(description) < 50:
                    warnings.append(
                        f"'description' is quite short ({len(description)} characters). "
                        "Consider adding more detail about when to use this skill."
                    )

    # Validate compatibility field (NEW)
    compat_errors, compat_warnings = validate_compatibility_field(
        skill_path, frontmatter
    )
    errors.extend(compat_errors)
    warnings.extend(compat_warnings)

    # Validate environment check instructions (NEW)
    env_warnings = validate_environment_check(skill_path, frontmatter)
    warnings.extend(env_warnings)

    # Determine success
    success = len(errors) == 0

    return success, errors, warnings


def main():
    if len(sys.argv) != 2:
        print("Usage: python quick_validate.py <skill_directory>")
        print("\nValidates SKILL.md structure and compatibility declarations.")
        print("Requires: Python 3.11+, PyYAML")
        sys.exit(1)

    skill_dir = sys.argv[1]

    print(f"🔍 Validating skill at: {skill_dir}")
    print()

    success, errors, warnings = validate_skill(skill_dir)

    # Print errors
    if errors:
        print("❌ Validation Errors:")
        for i, error in enumerate(errors, 1):
            print(f"   {i}. {error}")
        print()

    # Print warnings
    if warnings:
        print("⚠️  Warnings:")
        for i, warning in enumerate(warnings, 1):
            print(f"   {i}. {warning}")
        print()

    # Print result
    if success:
        if warnings:
            print("✅ Validation passed with warnings")
            print("   Address warnings to improve skill quality.")
        else:
            print("✅ Skill is valid!")
        sys.exit(0)
    else:
        print("❌ Validation failed")
        print("   Fix the errors above before packaging.")
        sys.exit(1)


if __name__ == "__main__":
    main()
