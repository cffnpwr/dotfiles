# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is a personal dotfiles project managed with **chezmoi**. It provides a comprehensive configuration setup for macOS development environment, integrating shell configurations, development tools, and application settings.

## Architecture

### Core Components

- **chezmoi**: Dotfiles management system
- **age**: Private file encryption
- **Git**: Version control

### File Naming Conventions

- `dot_*`: Files/directories that become `.` prefixed in home directory (e.g., `dot_Brewfile` → `~/.Brewfile`)
- `private_*`: Files encrypted with age (SSH keys, credentials)
- `*.tmpl`: Template files with variable expansion (none currently present)

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
    ├── 🚀 Automation Scripts (.chezmoiscripts/ - 5 scripts)
    │   ├── run_once_before_00_decrypt_private_key.sh.tmpl
    │   ├── run_once_00_install_homebrew.sh.tmpl
    │   ├── run_once_00_setup_macos_settings.sh.tmpl
    │   ├── run_onchange_01_brew_bundle.sh.tmpl
    │   └── run_onchange_02_mise_install.sh.tmpl
    │
    ├── 🛡️ Private SSH Configuration (private_dot_ssh/ - 7 files)
    │   ├── conf.d/                       # Modular SSH configuration
    │   │   ├── 00-common                 # Common SSH settings
    │   │   ├── 01-home                   # Home environment settings
    │   │   ├── 02-tmcit                  # School environment settings
    │   │   └── 03-git                    # Git-related settings
    │   ├── private_config                # Main SSH config (encrypted)
    │   └── rc                            # SSH RC configuration
    │
    └── ⚙️ Application Configurations (dot_config/ - 16 files)
        │
        ├── 🤖 claude/ (3 files)          # Claude Code configuration
        │   ├── CLAUDE.md                 # Claude instructions
        │   ├── settings.json             # Claude settings JSON
        │   └── commands/
        │       └── reflection.md         # Reflection configuration
        │
        ├── 🐙 gh/ (2 files - encrypted)  # GitHub CLI configuration
        │   ├── private_config.yml        # GitHub CLI config (encrypted)
        │   └── private_hosts.yml         # GitHub hosts config (encrypted)
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
- `private_*`: Files encrypted with age (SSH keys, credentials)
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
- `dot_config/mise/config.toml`: Development tools version management (Node.js, Go, Python)
- `dot_config/sheldon/plugins.toml`: Zsh plugin management with deferred loading
- `dot_config/starship.toml`: Custom prompt configuration with themes
- `dot_config/wezterm/`: Terminal configuration with Zellij integration
- `dot_config/zsh/`: Zsh configuration with plugins and aliases

## Common Commands

### chezmoi Operations

```bash
# Preview changes before applying
chezmoi diff

# Apply changes to home directory
chezmoi apply

# Dry run to check what would be changed
chezmoi apply --dry-run

# Add new file to management
chezmoi add ~/.config/example

# Sync with remote repository
chezmoi update

# Re-run scripts (useful for brew bundle updates)
chezmoi state delete-bucket --bucket=entryState
chezmoi apply
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

- **Shell**: Zsh + Starship (prompt) + Sheldon (plugin manager with deferred loading)
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
- **Integration**: Mise, Starship, and Homebrew are initialized through Sheldon

### Editor Configuration

Follow `.editorconfig` in project root:

- Indentation: 2 spaces
- Line endings: LF
- Character encoding: UTF-8
- Trim trailing whitespace, insert final newline

## Development Guidelines

### File Editing

- **IMPORTANT**: Edit files in this repository (`/Users/cffnpwr/.local/share/chezmoi/homedir/`), not in home directory
- **WORKFLOW**: Always edit files in `./homedir/` directory, then apply changes with `chezmoi apply`
- Use `private_` prefix for files requiring encryption (SSH configs, credentials)
- Test changes with `chezmoi diff` before applying
- After editing, run `chezmoi apply` to deploy changes to home directory

### Working with Specific Components

- **Brewfile**: Add packages to `homedir/dot_Brewfile`, then run `brew bundle --file ~/.Brewfile`
- **Zsh plugins**: Update `dot_config/sheldon/plugins.toml`, plugins auto-load via cache system
- **SSH configs**: Edit encrypted files under `private_dot_ssh/` using `chezmoi edit`
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

## important-instruction-reminders

Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
