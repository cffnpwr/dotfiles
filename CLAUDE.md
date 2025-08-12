# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Essential Initial Setup

**MANDATORY PROJECT INITIALIZATION:**

🚨 **BEFORE ANY WORK**: Execute initial instructions to activate project context:

```bash
# For chezmoi project
mcp__serena__activate_project("chezmoi")
mcp__serena__check_onboarding_performed()
```

**Project Context Requirements:**
- MUST activate serena project before any code analysis or file operations
- MUST verify onboarding status to access project-specific memories
- MUST read relevant memories based on task requirements

## ⚠️ ABSOLUTE CONSTRAINTS - VIOLATION = IMMEDIATE TASK FAILURE

**CRITICAL CHEZMOI ENFORCEMENT PROTOCOL:**

🚨 **MANDATORY PRE-EXECUTION CHECK**: Before ANY file operation, you MUST verify the target path:

1. **DETECTION PHASE**: Check if any file path starts with `/Users/cffnpwr/` (home directory)
2. **BLOCKING PHASE**: If home directory path detected → IMMEDIATELY STOP → NEVER PROCEED
3. **CORRECTION PHASE**: Map home directory path to chezmoi source equivalent
4. **EXECUTION PHASE**: Edit ONLY in `/Users/cffnpwr/.local/share/chezmoi/homedir/`
5. **VERIFICATION PHASE**: Run `chezmoi diff --no-tty` to verify changes
6. **DEPLOYMENT PHASE**: Apply with `chezmoi apply --no-tty`

**VIOLATION CONSEQUENCES:**
- ANY direct home directory edit = IMMEDIATE TASK FAILURE
- NO EXCEPTIONS for "quick fixes", "temporary changes", or "urgent updates"
- MUST restart entire workflow with proper chezmoi management

**MANDATORY PATH MAPPING TABLE:**

```text
HOME DIRECTORY PATH                          → CHEZMOI SOURCE PATH
~/.zshrc                                    → homedir/dot_config/zsh/dot_zshrc
~/.config/starship.toml                     → homedir/dot_config/starship.toml
~/.ssh/config                               → homedir/private_dot_ssh/private_config
~/.Brewfile                                 → homedir/dot_Brewfile
~/.config/wezterm/wezterm.lua               → homedir/dot_config/wezterm/wezterm.lua
~/.config/zellij/config.kdl                 → homedir/dot_config/zellij/config.kdl
~/.config/mise/config.toml                  → homedir/dot_config/mise/config.toml
~/.config/sheldon/plugins.toml              → homedir/dot_config/sheldon/plugins.toml
~/.config/claude/CLAUDE.md                  → homedir/dot_config/claude/CLAUDE.md
~/.config/claude/settings.json              → homedir/dot_config/claude/settings.json
~/.config/gh/config.yml                     → homedir/dot_config/gh/private_config.yml
~/.config/gh/hosts.yml                      → homedir/dot_config/gh/private_hosts.yml
```

**ENFORCEMENT VERIFICATION CHECKLIST:**
Before completing ANY configuration task, verify:
- [ ] NO files edited in `/Users/cffnpwr/` (home directory)
- [ ] ALL edits made in `/Users/cffnpwr/.local/share/chezmoi/homedir/`
- [ ] `chezmoi diff --no-tty` executed successfully
- [ ] `chezmoi apply --no-tty` executed successfully
- [ ] Target application restarted/reloaded if necessary

## chezmoi-Specific Operation Guidelines

**REINFORCED FILE EDITING PROTOCOL:**

🔒 **ABSOLUTE PROHIBITION**: NEVER edit files in `/Users/cffnpwr/` (home directory)
✅ **MANDATORY LOCATION**: ALWAYS edit in `/Users/cffnpwr/.local/share/chezmoi/homedir/`

**COMMAND EXECUTION REQUIREMENTS:**
YOU MUST: Always use `--no-tty` option when running chezmoi commands

**STEP-BY-STEP ENFORCEMENT WORKFLOW:**
When user requests ANY configuration change:

1. **STOP & ANALYZE**: Before any action, identify home directory paths
2. **PATH TRANSLATION**: Convert home paths to chezmoi source paths using mapping table above
3. **SOURCE EDIT**: Edit ONLY files in `homedir/` directory
4. **VERIFICATION**: Run `chezmoi diff --no-tty` to preview changes
5. **DRY RUN TEST**: Execute `chezmoi apply --dry-run --no-tty` for safety
6. **DEPLOYMENT**: Apply with `chezmoi apply --no-tty`
7. **VALIDATION**: Verify target application functionality

**CRITICAL PATH TRANSLATION EXAMPLES:**
```
USER REQUEST                                 → CORRECT ACTION
"edit ~/.zshrc"                             → Edit homedir/dot_config/zsh/dot_zshrc
"modify ~/.config/starship.toml"            → Edit homedir/dot_config/starship.toml
"change SSH config"                         → Edit homedir/private_dot_ssh/private_config
"update Brewfile"                           → Edit homedir/dot_Brewfile
"change Wezterm settings"                   → Edit homedir/dot_config/wezterm/wezterm.lua
```

**SAFETY PROTOCOLS:**
YOU MUST: Create backups before critical system configuration changes
YOU MUST: Apply system-wide changes (zsh, ssh, etc.) incrementally

## Sensitive File Operation Safety Guidelines

FOR SENSITIVE FILES:

private_* files (sensitive but not encrypted files):

YOU MUST: Get user permission before outputting content to logs.

YOU MUST: Never display the content of confidential information (passwords,
tokens, etc.).

YOU MUST: Editing can be done with normal chezmoi operations.

encrypted_* files (actually encrypted files):

YOU MUST: Use chezmoi edit command (direct editing prohibited).

YOU MUST: Always verify encryption status after editing.

YOU MUST: Never display content in plain text.

YOU MUST: Verify integrity with `chezmoi verify` after encryption
operations.

NEVER: Output confidential information to diff or logs for any files.
NEVER: Display encrypted file content in plain text.

## Project Overview

This repository is a personal dotfiles project managed with **chezmoi**.
It provides a comprehensive configuration setup for macOS development
environment, integrating shell configurations, development tools, and
application settings.

## Architecture

### Core Components

- **chezmoi**: Dotfiles management system
- **age**: Private file encryption
- **Git**: Version control

### File Naming Conventions

- `dot_*`: Files/directories that become `.` prefixed in home directory
  (e.g., `dot_Brewfile` → `~/.Brewfile`)
- `private_*`: Files that contain sensitive information
  (SSH keys, credentials)
- `encrypted_*`: Files that are actually encrypted with age
- `*.tmpl`: Template files with variable expansion

### Directory Structure

```text
/Users/cffnpwr/.local/share/chezmoi/
├── 📄 Core Repository Files
│   ├── .chezmoiroot                      # Specifies homedir as source root
│   ├── .editorconfig                     # Editor settings (2-space indent, LF)
│   ├── CLAUDE.md                         # Project-specific Claude instructions
│   ├── LICENSE                           # License file
│   └── README.md                         # Project documentation
│
└── 📂 homedir/ (33 files total)          # Main dotfiles directory
    │
    ├── 🔧 Configuration Root Files
    │   ├── .chezmoi.toml.tmpl            # chezmoi configuration template
    │   ├── .chezmoiignore                # chezmoi ignore patterns
    │   ├── dot_Brewfile                  # Homebrew dependencies
    │   ├── dot_zshenv                    # Zsh environment variables
    │   └── key.txt.age                   # Encrypted private key
    │
    ├── 🚀 Automation Scripts (.chezmoiscripts/ - 6 scripts)
    │   ├── run_once_before_00_decrypt_private_key.sh.tmpl
    │   ├── run_once_00_install_homebrew.sh.tmpl
    │   ├── run_once_00_setup_macos_settings.sh.tmpl
    │   ├── run_once_03_setup_claude_code.sh.tmpl
    │   ├── run_onchange_01_brew_bundle.sh.tmpl
    │   └── run_onchange_02_mise_install.sh.tmpl
    │
    ├── 🛡️ Private SSH Configuration (private_dot_ssh/ - 7 files)
    │   ├── conf.d/                       # Modular SSH configuration
    │   │   ├── 00-common                 # Common SSH settings
    │   │   ├── 01-home                   # Home environment settings
    │   │   ├── 02-tmcit                  # School environment settings
    │   │   └── 03-git                    # Git-related settings
    │   ├── private_config                # Main SSH config (sensitive)
    │   └── rc                            # SSH RC configuration
    │
    └── ⚙️ Application Configurations (dot_config/ - 16 files)
        │
        ├── 🤖 claude/ (11 files)         # Claude Code configuration
        │   ├── CLAUDE.md                 # Global Claude instructions
        │   ├── settings.json             # Detailed permissions (86 settings)
        │   ├── commands/ (7 files)       # Custom command definitions
        │   │   ├── git/ (6 files)        # Git workflow commands
        │   │   └── reflection.md         # Reflection configuration
        │   └── instructions/ (4 files)   # Modular instruction system
        │       ├── code_quality.md       # Code standards and debugging
        │       ├── editor.md             # EditorConfig enforcement
        │       └── reminders.md          # Task guidelines
        │
        ├── 🐙 gh/ (2 files - encrypted)  # GitHub CLI configuration
        │   ├── private_config.yml        # GitHub CLI config (sensitive)
        │   └── private_hosts.yml         # GitHub hosts config (sensitive)
        │
        ├── 🛠️ mise/ (1 file)             # Development tool version management
        │   └── config.toml               # Node.js, Go, Python versions
        │
        ├── 📦 sheldon/ (1 file)          # Zsh plugin management
        │   └── plugins.toml              # Deferred loading plugin config
        │
        ├── ⭐ starship.toml (1 file)     # Prompt configuration
        │
        ├── 💻 wezterm/ (2 files)         # Terminal configuration
        │   ├── wezterm.lua               # Main configuration
        │   └── keybinds.lua              # Keybinding settings
        │
        ├── 🖥️ zellij/ (1 file)          # Terminal multiplexer
        │   └── config.kdl                # Zellij configuration
        │
        └── 🐚 zsh/ (6 files)             # Shell configuration
            ├── dot_zshenv.tmpl           # Environment template
            ├── dot_zshrc                 # Main Zsh configuration
            └── plugins/                  # Custom plugins
                ├── alias.zsh             # Alias definitions
                ├── bindkey.zsh           # Key bindings
                ├── peco.zsh              # Peco integration
                └── vscode.zsh            # VS Code integration
```

### File Naming Patterns

- `dot_*`: Files/directories that become `.` prefixed in home directory
- `private_*`: Files containing sensitive information
- `encrypted_*`: Files that are actually encrypted with age
- `*.tmpl`: Template files with variable expansion (7 files total)
- `run_once_*`: Scripts that run only once during initial setup
- `run_onchange_*`: Scripts that run when configuration files change

### Script Execution Order

1. `run_once_before_*` → Pre-setup (key decryption)
2. `run_once_*` → Initial setup (Homebrew, macOS settings)
3. `run_onchange_*` → Ongoing maintenance (package updates, mise sync)

### Key Configuration Files

- `.chezmoiroot`: Specifies `homedir` as the source root directory
- `dot_Brewfile`: Homebrew dependencies (brew, cask, mas packages)
- `dot_config/mise/config.toml`: Development tools version management
  (Node.js, Go, Python)
- `dot_config/sheldon/plugins.toml`: Zsh plugin management with
  deferred loading
- `dot_config/starship.toml`: Custom prompt configuration with themes
- `dot_config/wezterm/`: Terminal configuration with Zellij integration
- `dot_config/zsh/`: Zsh configuration with plugins and aliases

## Common Commands

### chezmoi Operations

YOU MUST: Always use `--no-tty` option when running chezmoi commands to
ensure proper execution in non-interactive environments.

```bash
# Preview changes before applying
chezmoi diff --no-tty

# Apply changes to home directory
chezmoi apply --no-tty

# Dry run to check what would be changed
chezmoi apply --dry-run --no-tty

# Add new file to management
chezmoi add --no-tty ~/.config/example

# Sync with remote repository
chezmoi update --no-tty

# Re-run scripts (useful for brew bundle updates)
chezmoi state delete-bucket --bucket=entryState --no-tty
chezmoi apply --no-tty
```

### Encrypted File Operations

```bash
# Edit encrypted files
chezmoi edit ~/.ssh/config

# View encrypted file contents
chezmoi cat ~/.ssh/config
```

### Package Management

```bash
# Update Homebrew packages from Brewfile
brew bundle --file ~/.Brewfile

# Update mise-managed development tools
mise upgrade

# Update Zsh plugins (via Sheldon)
sheldon update

# Install missing packages and remove unused ones
brew bundle --file ~/.Brewfile --cleanup

# Check for outdated packages
brew outdated
mas outdated
```

## Development Environment

### Primary Tools

- **Shell**: Zsh + Starship (prompt) + Sheldon
  (plugin manager with deferred loading)
- **Terminal**: Wezterm (auto-starts Zellij session)
- **Multiplexer**: Zellij (attached as "wezterm" session)
- **Version Manager**: mise (Node.js 22, Go 1.24.1, Python via uv, pnpm 10)
- **Package Manager**: pnpm (Node.js), Homebrew (system packages)
- **File Manager**: eza (with icons and git status)
- **Editor**: VS Code Insiders (aliased as `code`)

### Shell Configuration Architecture

- **Zsh Performance**: Uses Sheldon's deferred loading and caching system
- **Plugin Loading**: Plugins are loaded via `zsh-defer` for faster startup
- **Cache System**: Sheldon generates cached plugin source for performance
- **Integration**: Mise, Starship, and Homebrew are initialized
  through Sheldon

### Editor Configuration

Follow `.editorconfig` in project root:

- Indentation: 2 spaces
- Line endings: LF
- Character encoding: UTF-8
- Trim trailing whitespace, insert final newline

## Development Guidelines

### File Editing

**ULTIMATE FILE EDITING ENFORCEMENT:**

⛔ **TOTAL PROHIBITION**: NEVER edit files in `/Users/cffnpwr/` (home directory)
✅ **EXCLUSIVE LOCATION**: ONLY edit in `/Users/cffnpwr/.local/share/chezmoi/homedir/`

**ZERO-TOLERANCE CONFIGURATION PROTOCOL:**
When user requests any configuration change:
1. **IMMEDIATE STOP** - Halt any home directory path detection
2. **MANDATORY MAPPING** - Use PATH MAPPING TABLE from constraints section
3. **SOURCE-ONLY EDIT** - Modify files exclusively in `homedir/` directory
4. **CHEZMOI DEPLOYMENT** - Apply using proper chezmoi workflow with verification

**NAMING CONVENTIONS**:
- Use `private_` prefix for files containing sensitive information
- Use `encrypted_` prefix for files that require actual encryption
- Use `dot_` prefix for dotfiles (files starting with . in home directory)

**DEPLOYMENT WORKFLOW**:
1. Edit files in `homedir/` directory
2. Test changes with `chezmoi diff --no-tty`
3. Validate with `chezmoi apply --dry-run --no-tty`
4. Deploy with `chezmoi apply --no-tty`

### Working with Specific Components

- **Brewfile**: Add packages to `homedir/dot_Brewfile`, then run
  `brew bundle --file ~/.Brewfile`
- **Zsh plugins**: Update `dot_config/sheldon/plugins.toml`, plugins
  auto-load via cache system
- **SSH configs**: Edit sensitive files under `private_dot_ssh/` using
  appropriate chezmoi commands
- **Development tools**: Update versions in `dot_config/mise/config.toml`

### Commit Convention

Use Conventional Commits + Gitmoji format:

```text
<type> <emoji>: <Japanese message in noun form>
```

Examples:

- `feat ✨: Wezterm設定の追加`
- `fix 🐛: Zsh補完設定の修正`
- `perf ⚡: Sheldonプラグイン起動の最適化`

## Claude Code Integration

### Advanced Permission System

The `dot_config/claude/settings.json` contains 86 granular permission settings that control Claude Code's access to system resources, MCP servers, and tool capabilities. Key permission categories:

- **MCP Server Access**: GitHub, Git, IDE, RFC documentation
- **File System Operations**: Read/write restrictions with path-based controls
- **Network Access**: Controlled web search and fetch capabilities
- **Shell Command Execution**: Bash access with security constraints

### Custom Command System

Located in `dot_config/claude/commands/`, provides specialized workflows:

#### Git Commands (`git/` directory - 6 commands)
- **Commit workflows**: Automated staging, conventional commits
- **Branch management**: Creation, switching, merging operations
- **Repository operations**: Status checking, diff analysis
- **Pull request workflows**: Creation, review, merge processes

#### Reflection System (`reflection.md`)
- **Session analysis**: Task completion tracking
- **Learning integration**: Pattern recognition for common workflows
- **Performance optimization**: Command usage analysis

### Modular Instruction Architecture

The `instructions/` directory provides specialized guidance modules:

- **`code_quality.md`**: Error handling, debugging protocols, web search requirements
- **`editor.md`**: EditorConfig enforcement, formatting standards
- **`reminders.md`**: Task management, file creation constraints

### Template System Integration

Claude Code leverages chezmoi's template system for dynamic configuration:

- **Environment detection**: OS-specific settings (Darwin/Linux)
- **Conditional loading**: CI environment vs. interactive mode
- **Variable expansion**: User-specific paths and preferences
- **Age encryption**: Automatic key management for sensitive files

### MCP Server Configuration

Configured MCP servers provide extended capabilities:

- **GitHub integration**: Repository management, issue tracking, PR workflows
- **Git operations**: Advanced version control with safety checks
- **IDE integration**: VS Code diagnostics, code execution
- **RFC documentation**: Standards lookup and reference

## Container-Use Environment Testing

### Linux Environment Testing Protocol

This section describes how to test dotfiles deployment in Linux environments using Claude Code's container-use functionality.

#### Secret Management for Container Testing

**Encryption Key Injection Method:**

```bash
# Set environment variable with actual decryption key
export CHEZMOI_ENCRYPT_KEY="actual-github-actions-secret-key"

# Create environment with secret injection
environment_create --envs "CHEZMOI_ENCRYPT_KEY=env://CHEZMOI_ENCRYPT_KEY"
```

**Container Setup Workflow:**

1. **Key Deployment**: Mirror GitHub Actions CI workflow
   ```bash
   mkdir -p ~/.config/chezmoi
   echo "$CHEZMOI_ENCRYPT_KEY" > ~/.config/chezmoi/key.txt
   chmod 600 ~/.config/chezmoi/key.txt
   ```

2. **Chezmoi Installation**: Use official installation script
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply cffnpwr
   ```

#### Known Linux Environment Issues

**Dependency Conflicts:**

- **mise Command Not Found**: Linux containers lack mise installation
  - Solution: Add Linux-specific mise installation to setup scripts
  - Workaround: Install mise manually before running chezmoi apply

- **macOS-Specific Packages**: Brewfile contains macOS-only packages
  - Solution: Use template conditions to separate macOS/Linux packages
  - Workaround: Skip Brewfile execution on Linux environments

**Encryption/Decryption Status:**

- **Partial Decryption**: Some encrypted files may not decrypt properly
  - Verification: Check SSH config decryption status
  - Solution: Verify age key configuration and file permissions

#### Testing Checklist

Before completing container testing:

- [ ] Secret injection working (CHEZMOI_ENCRYPT_KEY available)
- [ ] Chezmoi repository cloned and initialized
- [ ] Age key properly configured with correct permissions
- [ ] mise installation completed (Linux-specific)
- [ ] SSH configuration decrypted and applied
- [ ] Basic shell configuration (zsh, starship) functional
- [ ] Git configuration applied correctly

#### Validation Commands

```bash
# Check encryption key availability
ls -la ~/.config/chezmoi/key.txt

# Verify chezmoi configuration
chezmoi doctor

# Check encrypted file status
chezmoi cat ~/.ssh/config

# Validate applied configuration
chezmoi diff --no-tty
```

#### Container Environment Advantages

- **Safe Testing**: Isolated environment prevents system configuration damage
- **Reproducible**: Consistent testing environment across different machines
- **CI/CD Simulation**: Mimics GitHub Actions deployment workflow
- **Secret Management**: Secure handling of encryption keys via environment variables
