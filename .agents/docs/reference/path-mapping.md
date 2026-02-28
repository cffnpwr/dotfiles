# Path Mapping Reference

## Overview

All configurations are managed via Nix modules. **NEVER edit files in home directory directly.**

Use this reference to map home directory paths to corresponding Nix modules.

## Program Configurations

### Shell

| Home Directory Path | Nix Module Path |
|---|---|
| `~/.zshrc` | `modules/home-manager/programs/zsh/` |
| `~/.config/starship.toml` | `modules/home-manager/programs/starship/` |
| `~/.config/sheldon/plugins.toml` | `modules/home-manager/programs/sheldon/` |

### Terminal & Multiplexer

| Home Directory Path | Nix Module Path |
|---|---|
| `~/.config/ghostty/` | `modules/home-manager/programs/ghostty/` |
| `~/.config/zellij/config.kdl` | `modules/home-manager/programs/zellij/` |

### Development Tools

| Home Directory Path | Nix Module Path |
|---|---|
| `~/.config/git/config` | `modules/home-manager/programs/git/` |
| `~/.ssh/config` | `modules/home-manager/programs/ssh/` |
| `~/.config/mise/config.toml` | `modules/home-manager/programs/mise/` |

### Window Manager & Launcher

| Home Directory Path | Nix Module Path |
|---|---|
| `~/.config/aerospace/` | `modules/home-manager/programs/aerospace/` |

### Browser

| Home Directory Path | Nix Module Path |
|---|---|
| Zen Browser settings | `modules/home-manager/programs/zen-browser/` |

## System Configuration

| Configuration Type | Nix Module Path |
|---|---|
| System packages | `modules/common/packages.nix`<br>`modules/darwin/packages.nix` |
| System settings | `modules/darwin/system.nix` |
| Environment variables | `modules/common/environment.nix` |
| User account | `modules/common/user.nix` |
| User shell | `modules/darwin/user.nix` |

## Services

| Service Type | Nix Module Path |
|---|---|
| User services (LaunchAgents) | `modules/home-manager/services/` |
| System services | `modules/darwin/services.nix` |

### Specific Services

| Service | Nix Module Path |
|---|---|
| Alt-Tab | `modules/home-manager/services/alt-tab.nix` |
| Amphetamine | `modules/home-manager/services/amphetamine.nix` |
| Bitwarden | `modules/home-manager/services/bitwarden.nix` |
| Raycast | `modules/home-manager/services/raycast.nix` |
| RunCat | `modules/home-manager/services/runcat.nix` |
| Scroll Reverser | `modules/home-manager/services/scroll-reverser.nix` |
| Stats | `modules/home-manager/services/stats.nix` |

## Secrets

| Secret Type | Path |
|---|---|
| Secret definitions | `secrets/secrets.nix` |
| Encrypted secrets | `secrets/*.age` |
| Age encryption key | `~/.config/age/key.txt` |

**Note**: Secrets are encrypted with agenix. Edit with `agenix -e secrets/<name>.age`.

## Quick Lookup

### Common User Requests → Nix Module

| User Request | Nix Module Path |
|---|---|
| "edit ~/.zshrc" | `modules/home-manager/programs/zsh/` |
| "modify starship config" | `modules/home-manager/programs/starship/` |
| "change SSH settings" | `modules/home-manager/programs/ssh/` |
| "update Git config" | `modules/home-manager/programs/git/` |
| "configure Ghostty" | `modules/home-manager/programs/ghostty/` |
| "add Nix package" | `modules/common/packages.nix` or<br>`modules/darwin/packages.nix` |
| "configure Aerospace" | `modules/home-manager/programs/aerospace/` |
| "add Zsh plugin" | `modules/home-manager/programs/zsh/` or<br>`modules/home-manager/programs/sheldon/` |
| "change system settings" | `modules/darwin/system.nix` |
| "add LaunchAgent" | `modules/home-manager/services/` |
| "set environment variable" | `modules/common/environment.nix` |

## Module Organization

### Home Manager Programs

All program modules are in:
```
modules/home-manager/programs/<program-name>/default.nix
```

Programs are imported in:
```
modules/home-manager/programs/default.nix
```

### Home Manager Services

All service modules are in:
```
modules/home-manager/services/<service-name>.nix
```

Services are imported in:
```
modules/home-manager/services/darwin.nix  (macOS services)
```

### Module Discovery

To find which module to edit:

1. **Check this path mapping table**
2. **List modules**:
   ```bash
   ls modules/home-manager/programs/
   ls modules/home-manager/services/
   ```
3. **Search for config option**:
   ```bash
   rg "program-name" modules/
   ```
