# Essential Commands for Development

## Nix Operations (Primary and Only)

### Build and Deploy

```bash
# Build configuration (for testing without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# Build and switch to new configuration (requires sudo)
nix run nix-darwin -- switch --flake .#cpwr-mba2

# Update flake inputs (nixpkgs, home-manager, cffnpwr-nixpkgs, etc.)
nix flake update

# Update specific flake input
nix flake lock --update-input nixpkgs
nix flake lock --update-input cffnpwr-nixpkgs

# Check flake for errors (runs on all systems)
nix flake check

# Format Nix files with nixfmt-rfc-style
nix fmt

# Check formatting without modifying files
nix fmt -- --check .

# Show flake outputs and structure
nix flake show
```

### Cleanup and Maintenance

```bash
# Clean up old generations (free disk space)
nix-collect-garbage -d
sudo nix-collect-garbage -d

# Optimize Nix store
nix-store --optimise

# Repair Nix store
nix-store --verify --check-contents --repair
```

### Development and Debugging

```bash
# Enter development shell (includes nil, nixd, nixfmt-rfc-style)
nix develop

# Build specific output
nix build .#darwinConfigurations.cpwr-mba2.config.system.build.toplevel

# Evaluate Nix expression
nix eval .#darwinConfigurations.cpwr-mba2.config.system.path

# Show package info
nix search nixpkgs <package-name>
```

## agenix Secret Management

```bash
# Edit encrypted secret (uses $EDITOR)
agenix -e secrets/github-token.age

# Rekey all secrets (after age key change)
agenix --rekey

# List all secrets
ls -la secrets/*.age

# Add new secret
# 1. Define in secrets/secrets.nix
# 2. Create encrypted file: agenix -e secrets/<name>.age
# 3. Reference in Nix modules
```

## Development Tools

### mise (Development Environment Manager)

```bash
# Update mise-managed development tools (Node.js, Go, Python)
mise upgrade

# Install/sync mise tools
mise install

# Check current versions
mise current

# List available versions
mise ls-remote nodejs

# Use specific version
mise use nodejs@22
```

### Package Management

```bash
# Update all systems
nix flake update && nix run nix-darwin -- switch --flake .#cpwr-mba2

# Update development tools
mise upgrade

# Update Node.js packages globally
pnpm update -g
```

## Linting and Formatting

```bash
# Lint Markdown files
markdownlint **/*.md

# Lint Japanese text
textlint **/*.md

# Fix textlint issues automatically
textlint --fix **/*.md

# Format Nix files
nix fmt
```

## System Utilities (macOS/Darwin)

```bash
# File operations
eza -la           # Enhanced ls with icons
tree              # Directory structure
fd                # Enhanced find

# Process monitoring
btop              # Enhanced top
pstree            # Process tree

# Network utilities
mtr               # Enhanced traceroute
arp-scan          # Network scanning
```

## Git Operations

```bash
# Use Git slash commands in Claude Code
/git:status       # Check repository status
/git:commit       # Conventional commits with GPG signing
/git:diff         # View changes
```

## Health Checks

```bash
# Check Nix system health
nix flake check

# Check mise health
mise doctor

# Verify system configuration
nix-store --verify

# Check Nix installation
nix doctor
```

## Common Workflow

```bash
# Complete update workflow
nix flake update              # Update inputs
nix fmt                       # Format code
nix flake check              # Validate flake
nix run nix-darwin -- build --flake .#cpwr-mba2   # Test build
nix run nix-darwin -- switch --flake .#cpwr-mba2  # Apply changes
```
