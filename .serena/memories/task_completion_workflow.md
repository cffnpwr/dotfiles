# Task Completion Workflow

## Configuration Management - Nix Only

**CRITICAL**: This project uses **pure Nix** for ALL configuration management. There is NO chezmoi or other legacy systems.

### Pre-Execution Checks

Before ANY configuration change:

1. **Verify target path**: Check if path starts with `/Users/cffnpwr/` (home directory)
2. **Block direct edits**: If home directory path detected → STOP → NEVER PROCEED
3. **Map to Nix module**: Convert request to appropriate Nix module path
4. **Edit in modules/**: Make changes ONLY in `/Users/cffnpwr/.local/share/chezmoi/modules/`

### Path Mapping Table

```text
HOME DIRECTORY PATH                          → NIX MODULE PATH
~/.zshrc                                    → modules/home-manager/programs/zsh/
~/.config/starship.toml                     → modules/home-manager/programs/starship/
~/.ssh/config                               → modules/home-manager/programs/ssh/
~/.config/ghostty/                          → modules/home-manager/programs/ghostty/
~/.config/zellij/config.kdl                 → modules/home-manager/programs/zellij/
~/.config/mise/config.toml                  → modules/home-manager/programs/mise/
~/.config/sheldon/plugins.toml              → modules/home-manager/programs/sheldon/
~/.config/git/config                        → modules/home-manager/programs/git/
~/.config/aerospace/                        → modules/home-manager/programs/aerospace/
System packages                             → modules/common/packages.nix or modules/darwin/packages.nix
System settings                             → modules/darwin/system.nix
Environment variables                       → modules/common/environment.nix
User services (LaunchAgents)                → modules/home-manager/services/
```

## Nix Configuration Workflow

### Step-by-Step Process

```bash
# 1. Edit Nix configuration files in modules/ directory
# NEVER edit files in /Users/cffnpwr/ (home directory)

# 2. Format code
nix fmt

# 3. Validate flake
nix flake check

# 4. Build configuration (test without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# 5. Apply changes (requires sudo)
nix run nix-darwin -- switch --flake .#cpwr-mba2

# 6. Verify target application
# Restart/reload if necessary
```

### Module Selection Guide

**System Configuration**:
- System packages → `modules/common/packages.nix` or `modules/darwin/packages.nix`
- System settings → `modules/darwin/system.nix`
- Environment variables → `modules/common/environment.nix`
- User account → `modules/common/user.nix`

**Program Configurations**:
- Git → `modules/home-manager/programs/git/default.nix`
- SSH → `modules/home-manager/programs/ssh/default.nix`
- Shell (Zsh) → `modules/home-manager/programs/zsh/default.nix`
- Terminal (Ghostty) → `modules/home-manager/programs/ghostty/default.nix`
- Multiplexer (Zellij) → `modules/home-manager/programs/zellij/default.nix`
- Window Manager (Aerospace) → `modules/home-manager/programs/aerospace/default.nix`
- Browser (Zen) → `modules/home-manager/programs/zen-browser/default.nix`
- Prompt (Starship) → `modules/home-manager/programs/starship/default.nix`
- Plugin Manager (Sheldon) → `modules/home-manager/programs/sheldon/default.nix`
- Development tools (mise) → `modules/home-manager/programs/mise/default.nix`
- Mac App Store (mas) → `modules/home-manager/programs/mas/default.nix`

**Service Configurations** (LaunchAgents):
- User services → `modules/home-manager/services/`
- System services → `modules/darwin/services.nix`

**Secrets Management**:
- Edit secrets → `agenix -e secrets/<file>.age`
- Define secrets → `secrets/secrets.nix`

### Validation Checklist

Before marking a task as complete:

- [ ] NO files edited in `/Users/cffnpwr/` (home directory)
- [ ] ALL edits made in `/Users/cffnpwr/.local/share/chezmoi/modules/`
- [ ] Code formatted with `nix fmt`
- [ ] Flake validated with `nix flake check`
- [ ] Build tested with `nix run nix-darwin -- build --flake .#cpwr-mba2`
- [ ] Changes applied with `nix run nix-darwin -- switch --flake .#cpwr-mba2`
- [ ] Target application restarted/reloaded if necessary
- [ ] System behaves as expected

## Secret Management Workflow (agenix)

```bash
# 1. Edit encrypted secret
agenix -e secrets/<secret-name>.age

# 2. Rekey if needed (after key rotation)
agenix --rekey

# 3. Rebuild system to apply secrets
nix run nix-darwin -- switch --flake .#cpwr-mba2
```

## Custom Package Workflow

Custom packages are managed in separate repository (cffnpwr-nixpkgs):

```bash
# 1. Edit package in cffnpwr-nixpkgs repository
# 2. Commit and push changes
# 3. Update flake input in this repository
nix flake lock --update-input cffnpwr-nixpkgs

# 4. Rebuild system
nix run nix-darwin -- switch --flake .#cpwr-mba2
```

## Adding New Programs

```bash
# 1. Create module in modules/home-manager/programs/<program-name>/default.nix
# 2. Import in modules/home-manager/programs/default.nix
# 3. Test build
nix run nix-darwin -- build --flake .#cpwr-mba2

# 4. Apply changes
nix run nix-darwin -- switch --flake .#cpwr-mba2
```

## Adding New Services

```bash
# 1. Create service in modules/home-manager/services/<service-name>.nix
# 2. Import in modules/home-manager/services/darwin.nix (for macOS services)
# 3. Test and apply same as programs
```

## Linting and Quality Checks

### After ANY Documentation Changes

```bash
# Lint Markdown files
markdownlint **/*.md

# Lint Japanese text
textlint **/*.md

# Fix textlint issues
textlint --fix **/*.md
```

### After ANY Nix Changes

```bash
# Format Nix files
nix fmt

# Check Nix syntax and evaluation
nix flake check
```

## Git Operations (Only via Slash Commands)

```bash
# Use slash commands only
/git:status      # Check changes
/git:commit      # Commit with conventional format + Gitmoji
```

## Complete Task Verification

Before marking a task as complete:

1. **Nix Changes**:
   - [ ] `nix fmt` executed
   - [ ] `nix flake check` passed
   - [ ] Successfully built with `nix run nix-darwin -- build`
   - [ ] Successfully applied with `nix run nix-darwin -- switch`

2. **Documentation**:
   - [ ] Markdown linting passed
   - [ ] Japanese text linting passed (if applicable)

3. **System Verification**:
   - [ ] Target application functioning correctly
   - [ ] No unexpected side effects
   - [ ] Services restarted/reloaded if necessary
