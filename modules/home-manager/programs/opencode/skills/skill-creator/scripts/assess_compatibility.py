#!/usr/bin/env python3
"""
Compatibility Assessment Helper for AI Agents

Analyzes skill directory and outputs dependency information in JSON format.
Detects script languages and external dependencies to help generate
accurate compatibility declarations.

Usage:
    assess_compatibility.py <skill-directory>

Output: JSON with detected languages, dependencies, and suggested compatibility text

Supported Languages:
    Tier 1 (full analysis): Python (.py), Node.js (.js), Bash (.sh)
    Tier 2 (basic detection): Ruby (.rb), Perl (.pl), PHP (.php),
                              PowerShell (.ps1), R (.r), Lua (.lua)

Requires: Python 3.11+
"""

import sys
import json
import re
from pathlib import Path


# Check Python version
if sys.version_info < (3, 11):
    print(
        json.dumps(
            {
                "error": "Python 3.11+ required",
                "current_version": f"{sys.version_info.major}.{sys.version_info.minor}",
            }
        )
    )
    sys.exit(1)


# Language detection configuration
SCRIPT_LANGUAGES = {
    # Tier 1: With dependency analysis
    ".py": {"name": "Python", "version": "3.11+", "analyze": True},
    ".js": {"name": "Node.js", "version": "22+", "analyze": True},
    ".sh": {"name": "Bash", "version": None, "analyze": True},
    # Tier 2: Extension-based only
    ".rb": {"name": "Ruby", "version": None, "analyze": False},
    ".pl": {"name": "Perl", "version": None, "analyze": False},
    ".php": {"name": "PHP", "version": None, "analyze": False},
    ".ps1": {"name": "PowerShell", "version": None, "analyze": False},
    ".r": {"name": "R", "version": None, "analyze": False},
    ".lua": {"name": "Lua", "version": None, "analyze": False},
}

# Common Python standard library modules (not exhaustive, but covers common cases)
PYTHON_STDLIB = {
    "abc",
    "argparse",
    "ast",
    "asyncio",
    "base64",
    "collections",
    "copy",
    "datetime",
    "decimal",
    "enum",
    "functools",
    "glob",
    "hashlib",
    "io",
    "itertools",
    "json",
    "logging",
    "math",
    "os",
    "pathlib",
    "pickle",
    "re",
    "shutil",
    "socket",
    "string",
    "struct",
    "subprocess",
    "sys",
    "tempfile",
    "threading",
    "time",
    "typing",
    "unittest",
    "urllib",
    "uuid",
    "warnings",
    "weakref",
    "xml",
    "zipfile",
}

# Node.js built-in modules
NODEJS_BUILTINS = {
    "assert",
    "buffer",
    "child_process",
    "cluster",
    "crypto",
    "dgram",
    "dns",
    "events",
    "fs",
    "http",
    "https",
    "net",
    "os",
    "path",
    "querystring",
    "readline",
    "stream",
    "string_decoder",
    "timers",
    "tls",
    "tty",
    "url",
    "util",
    "v8",
    "vm",
    "zlib",
}

# Common system tools (for Bash analysis)
COMMON_SYSTEM_TOOLS = {
    "awk",
    "sed",
    "grep",
    "cut",
    "sort",
    "uniq",
    "find",
    "xargs",
    "tar",
    "gzip",
    "curl",
    "wget",
    "git",
    "docker",
    "jq",
}


def detect_script_languages(scripts_dir):
    """
    Detect all script languages in directory.
    Returns dict with language info and file lists.
    Raises exception if critical files cannot be read.
    """
    if not scripts_dir.exists() or not scripts_dir.is_dir():
        return {}

    detected = {}

    for script_file in scripts_dir.iterdir():
        if not script_file.is_file():
            continue

        ext = script_file.suffix.lower()

        # Check known extensions
        if ext in SCRIPT_LANGUAGES:
            lang_info = SCRIPT_LANGUAGES[ext]
            lang_name = lang_info["name"]

            if lang_name not in detected:
                detected[lang_name] = {
                    "version": lang_info["version"],
                    "files": [],
                    "analyze": lang_info["analyze"],
                    "dependencies": [],
                }

            detected[lang_name]["files"].append(script_file.name)

        # Check shebang for extensionless files
        elif ext == "" or not ext:
            shebang = get_shebang(script_file)
            lang_name = detect_language_from_shebang(shebang)
            if lang_name:
                if lang_name not in detected:
                    detected[lang_name] = {
                        "version": None,
                        "files": [],
                        "analyze": False,
                        "dependencies": [],
                    }
                detected[lang_name]["files"].append(script_file.name)

    return detected


def get_shebang(file_path):
    """Extract shebang line from script file. Raises exception on error."""
    with open(file_path, "rb") as f:
        first_line = f.readline().decode("utf-8", errors="ignore")
        if first_line.startswith("#!"):
            return first_line.strip()
    return None


def detect_language_from_shebang(shebang):
    """Detect language from shebang line."""
    if not shebang:
        return None

    shebang = shebang.lower()

    if "python" in shebang:
        return "Python"
    elif "bash" in shebang or shebang.endswith("/sh"):
        return "Bash"
    elif "node" in shebang:
        return "Node.js"
    elif "ruby" in shebang:
        return "Ruby"
    elif "perl" in shebang:
        return "Perl"
    elif "php" in shebang:
        return "PHP"
    elif "pwsh" in shebang or "powershell" in shebang:
        return "PowerShell"

    return None


def analyze_python_imports(scripts_dir, py_files):
    """
    Extract and analyze Python import statements.
    Returns dict with 'external' and 'stdlib' package lists.
    """
    external = set()
    stdlib = set()

    for filename in py_files:
        file_path = scripts_dir / filename
        content = file_path.read_text(errors="ignore")

        # Extract import statements using regex
        # Matches: import foo, from foo import bar, from foo.bar import baz
        import_pattern = r"^\s*(?:import|from)\s+([a-zA-Z_][a-zA-Z0-9_]*)"
        matches = re.findall(import_pattern, content, re.MULTILINE)

        for module in matches:
            if module in PYTHON_STDLIB:
                stdlib.add(module)
            else:
                external.add(module)

    return {"external": sorted(external), "stdlib": sorted(stdlib)}


def analyze_nodejs_imports(scripts_dir, js_files):
    """
    Extract and analyze Node.js require/import statements.
    Returns dict with 'external' and 'builtin' package lists.
    """
    external = set()
    builtin = set()

    for filename in js_files:
        file_path = scripts_dir / filename
        content = file_path.read_text(errors="ignore")

        # Extract require() and import statements
        # Matches: require('foo'), require("foo"), import foo from 'bar', import 'foo'
        require_pattern = r"require\s*\(\s*['\"]([^'\"]+)['\"]\s*\)"
        import_pattern = r"import\s+(?:.*\s+from\s+)?['\"]([^'\"]+)['\"]"

        requires = re.findall(require_pattern, content)
        imports = re.findall(import_pattern, content)

        for module in requires + imports:
            # Remove relative path indicators and get base module
            base_module = module.lstrip("./").split("/")[0]

            if base_module in NODEJS_BUILTINS or base_module.startswith("node:"):
                builtin.add(base_module)
            elif not module.startswith("."):  # Skip relative imports
                external.add(base_module)

    return {"external": sorted(external), "builtin": sorted(builtin)}


def analyze_shell_commands(scripts_dir, sh_files):
    """
    Analyze Bash scripts for external command usage.
    Returns dict with 'tools' list.
    """
    tools = set()

    for filename in sh_files:
        file_path = scripts_dir / filename
        content = file_path.read_text(errors="ignore")

        # Look for common external tools
        for tool in COMMON_SYSTEM_TOOLS:
            # Simple heuristic: look for tool name as standalone word
            pattern = r"\b" + re.escape(tool) + r"\b"
            if re.search(pattern, content):
                tools.add(tool)

    return {"tools": sorted(tools)}


def generate_compatibility_text(languages, analyses):
    """
    Generate human-readable compatibility declaration.

    Args:
        languages: Dict of detected languages
        analyses: Dict of analysis results (imports, tools, etc.)

    Returns:
        String with suggested compatibility text
    """
    if not languages:
        return "No external dependencies. Works in all environments with standard AI Agent tools."

    parts = []

    # Add language requirements
    for lang_name, lang_info in sorted(languages.items()):
        if lang_info["version"]:
            parts.append(f"{lang_name} {lang_info['version']}")
        else:
            parts.append(lang_name)

    # Add external dependencies
    deps = []

    if "Python" in analyses and analyses["Python"].get("external"):
        deps.extend(analyses["Python"]["external"])

    if "Node.js" in analyses and analyses["Node.js"].get("external"):
        deps.extend(analyses["Node.js"]["external"])

    if "Bash" in analyses and analyses["Bash"].get("tools"):
        deps.extend(analyses["Bash"]["tools"])

    if deps:
        parts.append(f"({', '.join(deps)})")

    return "Required: " + ", ".join(parts)


def assess_compatibility(skill_dir):
    """
    Analyze skill directory and return compatibility assessment.

    Args:
        skill_dir: Path to skill directory

    Returns:
        Dict with assessment results
    """
    skill_path = Path(skill_dir)
    scripts_dir = skill_path / "scripts"

    result = {
        "scripts_found": False,
        "languages": {},
        "analyses": {},
        "suggested_compatibility": None,
        "confidence": "high",
        "warnings": [],
    }

    if not scripts_dir.exists():
        result["suggested_compatibility"] = (
            "No external dependencies. "
            "Works in all environments with standard AI Agent tools."
        )
        return result

    # Detect languages
    result["scripts_found"] = True
    languages = detect_script_languages(scripts_dir)
    result["languages"] = languages

    if not languages:
        result["suggested_compatibility"] = (
            "No external dependencies. "
            "Works in all environments with standard AI Agent tools."
        )
        result["warnings"].append(
            "scripts/ directory exists but no recognized script files found"
        )
        return result

    # Perform language-specific analysis
    for lang_name, lang_info in languages.items():
        if not lang_info["analyze"]:
            continue

        if lang_name == "Python":
            analysis = analyze_python_imports(scripts_dir, lang_info["files"])
            result["analyses"]["Python"] = analysis

            if not analysis["external"]:
                result["confidence"] = "medium"
                result["warnings"].append(
                    "Python analysis found no external packages. "
                    "Verify this is correct (dynamic imports may be missed)."
                )

        elif lang_name == "Node.js":
            analysis = analyze_nodejs_imports(scripts_dir, lang_info["files"])
            result["analyses"]["Node.js"] = analysis

            if not analysis["external"]:
                result["confidence"] = "medium"
                result["warnings"].append(
                    "Node.js analysis found no external packages. "
                    "Verify this is correct (dynamic requires may be missed)."
                )

        elif lang_name == "Bash":
            analysis = analyze_shell_commands(scripts_dir, lang_info["files"])
            result["analyses"]["Bash"] = analysis

    # Generate suggested compatibility text
    result["suggested_compatibility"] = generate_compatibility_text(
        languages, result["analyses"]
    )

    return result


def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Usage: assess_compatibility.py <skill-directory>"}))
        sys.exit(1)

    skill_dir = sys.argv[1]

    try:
        result = assess_compatibility(skill_dir)
        print(json.dumps(result, indent=2))
        sys.exit(0)
    except Exception as e:
        print(json.dumps({"error": str(e), "type": type(e).__name__}))
        sys.exit(1)


if __name__ == "__main__":
    main()
