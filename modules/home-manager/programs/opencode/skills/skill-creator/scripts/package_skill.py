#!/usr/bin/env python3
"""
Package Skill - Create distributable .skill file from skill directory

Validates skill structure and packages into a .skill file (ZIP format).

Usage:
    package_skill.py <skill-directory> [output-directory]

Examples:
    package_skill.py my-skill/
    package_skill.py my-skill/ ./dist

Requires: Python 3.11+, PyYAML (for validation)
"""

import sys
import zipfile
from pathlib import Path

# Check Python version
if sys.version_info < (3, 11):
    print("❌ Error: Python 3.11 or higher is required")
    print(f"   Current version: {sys.version_info.major}.{sys.version_info.minor}")
    sys.exit(1)

# Import validation function
try:
    # Try to import from same directory
    script_dir = Path(__file__).parent
    sys.path.insert(0, str(script_dir))
    from quick_validate import validate_skill
except ImportError:
    print("❌ Error: Could not import quick_validate.py")
    print("   Ensure quick_validate.py is in the same directory as package_skill.py")
    sys.exit(1)


def package_skill(skill_dir, output_dir=None):
    """
    Package skill directory into .skill file.

    Args:
        skill_dir: Path to skill directory
        output_dir: Optional output directory (defaults to current directory)

    Returns:
        Path to created .skill file, or None if error
    """
    skill_path = Path(skill_dir).resolve()
    skill_name = skill_path.name

    # Determine output path
    if output_dir:
        output_path = Path(output_dir).resolve()
        output_path.mkdir(parents=True, exist_ok=True)
    else:
        output_path = Path.cwd()

    skill_file = output_path / f"{skill_name}.skill"

    # Check if skill directory exists
    if not skill_path.exists():
        print(f"❌ Error: Skill directory not found: {skill_path}")
        return None

    if not skill_path.is_dir():
        print(f"❌ Error: Not a directory: {skill_path}")
        return None

    # Validate skill before packaging
    print("🔍 Validating skill...")
    success, errors, warnings = validate_skill(skill_path)

    if not success:
        print("\n❌ Validation failed with errors:")
        for i, error in enumerate(errors, 1):
            print(f"   {i}. {error}")
        print("\n⛔ Packaging aborted. Fix validation errors and try again.")
        return None

    if warnings:
        print("\n⚠️  Validation passed with warnings:")
        for i, warning in enumerate(warnings, 1):
            print(f"   {i}. {warning}")
        print()
    else:
        print("✅ Validation passed\n")

    # Create .skill file (ZIP format)
    print(f"📦 Packaging skill: {skill_name}")

    try:
        with zipfile.ZipFile(skill_file, "w", zipfile.ZIP_DEFLATED) as zf:
            # Add all files maintaining directory structure
            for file_path in skill_path.rglob("*"):
                if file_path.is_file():
                    # Calculate relative path for archive
                    arcname = skill_name / file_path.relative_to(skill_path)
                    zf.write(file_path, arcname)
                    print(f"   Added: {file_path.relative_to(skill_path)}")

        print(f"\n✅ Successfully packaged: {skill_file}")
        print(f"   Size: {skill_file.stat().st_size:,} bytes")

        return skill_file

    except Exception as e:
        print(f"\n❌ Error during packaging: {e}")
        if skill_file.exists():
            skill_file.unlink()  # Clean up partial file
        return None


def main():
    if len(sys.argv) < 2:
        print("Usage: python package_skill.py <skill-directory> [output-directory]")
        print("\nPackages a skill directory into a distributable .skill file.")
        print("\nExamples:")
        print("  package_skill.py my-skill/")
        print("  package_skill.py my-skill/ ./dist")
        print("\nThe skill will be validated before packaging.")
        print("Packaging will abort if validation fails.")
        print("\nRequires: Python 3.11+, PyYAML")
        sys.exit(1)

    skill_dir = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else None

    print(f"🚀 Packaging Skill")
    print(f"   Source: {skill_dir}")
    print(f"   Output: {output_dir or 'current directory'}")
    print(f"   Python: {sys.version_info.major}.{sys.version_info.minor}")
    print()

    result = package_skill(skill_dir, output_dir)

    if result:
        print("\n✅ Packaging complete!")
        print(f"   Distribute: {result}")
        sys.exit(0)
    else:
        print("\n❌ Packaging failed")
        sys.exit(1)


if __name__ == "__main__":
    main()
