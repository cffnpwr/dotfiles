# Project Overview: Nix-based System Configuration

## Project Purpose

This is a personal dotfiles and system configuration project using **Nix** with **nix-darwin** and **Home Manager**. It provides a comprehensive, **fully declarative** configuration setup for macOS development environment, integrating system settings, shell configurations, development tools, and application settings.

## Architecture Strategy

The project uses **pure Nix** for all configuration management:

- **Nix (Primary and Only)**: Complete declarative system configuration, package management, and program settings
- **No Legacy Systems**: Previously used chezmoi has been completely removed

## Tech Stack

### Core Infrastructure

- **Nix**: Declarative package management and system configuration
- **nix-darwin**: macOS system configuration framework
- **Home Manager**: User environment configuration
- **agenix**: Age-based secret encryption for Nix
- **flake-parts**: Modular flake framework
- **cffnpwr-nixpkgs**: Custom packages repository (https://github.com/cffnpwr/nixpkgs)
- **Git**: Version control

### Development Environment

- **Shell**: Zsh with Starship prompt and Sheldon plugin manager
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

### Key Applications

- **Editor**: Visual Studio Code Insiders
- **Browser**: Zen Browser (via flake input)
- **Password Manager**: Bitwarden
- **Notes**: Obsidian
- **Productivity**: Microsoft Office, MacTeX
- **Input**: Karabiner-Elements, Google Japanese IME
- **Monitoring**: Stats, RunCat
- **Utilities**: Alt-Tab, Amphetamine, Scroll Reverser

## Project Structure

### Root Directory
```
/Users/cffnpwr/.local/share/chezmoi/
├── 📄 Core Repository Files
│   ├── flake.nix                         # Nix flake configuration (main entry point, uses flake-parts)
│   ├── flake.lock                        # Nix flake lock file
│   ├── install.sh                        # Automated installation script
│   ├── key.txt.age                       # Encrypted age key
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
```

**NOTE**: Custom packages (Claude Desktop, Google Japanese IME, MacTeX, Microsoft Office, Obsidian, Spotify) are managed in the separate cffnpwr-nixpkgs repository and integrated via flake overlays.

## Flake Architecture

### Flake Inputs
- **nixpkgs**: NixOS/nixpkgs unstable channel
- **nix-darwin**: macOS system configuration framework
- **home-manager**: User environment management
- **zen-browser**: Zen Browser flake
- **agenix**: Secret encryption with age
- **flake-parts**: Modular flake framework
- **cffnpwr-nixpkgs**: Custom packages and modules

### Module Integration
- Darwin modules loaded via `darwinConfigurations`
- Home Manager loaded as Darwin module
- Custom modules from cffnpwr-nixpkgs loaded via `builtins.attrValues`
- Overlays from cffnpwr-nixpkgs integrated via `nixpkgs.overlays`

## Configuration Philosophy

1. **Declarative First**: All configuration through Nix
2. **Reproducibility**: Entire system can be rebuilt from flake.nix
3. **Modularity**: Configuration split into logical, reusable modules
4. **Security**: Secrets managed with agenix encryption
5. **Version Control**: All configuration tracked in Git
6. **No Manual Configuration**: No direct editing of home directory files
