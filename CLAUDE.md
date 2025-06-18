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
- `/homedir/`: Root directory containing all dotfiles to be deployed
  - Configuration files are nested under appropriate paths (e.g., `dot_config/zsh/`)
  - Private files under `private_dot_ssh/` for SSH configurations

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
```
<type> <emoji>: <Japanese message in noun form>
```

Examples:
- `feat ✨: Wezterm設定の追加`
- `fix 🐛: Zsh補完設定の修正`
- `perf ⚡: Sheldonプラグイン起動の最適化`