#!/usr/bin/env python3
"""
Improved Skill Initializer - Creates a new skill from template with mandatory compatibility field

Usage:
    init_skill.py <skill-name> --path <path>

Examples:
    init_skill.py my-new-skill --path skills/public
    init_skill.py my-api-helper --path skills/private
    init_skill.py custom-skill --path /custom/location

Requires: Python 3.11+
"""

import sys
from pathlib import Path


# Check Python version
if sys.version_info < (3, 11):
    print("❌ Error: Python 3.11 or higher is required")
    print(f"   Current version: {sys.version_info.major}.{sys.version_info.minor}")
    print("   Please upgrade Python or use a newer environment")
    sys.exit(1)


EXAMPLE_SCRIPT = '''#!/usr/bin/env python3
"""
Example helper script for {skill_name}

This is a placeholder script that can be executed directly.
Replace with actual implementation or delete if not needed.

Example real scripts from other skills:
- PDF processing: fill_form_fields.py, extract_text.py
- Document processing: convert.py, validate.py
"""

def main():
    print("This is an example script for {skill_name}")
    # TODO: Add actual script logic here
    # This could be data processing, file conversion, API calls, etc.

if __name__ == "__main__":
    main()
'''

EXAMPLE_REFERENCE = """# Reference Documentation for {skill_title}

This is a placeholder for detailed reference documentation.
Replace with actual reference content or delete if not needed.

Example real reference docs from other skills:
- API references with endpoint documentation
- Database schema documentation
- Comprehensive workflow guides
- Domain-specific knowledge and policies

## When Reference Docs Are Useful

Reference docs are ideal for:
- Comprehensive API documentation
- Detailed workflow guides
- Complex multi-step processes
- Information too lengthy for main SKILL.md
- Content that's only needed for specific use cases

## Structure Suggestions

### API Reference Example
- Overview
- Authentication
- Endpoints with examples
- Error codes
- Rate limits

### Workflow Guide Example
- Prerequisites
- Step-by-step instructions
- Common patterns
- Troubleshooting
- Best practices
"""

EXAMPLE_ASSET = """# Example Asset File

This placeholder represents where asset files would be stored.
Replace with actual asset files (templates, images, fonts, etc.) or delete if not needed.

Asset files are NOT intended to be loaded into context, but rather used within
the output AI Agents produce.

Example asset files from other skills:
- Brand guidelines: logo.png, slides_template.pptx
- Frontend builder: boilerplate HTML/React project directories
- Typography: custom-font.ttf, font-family.woff2
- Data: sample_data.csv, test_dataset.json

## Common Asset Types

- Templates: .pptx, .docx, boilerplate directories
- Images: .png, .jpg, .svg, .gif
- Fonts: .ttf, .otf, .woff, .woff2
- Boilerplate code: Project directories, starter files
- Icons: .ico, .svg
- Data files: .csv, .json, .xml, .yaml

Note: This is a text placeholder. Actual assets can be any file type.
"""


def title_case_skill_name(skill_name):
    """Convert hyphenated skill name to Title Case for display."""
    return " ".join(word.capitalize() for word in skill_name.split("-"))


def load_template():
    """Load SKILL.md template from templates directory."""
    script_dir = Path(__file__).parent
    template_path = script_dir.parent / "templates" / "SKILL.md.template"

    if not template_path.exists():
        print(f"❌ Error: Template not found at {template_path}")
        print("   Skill structure may be corrupted.")
        sys.exit(1)

    try:
        return template_path.read_text()
    except Exception as e:
        print(f"❌ Error: Could not read template: {e}")
        sys.exit(1)


def init_skill(skill_name, path):
    """
    Initialize a new skill directory with template SKILL.md.

    Args:
        skill_name: Name of the skill (kebab-case)
        path: Path where the skill directory should be created

    Returns:
        Path to created skill directory, or None if error
    """
    # Determine skill directory path
    skill_dir = Path(path).resolve() / skill_name

    # Check if directory already exists
    if skill_dir.exists():
        print(f"❌ Error: Skill directory already exists: {skill_dir}")
        return None

    # Create skill directory
    try:
        skill_dir.mkdir(parents=True, exist_ok=False)
        print(f"✅ Created skill directory: {skill_dir}")
    except Exception as e:
        print(f"❌ Error creating directory: {e}")
        return None

    # Load and process template
    skill_title = title_case_skill_name(skill_name)
    template_content = load_template()

    # Use template file
    skill_content = template_content.replace("{{SKILL_NAME}}", skill_name)
    skill_content = skill_content.replace("{{SKILL_TITLE}}", skill_title)

    # Create SKILL.md
    skill_md_path = skill_dir / "SKILL.md"
    try:
        skill_md_path.write_text(skill_content)
        print("✅ Created SKILL.md with compatibility field template")
    except Exception as e:
        print(f"❌ Error creating SKILL.md: {e}")
        return None

    # Create resource directories with example files
    try:
        # Create scripts/ directory with example script
        scripts_dir = skill_dir / "scripts"
        scripts_dir.mkdir(exist_ok=True)
        example_script = scripts_dir / "example.py"
        example_script.write_text(EXAMPLE_SCRIPT.format(skill_name=skill_name))
        example_script.chmod(0o755)
        print("✅ Created scripts/example.py")

        # Create references/ directory with example reference doc
        references_dir = skill_dir / "references"
        references_dir.mkdir(exist_ok=True)
        example_reference = references_dir / "api_reference.md"
        example_reference.write_text(EXAMPLE_REFERENCE.format(skill_title=skill_title))
        print("✅ Created references/api_reference.md")

        # Create assets/ directory with example asset placeholder
        assets_dir = skill_dir / "assets"
        assets_dir.mkdir(exist_ok=True)
        example_asset = assets_dir / "example_asset.txt"
        example_asset.write_text(EXAMPLE_ASSET)
        print("✅ Created assets/example_asset.txt")
    except Exception as e:
        print(f"❌ Error creating resource directories: {e}")
        return None

    # Print next steps
    print(f"\n✅ Skill '{skill_name}' initialized successfully at {skill_dir}")
    print("\n📋 Next steps:")
    print("1. Edit SKILL.md:")
    print("   - Complete the description in frontmatter")
    print("   - Update the compatibility field (REQUIRED)")
    print("   - Implement skill instructions")
    print()
    print("2. Assess compatibility requirements:")
    print(
        "   - If you have scripts, run: python scripts/assess_compatibility.py <skill-dir>"
    )
    print("   - Or follow manual assessment in references/compatibility-guide.md")
    print()
    print("3. Customize or delete example files in:")
    print("   - scripts/example.py")
    print("   - references/api_reference.md")
    print("   - assets/example_asset.txt")
    print()
    print("4. Validate when ready:")
    print(f"   python scripts/quick_validate.py {skill_dir}")
    print()
    print("5. Package for distribution:")
    print(f"   python scripts/package_skill.py {skill_dir}")

    return skill_dir


def main():
    if len(sys.argv) < 4 or sys.argv[2] != "--path":
        print("Usage: init_skill.py <skill-name> --path <path>")
        print("\nSkill name requirements:")
        print("  - Kebab-case identifier (e.g., 'my-data-analyzer')")
        print("  - Lowercase letters, digits, and hyphens only")
        print("  - Max 64 characters")
        print("  - Must match directory name exactly")
        print("\nExamples:")
        print("  init_skill.py my-new-skill --path skills/public")
        print("  init_skill.py my-api-helper --path skills/private")
        print("  init_skill.py custom-skill --path /custom/location")
        print("\nNote: Requires Python 3.11+")
        sys.exit(1)

    skill_name = sys.argv[1]
    path = sys.argv[3]

    print(f"🚀 Initializing skill: {skill_name}")
    print(f"   Location: {path}")
    print(f"   Python version: {sys.version_info.major}.{sys.version_info.minor}")
    print()

    result = init_skill(skill_name, path)

    if result:
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
