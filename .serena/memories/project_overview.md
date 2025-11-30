# Project Overview: Nix-based System Configuration with chezmoi

## Project Purpose

This is a personal system configuration and dotfiles management project using
**Nix** with **nix-darwin** and **Home Manager** for declarative system
configuration, combined with **chezmoi** for legacy dotfile management. The
project provides a comprehensive, reproducible setup for macOS development
environments.

## Architecture Strategy

The project uses a **hybrid approach**:

- **Nix (Primary)**: Declarative system configuration, package management, and
  program settings
- **chezmoi (Legacy)**: Supplementary dotfile management for configurations not
  yet migrated to Nix

## Tech Stack

### Core Infrastructure

- **Nix**: Declarative package management and system configuration
- **nix-darwin**: macOS system configuration framework
- **Home Manager**: User environment configuration
- **agenix**: Age-based secret encryption for Nix
- **chezmoi**: Legacy dotfiles management system
- **Git**: Version control

### Development Environment

- **Shell**: Zsh with Starship prompt and Sheldon plugin manager
- **Terminal**: Ghostty (migrated from Wezterm)
- **Multiplexer**: Zellij
- **Version Manager**: mise (Node.js 22, Go 1.24, Python via uv)
- **Package Management**:
  - Nix (primary - system and user packages)
  - Homebrew (macOS-specific GUI applications)
  - mise (development tools)
  - pnpm (Node.js packages)

### Key Applications

- **Editor**: Visual Studio Code Insiders
- **Browser**: Zen Browser (via flake input)
- **Password Manager**: Bitwarden
- **Notes**: Obsidian
- **Productivity**: Microsoft Office, MacTeX

## Project Structure

### Nix Configuration (`modules/`)

- **`modules/common/`**: Cross-platform configuration
  - Common packages, fonts, environment variables, user accounts
- **`modules/darwin/`**: macOS-specific configuration
  - System settings, macOS packages, system services
- **`modules/home-manager/`**: User environment configuration
  - Package lists (`packages/`)
  - Program configurations (`programs/`)
  - User services (`services/`)

### Host Configuration (`hosts/`)

- **`hosts/cpwr-mba2/`**: MacBook Air M2 specific settings

### Custom Packages (`pkgs/`)

- Custom Nix derivations for applications not in nixpkgs
- Examples: Claude Desktop, Google Japanese IME, Microsoft Office

### Secrets (`secrets/`)

- agenix-encrypted secrets
- GitHub tokens, API keys

### Legacy Dotfiles (`homedir/`)

- Traditional chezmoi-managed configurations
- Gradually being migrated to Nix

## Key Technologies

- **Development Tools**: Visual Studio Code, GitHub CLI, Docker, Colima
- **CLI Utilities**: eza, fzf, jq, btop, lazygit, neovim
- **Security Tools**: GPG, SSH, age encryption, Bitwarden CLI
- **Claude Code Integration**: Comprehensive setup with MCP servers
- **Input Management**: Karabiner-Elements, Google Japanese IME
- **Window Management**: AeroSpace
- **System Monitoring**: Stats, RunCat

## Configuration Philosophy

1. **Declarative First**: Prefer Nix for all configuration when possible
2. **Reproducibility**: Entire system can be rebuilt from flake.nix
3. **Modularity**: Configuration split into logical, reusable modules
4. **Security**: Secrets managed with agenix encryption
5. **Version Control**: All configuration tracked in Git
