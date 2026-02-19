# Compatibility Assessment Guide

Complete guide for determining and documenting skill dependencies.

## Quick Reference Decision Tree

```
Does scripts/ directory exist?
├─ No
│  └─ Compatibility: "No external dependencies. Works in all environments."
│
└─ Yes
   │
   ├─ Contains .py files?
   │  ├─ Yes → Add "Required: Python 3.11+"
   │  │       └─ Analyze imports for external packages
   │  └─ No → Continue
   │
   ├─ Contains .js files?
   │  ├─ Yes → Add "Required: Node.js 22+"
   │  │       └─ Analyze requires/imports for npm packages
   │  └─ No → Continue
   │
   ├─ Contains .sh files?
   │  ├─ Yes → Add "Required: Bash"
   │  │       └─ Check for external tool usage (git, docker, etc.)
   │  └─ No → Continue
   │
   └─ Contains .rb, .pl, .php, .ps1, .r, .lua files?
      ├─ Yes → Add language name to compatibility
      │       └─ Manually list dependencies
      └─ No → "No recognized scripts"
```

## Three Assessment Methods

Choose the method that best fits your workflow:

### Method 1: Automated Script Analysis (Recommended)

Run the assessment helper script:

```bash
python scripts/assess_compatibility.py <skill-directory>
```

**Output Example:**
```json
{
  "scripts_found": true,
  "languages": {
    "Python": {
      "version": "3.11+",
      "files": ["process.py", "utils.py"],
      "dependencies": ["PyYAML", "requests"]
    }
  },
  "suggested_compatibility": "Required: Python 3.11+ (PyYAML, requests)",
  "confidence": "high",
  "warnings": []
}
```

**How to use the output:**
1. Copy the `suggested_compatibility` text
2. Paste into SKILL.md frontmatter compatibility field
3. Review warnings if any
4. Verify the detected dependencies are correct
5. Add environment check instructions to SKILL.md body

**Limitations:**
- Heuristic-based detection (may miss dynamic imports)
- Cannot detect subprocess-invoked tools
- Python stdlib detection is best-effort (covers common modules)
- Manual review recommended for complex dependencies

**When to use:** Best for Python, Node.js, or Bash-based skills with straightforward dependencies.

### Method 2: SubAgent Delegation

If SubAgent capability is available, delegate the analysis:

**Task Prompt:**
```
Analyze the skill at [path] to determine compatibility requirements.

Steps to perform:
1. List all files in scripts/ directory, organized by extension
2. For Python files (.py):
   - Extract all import and from statements
   - Categorize as Python stdlib vs external packages
   - Common stdlib: os, sys, pathlib, json, re, datetime, etc.
3. For Node.js files (.js):
   - Extract require() and import statements
   - Categorize as Node.js built-ins vs npm packages
   - Built-ins: fs, path, http, crypto, etc.
4. For Bash files (.sh):
   - Identify external command usage (grep, sed, git, docker, etc.)
5. Review SKILL.md body for mentions of external tools
6. Check for platform-specific requirements

Output format:
- Scripts found: [list with language and file count]
- External dependencies detected: [categorized by language]
- Suggested compatibility declaration: [formatted text ready for YAML]
- Confidence level: [high/medium/low with reasoning]
- Recommendations: [any additional notes]
```

**Expected Response:**
The SubAgent should provide a structured analysis with:
- Clear categorization of dependencies
- Distinction between stdlib/built-ins and external packages
- Ready-to-use compatibility text
- Confidence assessment with explanation

**When to use:** Best for complex skills with multiple languages or when you want thorough analysis with explanations.

### Method 3: Manual Assessment

Follow this step-by-step checklist:

#### Step 1: Identify Script Languages

```bash
# List all scripts
ls -la scripts/

# Count by extension
find scripts/ -type f -name "*.py" | wc -l    # Python
find scripts/ -type f -name "*.js" | wc -l    # Node.js
find scripts/ -type f -name "*.sh" | wc -l    # Bash
# Repeat for .rb, .pl, .php, .ps1, .r, .lua
```

#### Step 2: For Python Scripts

**Check imports:**
```bash
# Extract all import statements
grep -h "^import\|^from" scripts/*.py | sort -u

# Or with more context
grep -n "^import\|^from" scripts/*.py
```

**Categorize imports:**
- **Python stdlib** (no installation needed): os, sys, pathlib, json, re, datetime, collections, itertools, functools, typing, argparse, logging, subprocess, shutil, io
- **External packages** (require installation): Everything else

**Determine version requirement:**
- Default: Python 3.11+ (recommended for new skills)
- Check if specific features require higher versions
- Never use versions approaching EOL (3.10 EOL: October 2026)

#### Step 3: For Node.js Scripts

**Check requires/imports:**
```bash
# Extract require statements
grep -h "require(" scripts/*.js | sort -u

# Extract import statements
grep -h "^import" scripts/*.js | sort -u
```

**Categorize modules:**
- **Node.js built-ins** (no installation needed): fs, path, http, https, crypto, os, util, events, stream, buffer, child_process
- **npm packages** (require installation): Everything else

**Version requirement:**
- Default: Node.js 22+ (current LTS)
- EOL: April 2027

#### Step 4: For Bash Scripts

**Check for external tools:**
```bash
# Search for common tool usage
grep -h -E "(awk|sed|grep|cut|sort|jq|git|docker|curl|wget)" scripts/*.sh
```

**Common tools to look for:**
- **Likely present**: grep, sed, awk, cut, sort, find, tar, gzip
- **May need listing**: git, docker, jq, curl, wget, imagemagick, ffmpeg

**Version requirement:**
- Usually not specified (POSIX-compatible)
- Note if bash-specific features are used (vs sh)

#### Step 5: For Other Languages

**Ruby (.rb), Perl (.pl), PHP (.php), PowerShell (.ps1), R (.r), Lua (.lua):**

For these languages, automated analysis is not provided. Manually:
1. Read the script files
2. Identify require/import/use statements
3. Categorize as built-in vs external
4. List external dependencies in compatibility field

#### Step 6: Document Findings

Format your findings in the compatibility field:

**Single language:**
```yaml
compatibility: |
  Required: Python 3.11+, PyYAML, requests
```

**Multiple languages:**
```yaml
compatibility: |
  Required: Python 3.11+ (PyYAML, requests), Node.js 22+ (express)
```

**External tools:**
```yaml
compatibility: |
  Required: Bash, git, docker
```

**No dependencies:**
```yaml
compatibility: |
  No external dependencies. Works in all environments with standard AI Agent tools.
```

**When to use:** Best when other methods are unavailable or for simple skills.

## Language-Specific Guidelines

### Python (3.11+)

**Version Requirement:**
- **Required:** Python 3.11+
- **EOL:** October 2027
- **Why:** Long-term support, performance improvements, better error messages
- **Alternative:** Python 3.10+ (reaches EOL October 2026)

**Common stdlib modules (no installation needed):**
```
os, sys, pathlib, re, json, datetime, time, collections, itertools,
functools, typing, argparse, logging, subprocess, shutil, io, tempfile,
threading, asyncio, urllib, uuid, hashlib, base64, pickle, copy, enum
```

**Import analysis technique:**
```bash
# Quick stdlib check
grep "^import os\|^import sys\|^import pathlib" scripts/*.py

# Find potential external packages
grep -h "^import\|^from" scripts/*.py | \
  grep -v "^import os\|^import sys\|^import pathlib\|^import re\|^import json" | \
  sort -u
```

**Common external packages:**
- **Data:** pandas, numpy, scipy
- **Web:** requests, aiohttp, flask, fastapi
- **Files:** PyYAML, lxml, Pillow, openpyxl
- **CLI:** click, typer

**Environment check instructions template:**
```markdown
## Environment Requirements

Check Python availability:

```bash
python3 --version  # Should be 3.11 or higher
pip3 show PyYAML requests  # Check required packages
```

If Python 3.11+ is not available:
> "This skill requires Python 3.11+. Please install from python.org or via your
> system package manager (apt, brew, etc.)."

If packages are missing:
> "Install required packages with: pip3 install PyYAML requests"
```

### Node.js (22+)

**Version Requirement:**
- **Required:** Node.js 22+
- **EOL:** April 2027
- **Why:** Current LTS with long-term support
- **Alternative:** Node.js 20+ (reaches EOL April 2026)

**Built-in modules (no installation needed):**
```
assert, buffer, child_process, cluster, crypto, dgram, dns, events,
fs, http, https, net, os, path, querystring, readline, stream,
string_decoder, timers, tls, tty, url, util, v8, vm, zlib
```

**Import analysis technique:**
```bash
# Find require statements
grep -o "require(['\"][^'\"]*['\"])" scripts/*.js | \
  sed "s/require(['\"]//;s/['\"])//g" | sort -u

# Find import statements
grep "^import.*from" scripts/*.js | \
  sed "s/.*from ['\"]//;s/['\"].*//g" | sort -u
```

**Common npm packages:**
- **Web frameworks:** express, koa, fastify
- **HTTP clients:** axios, node-fetch
- **Utilities:** lodash, moment, uuid
- **CLI:** commander, inquirer
- **Testing:** jest, mocha

**Environment check instructions template:**
```markdown
## Environment Requirements

Check Node.js availability:

```bash
node --version  # Should be 22 or higher
npm list express axios  # Check required packages
```

If Node.js 22+ is not available:
> "This skill requires Node.js 22+. Please install from nodejs.org or via nvm."

If packages are missing:
> "Install required packages with: npm install express axios"
```

### Bash

**Version Requirement:**
- Usually not specified (POSIX-compatible)
- If using bash-specific features: "Required: Bash 4.0+"

**Common system utilities (usually available):**
```
awk, sed, grep, cut, sort, uniq, find, xargs, tar, gzip, cat, echo,
wc, head, tail, tr, test, expr
```

**External tools (may need listing):**
```
git, docker, jq, curl, wget, imagemagick, ffmpeg, pandoc, libreoffice
```

**Tool detection technique:**
```bash
# Search for external tool usage
grep -h -w -E "(git|docker|jq|curl|wget|convert|ffmpeg)" scripts/*.sh | \
  grep -v "^#" | sort -u
```

**Environment check instructions template:**
```markdown
## Environment Requirements

Check required tools:

```bash
which git docker jq  # Should show paths to executables
git --version        # Check specific versions if needed
```

If tools are missing:
> "This skill requires: git, docker, jq"
> "Install with your system package manager:"
> "- Ubuntu/Debian: apt-get install git docker.io jq"
> "- macOS: brew install git docker jq"
> "- Other: See tool-specific installation guides"
```

### Ruby, Perl, PHP, PowerShell, R, Lua

For these languages:
1. **Specify the language name** in compatibility
2. **Optionally specify version** if known requirements exist
3. **Manually list gems/modules/packages** used
4. **Provide installation instructions** in SKILL.md

**Example:**
```yaml
compatibility: |
  Required: Ruby 3.0+
  Gems: nokogiri, httparty
```

## Common Compatibility Patterns

### Pattern 1: Pure Instructions (No Scripts)

**Scenario:** SKILL.md contains only instructions, no executable scripts

**Compatibility Declaration:**
```yaml
compatibility: |
  No external dependencies. Works in all environments with standard AI Agent tools.
```

**When:** Skill provides guidance, templates, or workflows without code execution

### Pattern 2: Single-Language Python Skill

**Scenario:** Python scripts with external packages

**Compatibility Declaration:**
```yaml
compatibility: |
  Required: Python 3.11+, PyYAML, requests
  Note: Python 3.10 may work but reaches EOL in October 2026.
```

**Environment Check:**
```markdown
## Environment Requirements

```bash
python3 --version  # Requires 3.11+
pip3 show PyYAML requests
```

If missing: `pip3 install PyYAML requests`
```

### Pattern 3: Single-Language Node.js Skill

**Scenario:** Node.js scripts with npm packages

**Compatibility Declaration:**
```yaml
compatibility: |
  Required: Node.js 22+, express, axios
```

**Environment Check:**
```markdown
## Environment Requirements

```bash
node --version  # Requires 22+
npm list express axios
```

If missing: `npm install express axios`
```

### Pattern 4: Multi-Language Skill

**Scenario:** Python for data processing, Node.js for web service

**Compatibility Declaration:**
```yaml
compatibility: |
  Required: Python 3.11+ (PyYAML, pandas), Node.js 22+ (express, axios)
```

**Environment Check:**
```markdown
## Environment Requirements

**Python:**
```bash
python3 --version  # Requires 3.11+
pip3 show PyYAML pandas
```

**Node.js:**
```bash
node --version  # Requires 22+
npm list express axios
```

Install missing dependencies as shown above.
```

### Pattern 5: External Tool Dependencies

**Scenario:** Bash scripts calling git, docker, imagemagick

**Compatibility Declaration:**
```yaml
compatibility: |
  Required: Bash, git, docker, ImageMagick
  Platform: Linux or macOS (Windows via WSL)
```

**Environment Check:**
```markdown
## Environment Requirements

```bash
which git docker convert  # Check all tools
git --version
docker --version
convert --version  # ImageMagick
```

Install via system package manager if missing.
```

### Pattern 6: Platform-Specific

**Scenario:** Script requires specific OS or LibreOffice

**Compatibility Declaration:**
```yaml
compatibility: |
  Required: LibreOffice 7.0+
  Platform: Linux, macOS, or Windows
  Python 3.11+ (optional, for automation)
```

**Environment Check:**
```markdown
## Environment Requirements

LibreOffice must be installed and accessible:

```bash
# Linux
libreoffice --version

# macOS
/Applications/LibreOffice.app/Contents/MacOS/soffice --version

# Windows
"C:\Program Files\LibreOffice\program\soffice.exe" --version
```
```

## Validation and Testing

### After Determining Compatibility

1. **Update SKILL.md frontmatter** with compatibility declaration
2. **Add environment check instructions** to SKILL.md body
3. **Run validation:**
   ```bash
   python scripts/quick_validate.py <skill-directory>
   ```
4. **Address any errors or warnings**

### Testing Across Environments

**Recommended tests:**
1. **Fresh environment:** Test on a system without dependencies pre-installed
2. **Follow your instructions:** Can a user install dependencies using your guide?
3. **Version verification:** Do the specified versions actually work?
4. **Error messages:** Are they helpful when dependencies are missing?

### Common Validation Warnings

**"compatibility doesn't mention Python"**
- You have .py files but didn't list Python requirement
- Action: Add "Python 3.11+" to compatibility

**"No environment check instructions found"**
- You declared dependencies but didn't add check commands
- Action: Add "Environment Requirements" section to SKILL.md

**"compatibility field contains TODO"**
- You haven't completed the compatibility assessment
- Action: Replace TODO with actual declaration

## Troubleshooting

### "assess_compatibility.py found no external packages"

**Possible causes:**
1. All imports are stdlib (valid, no external deps needed)
2. Dynamic imports not detected (`importlib.import_module()`)
3. Imports in non-standard locations (conditional imports)

**Action:** Manually review scripts to verify

### "SubAgent gave different results than script"

**Explanation:** SubAgent may catch dynamic imports or complex patterns

**Action:** Use SubAgent results if they're more comprehensive

### "What if I'm not sure if a module is stdlib?"

**Check online:**
```bash
# Python
python3 -c "import MODULE_NAME; print(MODULE_NAME.__file__)"
# If path contains "site-packages", it's external
# If path contains "lib/python3.x/", it's probably stdlib

# Or check Python docs: docs.python.org/3/library/
```

### "Different versions have different stdlib"

**Default to newest:**
- If you require Python 3.11+, use Python 3.11 stdlib as reference
- Modules added in 3.12+ are external for your purposes

## Summary Checklist

Before finalizing your skill:

- [ ] Compatibility field exists and is complete (no TODO)
- [ ] All script languages are listed with versions
- [ ] External dependencies are enumerated
- [ ] OR "No external dependencies" is explicitly stated
- [ ] Environment check instructions are in SKILL.md body
- [ ] Installation commands are provided for each dependency
- [ ] Error messages guide users to install missing deps
- [ ] Validation passes: `python scripts/quick_validate.py .`
- [ ] (Optional) Tested in fresh environment

**You're ready to package when all boxes are checked!**
