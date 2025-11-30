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

This repository is a personal dotfiles and system configuration project
using **Nix** with **nix-darwin** and **Home Manager**. It provides a
comprehensive, declarative configuration setup for macOS development
environment, integrating system settings, shell configurations, development
tools, and application settings.

The project combines Nix's declarative package management with chezmoi for
additional dotfile management, creating a hybrid approach for maximum
flexibility and reproducibility.

## Architecture

### Core Components

- **Nix**: Declarative package management and system configuration
- **nix-darwin**: macOS system configuration
- **Home Manager**: User environment configuration
- **agenix**: Age-based secret encryption for Nix
- **chezmoi**: Supplementary dotfiles management system
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
│   ├── flake.nix                         # Nix flake configuration (main entry point)
│   ├── flake.lock                        # Nix flake lock file
│   ├── .chezmoiroot                      # Specifies homedir as source root
│   ├── .editorconfig                     # Editor settings (2-space indent, LF)
│   ├── CLAUDE.md                         # Project-specific Claude instructions
│   ├── LICENSE                           # License file
│   └── README.md                         # Project documentation
│
├── 🏗️ Nix Configuration (modules/)
│   ├── common/                           # Common configuration (Darwin/Linux)
│   │   ├── default.nix                   # Module imports
│   │   ├── environment.nix               # Environment variables
│   │   ├── fonts.nix                     # Font configuration
│   │   ├── packages.nix                  # Common packages
│   │   └── user.nix                      # User account configuration
│   │
│   ├── darwin/                           # macOS-specific configuration
│   │   ├── default.nix                   # Module imports
│   │   ├── packages.nix                  # macOS packages
│   │   ├── services.nix                  # LaunchDaemons/LaunchAgents
│   │   ├── system.nix                    # System preferences
│   │   └── user.nix                      # User shell configuration
│   │
│   └── home-manager/                     # Home Manager configuration
│       ├── default.nix                   # Home Manager entry point
│       ├── packages/                     # Package lists
│       │   ├── default.nix               # Common packages
│       │   ├── darwin.nix                # macOS-specific packages
│       │   └── linux.nix                 # Linux-specific packages
│       │
│       ├── programs/                     # Program configurations
│       │   ├── claude-code/              # Claude Code configuration
│       │   │   ├── default.nix           # Main module
│       │   │   ├── mcp.nix               # MCP server configuration
│       │   │   ├── settings.nix          # Settings generation
│       │   │   ├── commands.nix          # Custom commands
│       │   │   ├── agents.nix            # Custom agents
│       │   │   └── files/                # Instruction files
│       │   ├── git/                      # Git configuration
│       │   ├── ghostty/                  # Ghostty terminal
│       │   ├── google-japanese-ime/      # Google Japanese IME
│       │   ├── karabiner-elements/       # Keyboard customization
│       │   ├── mas/                      # Mac App Store CLI
│       │   ├── mise/                     # Development tool manager
│       │   ├── sheldon/                  # Zsh plugin manager
│       │   ├── ssh/                      # SSH configuration
│       │   ├── starship/                 # Shell prompt
│       │   ├── zellij/                   # Terminal multiplexer
│       │   └── zsh/                      # Zsh configuration
│       │
│       └── services/                     # User services (LaunchAgents)
│           ├── default.nix               # Service module loader
│           ├── darwin.nix                # macOS-specific services
│           ├── aerospace.nix             # Window manager
│           ├── alt-tab.nix               # Alt-Tab replacement
│           ├── amphetamine.nix           # Keep-awake utility
│           ├── bitwarden.nix             # Password manager
│           ├── google-japanese-ime.nix   # IME service
│           ├── runcat.nix                # System monitor
│           ├── scroll-reverser.nix       # Scroll direction
│           └── stats.nix                 # System stats
│
├── 🖥️ Host Configurations (hosts/)
│   └── cpwr-mba2/                        # MacBook Air M2 configuration
│       └── default.nix                   # Host-specific settings
│
├── 📦 Custom Packages (pkgs/)
│   ├── claude-desktop/                   # Claude Desktop app
│   ├── google-japanese-ime/              # Google Japanese IME
│   ├── mactex/                           # MacTeX distribution
│   ├── microsoft-office/                 # Microsoft Office
│   ├── obsidian/                         # Obsidian notes
│   └── spotify/                          # Spotify client
│
├── 🔐 Secrets (secrets/)
│   ├── secrets.nix                       # agenix secret definitions
│   └── github-token.age                  # Encrypted GitHub token
│
└── 📂 Legacy chezmoi Dotfiles (homedir/)
    └── (Traditional chezmoi-managed configurations)
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

### Nix Operations (Primary)

**IMPORTANT**: This project primarily uses Nix for system and package
management. Use these commands for most configuration changes.

```bash
# Build configuration (for testing without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# Build and switch to new configuration (requires sudo)
nix run nix-darwin -- switch --flake .#cpwr-mba2

# Update flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Check flake for errors
nix flake check

# Clean up old generations (free disk space)
nix-collect-garbage -d
sudo nix-collect-garbage -d

# Show flake outputs
nix flake show
```

### agenix Secret Management

```bash
# Edit encrypted secret (uses $EDITOR)
agenix -e secrets/github-token.age

# Rekey all secrets (after age key change)
agenix --rekey
```

### chezmoi Operations (Supplementary)

**NOTE**: Some legacy configurations are still managed via chezmoi. Always
use `--no-tty` option when running chezmoi commands.

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
```

### Development Tools

```bash
# Update mise-managed development tools (Node.js, Go, Python)
mise upgrade

# Install/sync mise tools
mise install

# Check current versions
mise current

# List available versions
mise ls-remote nodejs
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

### Configuration Management Strategy

This project uses a **hybrid approach** combining Nix and chezmoi:

#### Nix Configuration (Primary - Declarative)

**PREFERRED**: Use Nix for all system and package management:

- **System packages**: Edit `modules/common/packages.nix` or `modules/darwin/packages.nix`
- **Program configurations**: Edit files in `modules/home-manager/programs/`
- **System settings**: Edit `modules/darwin/system.nix`
- **User services**: Edit files in `modules/home-manager/services/`
- **Secrets**: Use agenix in `secrets/` directory

**Deployment Workflow**:

1. Edit Nix configuration files in `modules/` directory
2. Build and test: `nix run nix-darwin -- build --flake .#cpwr-mba2`
3. Apply changes: `nix run nix-darwin -- switch --flake .#cpwr-mba2` (requires sudo)

#### chezmoi Configuration (Legacy - Imperative)

**USE ONLY FOR**: Configurations not yet migrated to Nix

⛔ **TOTAL PROHIBITION**: NEVER edit files in `/Users/cffnpwr/` (home directory)
✅ **EXCLUSIVE LOCATION**: ONLY edit in `/Users/cffnpwr/.local/share/chezmoi/homedir/`

**DEPLOYMENT WORKFLOW**:

1. Edit files in `homedir/` directory
2. Test changes with `chezmoi diff --no-tty`
3. Validate with `chezmoi apply --dry-run --no-tty`
4. Deploy with `chezmoi apply --no-tty`

### Working with Specific Components

#### Nix-Managed Components (Primary)

- **System packages**: Edit `modules/common/packages.nix` or `modules/darwin/packages.nix`
- **Claude Code**: Edit `modules/home-manager/programs/claude-code/`
- **Git config**: Edit `modules/home-manager/programs/git/default.nix`
- **SSH config**: Edit `modules/home-manager/programs/ssh/default.nix`
- **Shell (Zsh)**: Edit `modules/home-manager/programs/zsh/default.nix`
- **Terminal**: Edit `modules/home-manager/programs/ghostty/default.nix`
- **Development tools (mise)**: Edit `modules/home-manager/programs/mise/default.nix`
- **Secrets**: Use `agenix -e secrets/<file>.age`

#### Legacy chezmoi Components (Supplementary)

- **Custom shell plugins**: Edit `homedir/dot_config/zsh/plugins/`
- **Legacy configs**: Files in `homedir/` not yet migrated to Nix

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
