# Project Overview: chezmoi Dotfiles Management

## Project Purpose
This is a personal dotfiles management project using chezmoi for version control and deployment of configuration files. The project manages development environment configurations, shell settings, and application configurations across macOS systems.

## Tech Stack
- **Configuration Management**: chezmoi
- **Encryption**: age (for sensitive files)
- **Version Control**: Git
- **Shell**: Zsh with Sheldon plugin manager
- **Terminal**: Wezterm with Zellij multiplexer
- **Prompt**: Starship
- **Package Management**: 
  - Homebrew (system packages)
  - mise (development tools: Node.js 22, Go 1.24, Python via uv)
  - npm/pipx (CLI tools and utilities)

## Key Technologies
- **Development Tools**: Visual Studio Code, GitHub CLI, Docker, Colima
- **CLI Utilities**: eza, fzf, jq, btop, lazygit, neovim
- **Security Tools**: GPG, SSH, age encryption, Bitwarden CLI
- **Claude Code Integration**: Comprehensive setup with MCP servers

## Project Structure
- Root directory contains chezmoi configuration and metadata
- `homedir/` directory contains actual dotfiles (maps to `~/` when applied)
- `.chezmoiroot` specifies homedir as the source root
- Template files (`.tmpl`) support dynamic configuration
- Encrypted files (`.age`) for sensitive data