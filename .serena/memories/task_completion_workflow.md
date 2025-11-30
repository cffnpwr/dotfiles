# Task Completion Workflow

## Configuration Management Decision Tree

Before ANY configuration change, determine the appropriate management system:

### Decision Process

1. **Is this a system setting or package?** → Use Nix (Primary)
2. **Is this a program configuration?** → Check if Nix module exists:
   - Exists → Use Nix
   - Not exists → Use chezmoi (Legacy) or create Nix module
3. **Is this a secret?** → Use agenix
4. **Is this a custom shell script/plugin?** → Use chezmoi (Legacy)

## Nix-Based Workflow (Primary)

### Pre-Execution Checks

1. Identify which Nix module to edit:
   - System packages: `modules/common/packages.nix` or `modules/darwin/packages.nix`
   - Program config: `modules/home-manager/programs/<program>/`
   - System settings: `modules/darwin/system.nix`
   - User services: `modules/home-manager/services/`
   - Secrets: `secrets/` directory

### Edit and Deploy Workflow

```bash
# 1. Edit Nix configuration files
# Edit files in modules/ directory

# 2. Check Nix syntax
nix flake check

# 3. Build configuration (test without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# 4. Apply changes (requires sudo)
nix run nix-darwin -- switch --flake .#cpwr-mba2

# 5. Verify changes
# Check affected applications/services
```

### Validation Checklist

- [ ] Nix files edited in `modules/` directory
- [ ] `nix flake check` passed without errors
- [ ] `nix run nix-darwin -- build` completed successfully
- [ ] Changes applied with `nix run nix-darwin -- switch`
- [ ] Target applications/services restarted if necessary
- [ ] System behaves as expected

## chezmoi-Based Workflow (Legacy)

### Critical Pre-Execution Checks

Before ANY file operation:

1. Verify target path does NOT start with `/Users/cffnpwr/` (home directory)
2. If home directory path detected → STOP → Convert to chezmoi source path
3. Edit ONLY in `/Users/cffnpwr/.local/share/chezmoi/homedir/`

### Edit and Deploy Workflow

```bash
# 1. Edit files in homedir/ directory
# NEVER edit files in /Users/cffnpwr/

# 2. Preview changes
chezmoi diff --no-tty

# 3. Validate changes (dry run)
chezmoi apply --dry-run --no-tty

# 4. Deploy changes
chezmoi apply --no-tty

# 5. Verify target application
# Restart/reload if necessary
```

### Path Mapping Examples

```text
~/.zshrc                    → homedir/dot_config/zsh/dot_zshrc
~/.config/starship.toml     → homedir/dot_config/starship.toml
~/.ssh/config              → homedir/private_dot_ssh/private_config
~/.Brewfile                → homedir/dot_Brewfile
```

### Validation Checklist

- [ ] NO files edited in `/Users/cffnpwr/` (home directory)
- [ ] ALL edits made in `/Users/cffnpwr/.local/share/chezmoi/homedir/`
- [ ] `chezmoi diff --no-tty` executed successfully
- [ ] `chezmoi apply --no-tty` executed successfully
- [ ] Target applications restarted/reloaded if necessary

## Secret Management Workflow (agenix)

```bash
# 1. Edit encrypted secret
agenix -e secrets/<secret-name>.age

# 2. Rekey if needed (after key rotation)
agenix --rekey

# 3. Rebuild system to apply secrets
nix run nix-darwin -- switch --flake .#cpwr-mba2
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
   - [ ] `nix flake check` passed
   - [ ] Successfully built with `nix run nix-darwin -- build`
   - [ ] Successfully applied with `nix run nix-darwin -- switch`

2. **chezmoi Changes** (if applicable):
   - [ ] `chezmoi diff --no-tty` reviewed
   - [ ] `chezmoi apply --no-tty` executed

3. **Documentation**:
   - [ ] Markdown linting passed
   - [ ] Japanese text linting passed (if applicable)

4. **System Verification**:
   - [ ] Target application functioning correctly
   - [ ] No unexpected side effects
   - [ ] Services restarted/reloaded if necessary
