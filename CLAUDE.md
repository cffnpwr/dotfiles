# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Summary

Nix-based dotfiles using **nix-darwin** and **Home Manager** for declarative macOS configuration.

**Core Principle**: All configurations are managed via Nix modules. Never edit files in home directory directly.

## 🚨 CRITICAL RULES

**BEFORE ANY FILE OPERATION:**

1. ❌ **FORBIDDEN**: Direct editing of files in home directory (e.g., `~/.zshrc`, `~/.config/*`)
2. ✅ **REQUIRED**: Edit ONLY Nix modules in `modules/` directory
3. ✅ **REQUIRED**: Use `sudo` for deployment commands

**Full critical rules**: `.claude/docs/critical/rules.md`

## Quick Start

### Initialize Project Context

```bash
# Activate Serena MCP project context (REQUIRED)
mcp__serena__activate_project("dotfiles")
mcp__serena__check_onboarding_performed()
```

### Essential Commands

```bash
# Format Nix files (manual fallback if Hooks fail)
fd -e nix --exec-batch nix fmt

# Build configuration (test without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# Deploy configuration (REQUIRES sudo)
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

**Full command reference**: `.claude/docs/reference/commands.md`

## Task Navigation

### Configuration Changes
**Task**: Add package, modify settings, change system preferences

→ Read: `.claude/docs/workflows/configuration.md`

**Examples**: `.claude/docs/workflows/examples.md`

### Adding Modules
**Task**: Add new program or service

→ Read: `.claude/docs/workflows/modules.md`

**Subtasks**:
- Add program: `.claude/docs/workflows/modules/adding-programs.md`
- Add service: `.claude/docs/workflows/modules/adding-services.md`
- Custom packages: `.claude/docs/workflows/modules/custom-packages.md`

### Secret Management
**Task**: Edit secrets, manage agenix

→ Read: `.claude/docs/workflows/secrets.md`

### Path Translation
**Task**: Find which Nix module to edit for a config file

→ Read: `.claude/docs/reference/path-mapping.md`

### Architecture Details
**Task**: Understand flake structure, module system

→ Read: `.claude/docs/reference/architecture.md`

### Troubleshooting
**Task**: Debug build errors, fix deployment issues

→ Read: `.claude/docs/troubleshooting.md`

## Project Structure

### Module Organization

```
modules/
├── common/              # Cross-platform configuration
│   ├── packages.nix
│   ├── environment.nix
│   └── user.nix
│
├── darwin/              # macOS-specific configuration
│   ├── packages.nix
│   ├── system.nix
│   └── services.nix
│
└── home-manager/        # User-level configuration
    ├── programs/
    └── services/
```

### Repository Layout

```
.
├── flake.nix            # Flake configuration
├── modules/             # Nix modules
├── hosts/               # Host configurations
├── secrets/             # Encrypted secrets (agenix)
└── .claude/             # Claude Code documentation
```

## Quick Reference

### Common Path Mappings

| Home Directory | Nix Module |
|---|---|
| `~/.zshrc` | `modules/home-manager/programs/zsh/` |
| `~/.config/git/config` | `modules/home-manager/programs/git/` |
| System packages | `modules/common/packages.nix`, `modules/darwin/packages.nix` |

**Full mapping**: `.claude/docs/reference/path-mapping.md`

### Standard Workflow

**IDENTIFY** → **LOCATE** → **EDIT** → **FORMAT** → **BUILD** → **DEPLOY** → **VERIFY**

**Detailed workflow**: `.claude/docs/workflows/configuration.md`

## Development Tools

- **Shell**: Zsh + Starship + Sheldon
- **Terminal**: Ghostty
- **Multiplexer**: Zellij
- **Window Manager**: Aerospace
- **Editor**: Neovim, VS Code
- **Version Manager**: mise
- **Formatter**: nixfmt-rfc-style

## Commit Convention

Use Conventional Commits + Gitmoji format:

```
<type> <emoji>: <Japanese message in noun form>
```

Examples:
- `feat ✨: Neovim設定の追加`
- `fix 🐛: Zsh補完の修正`
- `perf ⚡: ビルド時間の最適化`
