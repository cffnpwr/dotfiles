# Architecture Reference

## Project Overview

Nix-based dotfiles using **nix-darwin** and **Home Manager** for declarative macOS system configuration.

**Key Technologies:**
- **Nix**: Declarative package management
- **nix-darwin**: macOS system configuration framework
- **Home Manager**: User environment configuration
- **agenix**: Age-based secret encryption
- **flake-parts**: Modular flake framework
- **cffnpwr-nixpkgs**: Custom packages repository

## Flake Structure

### Flake Inputs

```nix
{
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  nix-darwin.url = "github:LnL7/nix-darwin";
  home-manager.url = "github:nix-community/home-manager";
  zen-browser.url = "github:0xc000022070/zen-browser-flake";
  agenix.url = "github:ryantm/agenix";
  flake-parts.url = "github:hercules-ci/flake-parts";
  cffnpwr-nixpkgs.url = "github:cffnpwr/nixpkgs";
}
```

### Flake Outputs

- **darwinConfigurations**: macOS system configurations
- **formatter**: Nix code formatter (nixfmt-rfc-style)
- **devShells**: Development environments
- **overlays**: Package overlays (cffnpwr-nixpkgs)

### Multi-System Support

Supported systems:
- `aarch64-darwin` (Apple Silicon)
- `x86_64-darwin` (Intel Mac)
- `x86_64-linux` (Linux)
- `aarch64-linux` (ARM Linux)

## Module System

### Three-Tier Hierarchy

```
1. Common Modules (modules/common/)
   ↓ Cross-platform configuration

2. Darwin Modules (modules/darwin/)
   ↓ macOS-specific configuration

3. Home Manager Modules (modules/home-manager/)
   └ User-level configuration
```

### Module Organization

#### Common Modules (`modules/common/`)

Cross-platform configuration shared across systems.

```
modules/common/
├── default.nix        # Module imports
├── environment.nix    # Environment variables
├── fonts.nix          # Font configuration
├── packages.nix       # Common packages
└── user.nix           # User account configuration
```

**Loaded by**: Both Darwin and Linux configurations

#### Darwin Modules (`modules/darwin/`)

macOS-specific system configuration.

```
modules/darwin/
├── default.nix        # Module imports
├── packages.nix       # macOS-specific packages
├── services.nix       # System services (LaunchDaemons)
├── system.nix         # System preferences (dock, finder, etc.)
└── user.nix           # User shell configuration
```

**Loaded by**: `darwinConfigurations` in flake.nix

#### Home Manager Modules (`modules/home-manager/`)

User-level configuration and programs.

```
modules/home-manager/
├── default.nix          # Home Manager entry point
├── packages/            # Package lists
│   ├── default.nix      # Common packages
│   ├── darwin.nix       # macOS packages
│   └── linux.nix        # Linux packages
├── programs/            # Program configurations
│   ├── aerospace/
│   ├── git/
│   ├── ghostty/
│   ├── mise/
│   ├── sheldon/
│   ├── ssh/
│   ├── starship/
│   ├── zellij/
│   ├── zen-browser/
│   └── zsh/
└── services/            # User services (LaunchAgents)
    ├── default.nix      # Service loader
    ├── darwin.nix       # macOS services
    ├── alt-tab.nix
    ├── amphetamine.nix
    ├── bitwarden.nix
    ├── raycast.nix
    ├── runcat.nix
    ├── scroll-reverser.nix
    └── stats.nix
```

**Loaded by**: Home Manager integrated as Darwin module

## Module Integration

### How Modules Are Loaded

1. **flake.nix** defines `darwinConfigurations.cpwr-mba2`
2. Host configuration at `hosts/cpwr-mba2/default.nix`
3. Host imports Darwin modules:
   ```nix
   imports = [
     ../../modules/common
     ../../modules/darwin
   ];
   ```
4. Darwin modules import Home Manager as module:
   ```nix
   home-manager.darwinModules.home-manager
   ```
5. Home Manager loads user modules from `modules/home-manager/`

### Module Loading Flow

```
flake.nix
  ├─ hosts/cpwr-mba2/default.nix
  │   ├─ modules/common/
  │   └─ modules/darwin/
  │       └─ home-manager (as module)
  │           └─ modules/home-manager/
  └─ overlays
      └─ cffnpwr-nixpkgs.overlays.default
```

## Custom Package Integration

### Overlay System

Custom packages from cffnpwr-nixpkgs are integrated via overlays:

```nix
# In flake.nix
nixpkgs.overlays = [
  cffnpwr-nixpkgs.overlays.default
];
```

This makes custom packages available as:
```nix
pkgs.claude-desktop
pkgs.obsidian
# etc.
```

### Package Resolution Order

1. Custom overlays (cffnpwr-nixpkgs)
2. User-defined overlays
3. Base nixpkgs

## Configuration Deployment

### Build Process

```bash
nix run nix-darwin -- build --flake .#cpwr-mba2
```

1. Evaluates flake.nix
2. Loads all modules
3. Merges configuration
4. Builds derivations
5. Creates system profile

### Deployment Process

```bash
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

1. Builds system profile (same as build)
2. Activates new profile
3. Updates symlinks
4. Reloads services
5. Runs activation scripts

**Requires sudo** for system-level changes.

## Directory Structure

### Repository Layout

```
Repository Root
├── flake.nix              # Flake configuration
├── flake.lock             # Locked input versions
├── modules/               # Nix modules
│   ├── common/            # Cross-platform
│   ├── darwin/            # macOS-specific
│   └── home-manager/      # User-level
├── hosts/                 # Host configurations
│   └── cpwr-mba2/         # Specific host
├── secrets/               # agenix secrets
│   ├── secrets.nix        # Secret definitions
│   └── *.age              # Encrypted secrets
└── .github/               # CI/CD
    └── workflows/
        └── ci.yaml        # GitHub Actions
```

### Generated Paths

After deployment, configuration files are generated at:

```
~/.config/<program>/       # Program configurations
~/Library/LaunchAgents/    # User services
/run/agenix/               # Decrypted secrets
```

**Important**: These are generated files. **NEVER edit directly**.

## Flake Parts Integration

### Per-System Configuration

Using flake-parts for modular organization:

```nix
flake-parts.lib.mkFlake { inputs = self; } {
  systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];

  perSystem = { config, pkgs, ... }: {
    formatter = pkgs.nixfmt-rfc-style;
    devShells.default = pkgs.mkShell {
      packages = [ pkgs.nil pkgs.nixd ];
    };
  };
}
```

**Benefits**:
- Cleaner flake structure
- Automatic per-system handling
- Better modularity

## Development Environment

### Development Shell

```bash
nix develop
```

Provides:
- `nil` (Nix language server)
- `nixd` (Nix daemon)
- `nixfmt-rfc-style` (formatter)

### CI/CD Pipeline

GitHub Actions workflow (`.github/workflows/ci.yaml`):

1. **flake-check**: Validates flake across all systems
2. **format-check**: Ensures proper formatting
3. **install-check**: Tests full installation on macOS

## Best Practices

### Module Organization

**Do**:
- Keep modules focused and single-purpose
- Use meaningful module names
- Group related configuration
- Document complex configurations

**Don't**:
- Create monolithic modules
- Duplicate configuration across modules
- Mix cross-platform and platform-specific code in same module

### Configuration Management

**Do**:
- Use Nix modules for all configuration
- Test builds before deployment
- Commit encrypted secrets only
- Version control all changes

**Don't**:
- Edit generated files in home directory
- Skip build testing
- Commit plaintext secrets
- Make untracked configuration changes
