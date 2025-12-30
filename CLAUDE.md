# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Essential Initial Setup

**MANDATORY PROJECT INITIALIZATION:**

🚨 **BEFORE ANY WORK**: Execute initial instructions to activate project context:

```bash
# For dotfiles project (Serena MCP)
mcp__serena__activate_project("dotfiles")
mcp__serena__check_onboarding_performed()
```

**Project Context Requirements:**
- MUST activate serena project before any code analysis or file operations
- MUST verify onboarding status to access project-specific memories
- MUST read relevant memories based on task requirements

**Understanding Configuration Management:**
- **ALL configurations**: Nix modules in `modules/` directory
- **NEVER**: Direct editing of files in home directory (`/Users/cffnpwr/`)

## ⚠️ ABSOLUTE CONSTRAINTS - VIOLATION = IMMEDIATE TASK FAILURE

**CRITICAL NIX CONFIGURATION PROTOCOL:**

🚨 **MANDATORY PRE-EXECUTION CHECK**: Before ANY file operation, you MUST verify the target path:

1. **DETECTION PHASE**: Check if any file path starts with `/Users/cffnpwr/` (home directory)
2. **BLOCKING PHASE**: If home directory path detected → IMMEDIATELY STOP → NEVER PROCEED
3. **CORRECTION PHASE**: Map home directory path to Nix module equivalent
4. **EXECUTION PHASE**: Edit ONLY in `/Users/cffnpwr/.local/share/chezmoi/modules/`
5. **FORMAT PHASE**: Run `nix fmt` to format code
6. **BUILD PHASE**: Test with `nix run nix-darwin -- build --flake .#cpwr-mba2`
7. **DEPLOYMENT PHASE**: Apply with `nix run nix-darwin -- switch --flake .#cpwr-mba2`

**VIOLATION CONSEQUENCES:**
- ANY direct home directory edit = IMMEDIATE TASK FAILURE
- NO EXCEPTIONS for "quick fixes", "temporary changes", or "urgent updates"
- MUST restart entire workflow with proper Nix module management

**MANDATORY PATH MAPPING TABLE:**

All configurations are managed via Nix modules (DO NOT edit in home directory):

```text
HOME DIRECTORY PATH                          → NIX MODULE PATH
~/.zshrc                                    → modules/home-manager/programs/zsh/
~/.config/starship.toml                     → modules/home-manager/programs/starship/
~/.ssh/config                               → modules/home-manager/programs/ssh/
~/.config/ghostty/                          → modules/home-manager/programs/ghostty/
~/.config/zellij/config.kdl                 → modules/home-manager/programs/zellij/
~/.config/mise/config.toml                  → modules/home-manager/programs/mise/
~/.config/sheldon/plugins.toml              → modules/home-manager/programs/sheldon/
~/.config/git/config                        → modules/home-manager/programs/git/
~/.config/aerospace/                        → modules/home-manager/programs/aerospace/

System packages                             → modules/common/packages.nix or modules/darwin/packages.nix
System settings                             → modules/darwin/system.nix
Environment variables                       → modules/common/environment.nix
User services (LaunchAgents)                → modules/home-manager/services/
```

**ENFORCEMENT VERIFICATION CHECKLIST:**

Before completing ANY configuration task, verify:
- [ ] NO files edited in `/Users/cffnpwr/` (home directory)
- [ ] ALL edits made in `/Users/cffnpwr/.local/share/chezmoi/modules/`
- [ ] Code formatted with `nix fmt`
- [ ] Build tested with `nix run nix-darwin -- build --flake .#cpwr-mba2`
- [ ] Changes applied with `nix run nix-darwin -- switch --flake .#cpwr-mba2`
- [ ] Target application restarted/reloaded if necessary

## Configuration Management Guidelines

**ALL CONFIGURATION: Nix Modules**

🎯 **MANDATORY**: Use Nix for ALL configuration management
✅ **APPLIES TO**: System packages, programs, services, secrets, user environment

**STEP-BY-STEP WORKFLOW:**

When user requests ANY configuration change:

1. **IDENTIFY TARGET**: Determine which component needs modification
2. **LOCATE MODULE**: Find corresponding Nix module in `modules/` directory
3. **EDIT MODULE**: Make changes to the appropriate `.nix` file
4. **FORMAT CODE**: Run `nix fmt` to ensure proper formatting
5. **TEST BUILD**: Run `nix run nix-darwin -- build --flake .#cpwr-mba2`
6. **VALIDATE**: Check for errors in build output
7. **DEPLOY**: Run `nix run nix-darwin -- switch --flake .#cpwr-mba2` (requires sudo)
8. **VERIFICATION**: Verify target application functionality

**CRITICAL PATH TRANSLATION EXAMPLES:**
```
USER REQUEST                                 → CORRECT ACTION
"edit ~/.zshrc"                             → Edit modules/home-manager/programs/zsh/
"modify ~/.config/starship.toml"            → Edit modules/home-manager/programs/starship/
"change SSH config"                         → Edit modules/home-manager/programs/ssh/
"update Ghostty settings"                   → Edit modules/home-manager/programs/ghostty/
"add Nix package"                           → Edit modules/common/packages.nix or modules/darwin/packages.nix
"configure Aerospace"                       → Edit modules/home-manager/programs/aerospace/
"add Zsh plugin"                            → Edit modules/home-manager/programs/zsh/ or modules/home-manager/programs/sheldon/
"change system settings"                    → Edit modules/darwin/system.nix
"add LaunchAgent service"                   → Edit modules/home-manager/services/
```

**IMPORTANT**: After editing Nix modules, you MUST rebuild:
```bash
# Format code
nix fmt

# Test build
nix run nix-darwin -- build --flake .#cpwr-mba2

# Apply changes (requires sudo)
nix run nix-darwin -- switch --flake .#cpwr-mba2
```

**SAFETY PROTOCOLS:**
YOU MUST: Create backups before critical system configuration changes
YOU MUST: Apply system-wide changes (zsh, ssh, etc.) incrementally

## Sensitive File Operation Safety Guidelines

**SECRET MANAGEMENT WITH AGENIX:**

All secrets are managed via **agenix** (age-based encryption for Nix):

**Encrypted Secrets**:
- Location: `secrets/` directory
- Definition: `secrets/secrets.nix`
- Encryption: age encryption with keys in `~/.config/age/key.txt`

**Security Requirements**:

YOU MUST: Get user permission before outputting secret content to logs

YOU MUST: Never display the content of confidential information (passwords, tokens, API keys)

YOU MUST: Use `agenix -e secrets/<file>.age` to edit encrypted secrets

YOU MUST: Always verify encryption status after editing

YOU MUST: Never display encrypted content in plain text

YOU MUST: Verify key permissions (600) for `~/.config/age/key.txt`

NEVER: Output confidential information to diff or logs

NEVER: Display encrypted file content in plain text

NEVER: Commit unencrypted secrets to repository

## Project Overview

This repository is a personal dotfiles and system configuration project
using **Nix** with **nix-darwin** and **Home Manager**. It provides a
comprehensive, **fully declarative** configuration setup for macOS development
environment, integrating system settings, shell configurations, development
tools, and application settings.

The project uses **Nix's declarative package management** with
**flake-parts** for modular organization. Custom packages are maintained in
a separate [cffnpwr/nixpkgs](https://github.com/cffnpwr/nixpkgs) repository
and integrated via flake overlays. All configurations are managed through
**Nix modules**, providing complete reproducibility and version control.

## Architecture

### Core Components

- **Nix**: Declarative package management and system configuration
- **nix-darwin**: macOS system configuration framework
- **Home Manager**: User environment configuration
- **agenix**: Age-based secret encryption for Nix
- **flake-parts**: Modular flake framework (migrated from flake-utils)
- **cffnpwr-nixpkgs**: Custom packages repository (https://github.com/cffnpwr/nixpkgs)
- **Git**: Version control

### Directory Structure

```text
/Users/cffnpwr/.local/share/chezmoi/
├── 📄 Core Repository Files
│   ├── flake.nix                         # Nix flake configuration (main entry point, uses flake-parts)
│   ├── flake.lock                        # Nix flake lock file
│   ├── install.sh                        # Automated installation script
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
│       │   ├── aerospace/                # Window manager
│       │   ├── git/                      # Git configuration
│       │   ├── ghostty/                  # Ghostty terminal
│       │   ├── mas/                      # Mac App Store CLI
│       │   ├── mise/                     # Development tool manager
│       │   ├── sheldon/                  # Zsh plugin manager
│       │   ├── ssh/                      # SSH configuration
│       │   ├── starship/                 # Shell prompt
│       │   ├── zellij/                   # Terminal multiplexer
│       │   ├── zen-browser/              # Zen Browser
│       │   └── zsh/                      # Zsh configuration
│       │
│       └── services/                     # User services (LaunchAgents)
│           ├── default.nix               # Service module loader
│           ├── darwin.nix                # macOS-specific services
│           ├── alt-tab.nix               # Alt-Tab replacement
│           ├── amphetamine.nix           # Keep-awake utility
│           ├── bitwarden.nix             # Password manager
│           ├── raycast.nix               # Launcher & productivity tool
│           ├── runcat.nix                # System monitor
│           ├── scroll-reverser.nix       # Scroll direction
│           └── stats.nix                 # System stats
│
├── 🖥️ Host Configurations (hosts/)
│   └── cpwr-mba2/                        # MacBook Air M2 configuration
│       └── default.nix                   # Host-specific settings
│
├── 🔐 Secrets (secrets/)
│   ├── secrets.nix                       # agenix secret definitions
│   └── github-token.age                  # Encrypted GitHub token
│
└── 🚀 CI/CD (.github/workflows/)
    └── ci.yaml                           # GitHub Actions workflow (flake check, format check, install check)

NOTE: Custom packages (Claude Desktop, Google Japanese IME, MacTeX, Microsoft Office,
Obsidian, Spotify) are managed in the separate cffnpwr-nixpkgs repository.
```

## Common Commands

### Automated Installation

**NEW USERS**: Use the installation script for initial setup:

```bash
# Interactive installation (prompts for hostname, branch)
curl -fsSL https://raw.githubusercontent.com/cffnpwr/dotfiles/main/install.sh | sh

# Non-interactive installation with options
curl -fsSL https://raw.githubusercontent.com/cffnpwr/dotfiles/main/install.sh | \
  sh -s -- --path $HOME/.dotfiles --hostname cpwr-mba2 --branch main --yes
```

### Nix Operations (Primary)

**IMPORTANT**: This project primarily uses Nix for system and package
management. Use these commands for most configuration changes.

```bash
# Build configuration (for testing without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# Build and switch to new configuration (requires sudo)
nix run nix-darwin -- switch --flake .#cpwr-mba2

# Update flake inputs (nixpkgs, home-manager, cffnpwr-nixpkgs, etc.)
nix flake update

# Update specific flake input
nix flake lock --update-input nixpkgs

# Check flake for errors (runs on all systems)
nix flake check

# Format Nix files with nixfmt-rfc-style
nix fmt

# Check formatting without modifying files
nix fmt -- --check .

# Clean up old generations (free disk space)
nix-collect-garbage -d
sudo nix-collect-garbage -d

# Show flake outputs and structure
nix flake show

# Enter development shell (includes nil, nixd, nixfmt-rfc-style)
nix develop
```

### agenix Secret Management

```bash
# Edit encrypted secret (uses $EDITOR)
agenix -e secrets/github-token.age

# Rekey all secrets (after age key change)
agenix --rekey

# Add new secret
# 1. Define in secrets/secrets.nix
# 2. Create encrypted file: agenix -e secrets/<name>.age
# 3. Reference in Nix modules
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

- **Shell**: Zsh + Starship (prompt) + Sheldon (plugin manager with deferred loading)
- **Terminal**: Ghostty (GPU-accelerated, native macOS terminal)
- **Multiplexer**: Zellij (terminal workspace manager)
- **Window Manager**: Aerospace (tiling window manager for macOS)
- **Launcher**: Raycast (productivity tool and app launcher)
- **Browser**: Zen Browser (privacy-focused browser)
- **Version Manager**: mise (Node.js, Go, Python, pnpm)
- **Package Manager**: Nix (system packages), pnpm (Node.js)
- **File Manager**: eza (with icons and git status)
- **Editor**: Neovim, VS Code (for GUI editing)
- **Nix LSP**: nil, nixd (Nix language servers)
- **Formatter**: nixfmt-rfc-style (Nix code formatting)

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

This project uses **pure Nix** for all configuration management:

**ALL CONFIGURATIONS** are managed via Nix modules:

- **System packages**: Edit `modules/common/packages.nix` or `modules/darwin/packages.nix`
- **Program configurations**: Edit files in `modules/home-manager/programs/`
- **System settings**: Edit `modules/darwin/system.nix`
- **User services**: Edit files in `modules/home-manager/services/`
- **Secrets**: Use agenix in `secrets/` directory

**Deployment Workflow**:

1. Edit Nix configuration files in `modules/` directory
2. Format code: `nix fmt`
3. Build and test: `nix run nix-darwin -- build --flake .#cpwr-mba2`
4. Apply changes: `nix run nix-darwin -- switch --flake .#cpwr-mba2` (requires sudo)

### Working with Specific Components

**System Configuration**:
- **System packages**: Edit `modules/common/packages.nix` or `modules/darwin/packages.nix`
- **System settings**: Edit `modules/darwin/system.nix`
- **Environment variables**: Edit `modules/common/environment.nix`
- **User account**: Edit `modules/common/user.nix`

**Program Configurations**:
- **Git**: Edit `modules/home-manager/programs/git/default.nix`
- **SSH**: Edit `modules/home-manager/programs/ssh/default.nix`
- **Shell (Zsh)**: Edit `modules/home-manager/programs/zsh/default.nix`
- **Terminal (Ghostty)**: Edit `modules/home-manager/programs/ghostty/default.nix`
- **Multiplexer (Zellij)**: Edit `modules/home-manager/programs/zellij/default.nix`
- **Window Manager (Aerospace)**: Edit `modules/home-manager/programs/aerospace/default.nix`
- **Browser (Zen)**: Edit `modules/home-manager/programs/zen-browser/default.nix`
- **Prompt (Starship)**: Edit `modules/home-manager/programs/starship/default.nix`
- **Plugin Manager (Sheldon)**: Edit `modules/home-manager/programs/sheldon/default.nix`
- **Development tools (mise)**: Edit `modules/home-manager/programs/mise/default.nix`
- **Mac App Store (mas)**: Edit `modules/home-manager/programs/mas/default.nix`

**Service Configurations** (LaunchAgents):
- Edit files in `modules/home-manager/services/` for user services
- Edit `modules/darwin/services.nix` for system services

**Secrets Management**:
- **Edit secrets**: Use `agenix -e secrets/<file>.age`
- **Define secrets**: Edit `secrets/secrets.nix`

**Custom Packages**:
- Custom packages are managed in [cffnpwr/nixpkgs](https://github.com/cffnpwr/nixpkgs)
- The repository is integrated via flake inputs and overlays

### Commit Convention

Use Conventional Commits + Gitmoji format:

```text
<type> <emoji>: <Japanese message in noun form>
```

Examples:

- `feat ✨: Wezterm設定の追加`
- `fix 🐛: Zsh補完設定の修正`
- `perf ⚡: Sheldonプラグイン起動の最適化`

## CI/CD Integration

### GitHub Actions Workflow

The project includes automated CI/CD pipeline (`.github/workflows/ci.yaml`) that runs on every push:

**Workflow Jobs**:

1. **Flake Check** (`flake-check`):
   - Validates Nix flake configuration across all systems
   - Command: `nix flake check --all-systems`
   - Runs on: Ubuntu 24.04

2. **Format Check** (`format-check`):
   - Ensures all Nix files follow nixfmt-rfc-style formatting
   - Command: `nix fmt -- --check .`
   - Runs on: Ubuntu 24.04

3. **Install Check** (`install-check`):
   - Tests full system installation on actual macOS runner
   - Runs install.sh script with automated setup
   - Validates complete deployment including secret management
   - Matrix: macOS 15 (cpwr-mba2 hostname)
   - Includes extensive disk cleanup to ensure sufficient space

**CI Configuration Notes**:
- Paths ignored: `.claude/**`, `.vscode/**`, `.editorconfig`, `CLAUDE.md`, `README.md`, `LICENSE`
- Uses Determinate Systems Nix Action for Nix installation
- Secrets: `AGE_SECRET_KEY` for agenix encryption, `GITHUB_TOKEN` for Nix access tokens
- Concurrency: Cancels in-progress runs for the same ref

**Local Validation Before Push**:
```bash
# Run the same checks locally
nix flake check          # Flake validation
nix fmt -- --check .     # Format check
```

## Flake Architecture & Module System

### Flake Structure

This project uses **flake-parts** for modular flake organization:

**Key Design Decisions**:
- **Multi-system support**: `aarch64-darwin`, `x86_64-darwin`, `x86_64-linux`, `aarch64-linux`
- **Overlay system**: Integrates `cffnpwr-nixpkgs` custom packages via overlays
- **Per-system configuration**: Development shell and formatter defined per-system
- **Unified Home Manager**: Home Manager integrated as Darwin module

**Flake Inputs**:
```nix
nixpkgs              # NixOS/nixpkgs unstable channel
nix-darwin           # macOS system configuration framework
home-manager         # User environment management
zen-browser          # Zen Browser flake
agenix               # Secret encryption with age
flake-parts          # Modular flake framework
cffnpwr-nixpkgs      # Custom packages and modules
```

### Module Organization

**Three-tier module hierarchy**:

1. **Common modules** (`modules/common/`): Cross-platform configuration
   - User accounts, environment variables, fonts, base packages

2. **Darwin modules** (`modules/darwin/`): macOS-specific configuration
   - System preferences, macOS packages, system services

3. **Home Manager modules** (`modules/home-manager/`): User-level configuration
   - Programs, packages, user services (LaunchAgents)
   - Further divided into packages/, programs/, services/

**Module Integration**:
- Darwin modules loaded via `darwinConfigurations`
- Home Manager loaded as Darwin module with `home-manager.darwinModules.home-manager`
- Custom modules from `cffnpwr-nixpkgs` loaded via `builtins.attrValues`

### Development Workflow Best Practices

**Adding New Programs**:
1. Create module in `modules/home-manager/programs/<program-name>/default.nix`
2. Import in `modules/home-manager/programs/default.nix`
3. Test with `nix run nix-darwin -- build --flake .#cpwr-mba2`
4. Apply with `nix run nix-darwin -- switch --flake .#cpwr-mba2`

**Adding New Services**:
1. Create service in `modules/home-manager/services/<service-name>/default.nix`
2. Import in `modules/home-manager/services/darwin.nix` (for macOS services)
3. Test and apply same as programs

**Working with Custom Packages**:
- Custom packages live in [cffnpwr/nixpkgs](https://github.com/cffnpwr/nixpkgs)
- Update with `nix flake lock --update-input cffnpwr-nixpkgs`
- Available via overlay: `pkgs.custom-package-name`

**Formatting & Validation**:
```bash
# Format all Nix files
nix fmt

# Validate flake
nix flake check

# Build without switching
nix run nix-darwin -- build --flake .#cpwr-mba2
```

## Troubleshooting

### Common Issues

**Build Failures**:
- Check flake.lock is up-to-date: `nix flake update`
- Verify formatting: `nix fmt -- --check .`
- Run flake check: `nix flake check`

**Installation Issues**:
- Ensure sudo privileges available
- Check disk space (macOS runners require significant cleanup)
- Verify age secret key is properly configured

**Secret Management**:
- Age key location: `~/.config/age/key.txt` (permissions: 600)
- Edit secrets: `agenix -e secrets/<file>.age`
- Rekey after key change: `agenix --rekey`

**Module Conflicts**:
- Check for duplicate module imports
- Verify module paths in `default.nix` files
- Use `nix flake show` to inspect outputs
