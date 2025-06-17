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
- `dot_*`: Files/directories that become `.` prefixed in home directory
- `private_*`: Files encrypted with age
- `*.tmpl`: Template files with variable expansion

### Key Configuration Files
- `.chezmoi.toml.tmpl`: chezmoi configuration template (encryption keys, etc.)
- `.chezmoiignore`: Files to exclude from management
- `dot_Brewfile`: Homebrew dependencies management
- `dot_config/mise/config.toml`: Development tools version management

## Common Commands

### chezmoi Operations
```bash
# Preview changes
chezmoi diff

# Apply changes
chezmoi apply

# Dry run to check changes
chezmoi apply --dry-run

# Add new file to management
chezmoi add ~/.config/example

# Sync with remote
chezmoi update
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
# Update Homebrew packages
brew bundle --file ~/.Brewfile

# Update mise-managed tools
mise upgrade

# Update Zsh plugins (via Sheldon)
sheldon update
```

## Development Environment

### Primary Tools
- **Shell**: Zsh + Starship (prompt) + Sheldon (plugin manager)
- **Terminal**: Wezterm
- **Multiplexer**: Zellij
- **Version Manager**: mise (Node.js, Go, Python, etc.)
- **Package Manager**: pnpm (Node.js)

### Editor Configuration
Follow `.editorconfig` in project root:
- Indentation: 2 spaces
- Line endings: LF
- Character encoding: UTF-8
- Trim trailing whitespace, insert final newline

## Development Guidelines

### File Editing
- Edit chezmoi-managed files in this repository, not directly in home directory
- Use `private_` prefix for files requiring encryption (SSH configs, etc.)
- Use `.tmpl` extension for files needing template expansion

### Commit Convention
Use Conventional Commits + Gitmoji format:
```
<type> <emoji>: <Japanese message in noun form>
```

Examples:
- `feat ✨: Wezterm設定の追加`
- `fix 🐛: Zsh補完設定の修正`
- `perf ⚡: Sheldonプラグイン起動の最適化`