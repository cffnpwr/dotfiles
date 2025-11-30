# Essential Commands for Development

## Nix Operations (Primary)

### Build and Deploy

```bash
# Build configuration (for testing without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# Build and switch to new configuration (requires sudo)
nix run nix-darwin -- switch --flake .#cpwr-mba2

# Update flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Check flake for errors
nix flake check

# Show flake outputs
nix flake show

# Format Nix files
nix fmt
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
# Enter development shell
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
```

## chezmoi Operations (Legacy - Always use --no-tty)

```bash
# Preview changes before applying
chezmoi diff --no-tty

# Apply changes to home directory
chezmoi apply --no-tty

# Dry run to check what would be changed
chezmoi apply --dry-run --no-tty

# Add new file to management
chezmoi add --no-tty ~/.config/example

# Sync with remote repository
chezmoi update --no-tty
```

## Development Tools

### mise (Development Environment Manager)

```bash
# Update mise-managed tools (Node.js, Go, Python)
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

# Check chezmoi health
chezmoi doctor

# Check mise health
mise doctor

# Verify system configuration
nix-store --verify
```
