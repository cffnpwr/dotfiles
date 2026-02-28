# Command Reference

## Nix Operations

### Formatting

```bash
# Format all Nix files (recommended)
fd -e nix --exec-batch nix fmt

# Format specific file or directory
nix fmt <path>

# Check formatting without modifying
nix fmt -- --check <path>
```

**Note**: Claude Code Hooks should auto-format. Use these as manual fallback.

### Building

```bash
# Build configuration (test without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# Build specific output
nix build .#darwinConfigurations.cpwr-mba2.system
```

### Deployment

```bash
# Apply configuration (REQUIRES SUDO)
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# Rollback to previous generation
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2 --rollback
```

**CRITICAL**: Must use `sudo` prefix for deployment commands.

### Flake Management

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input cffnpwr-nixpkgs

# Show flake outputs
nix flake show

# Show flake metadata
nix flake metadata

# Validate flake
nix flake check
```

### Garbage Collection

```bash
# Clean up old generations and free disk space
nix store gc

# Delete old generations before cleanup
nix-env --delete-generations old
nix store gc
```

### Development

```bash
# Enter development shell
nix develop

# Run command in dev shell
nix develop -c <command>
```

## agenix Secret Management

```bash
# Edit encrypted secret
agenix -e secrets/<secret-name>.age

# Rekey all secrets (after key change)
agenix --rekey

# List secrets
ls -la secrets/*.age
```

## mise Tool Management

```bash
# Install/sync tools from config
mise install

# Update all tools
mise upgrade

# Check current versions
mise current

# List available tool versions
mise ls-remote <tool>

# List outdated tools
mise outdated
```

## Service Management (LaunchAgents)

```bash
# List all user services
launchctl list

# Check specific service
launchctl list | grep <service-name>

# Get service details
launchctl print gui/$(id -u)/<service-name>

# Manually load service
launchctl load ~/Library/LaunchAgents/<service-name>.plist

# Manually unload service
launchctl unload ~/Library/LaunchAgents/<service-name>.plist

# Start service
launchctl start <service-name>

# Stop service
launchctl stop <service-name>
```

## Git Operations

```bash
# Check repository status
git status

# View commit history
git log --oneline

# Show current branch
git branch --show-current

# View changes
git diff

# View staged changes
git diff --cached
```

## Verification Commands

```bash
# Check if package is installed
which <package-name>

# Check package version
<package-name> --version

# Verify configuration file exists
cat ~/.config/<program>/config

# List installed packages (Home Manager)
home-manager packages

# List Nix generations
nix-env --list-generations
```

## Debugging Commands

```bash
# Check system logs
log show --predicate 'process == "launchd"' --last 5m

# Verify plist file
plutil ~/Library/LaunchAgents/<service-name>.plist

# Check Nix store path
nix-store --query --requisites <path>

# Verify file permissions
ls -la <file-path>
```

## Quick Workflow

### Standard Configuration Change

```bash
# 1. Edit Nix module
vim modules/...

# 2. Format (if Hooks fail)
fd -e nix --exec-batch nix fmt

# 3. Build
nix run nix-darwin -- build --flake .#cpwr-mba2

# 4. Deploy
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 5. Verify
which <package>
```

### Update and Rebuild

```bash
# 1. Update inputs
nix flake update

# 2. Build
nix run nix-darwin -- build --flake .#cpwr-mba2

# 3. Deploy
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Cleanup

```bash
# 1. Delete old generations
nix-env --delete-generations old

# 2. Run garbage collection
nix store gc
```
