# Task Completion Workflow

## Critical Pre-Execution Checks
Before ANY file operation:
1. Verify target path does not start with `/Users/cffnpwr/` (home directory)
2. If home directory path detected → STOP → Convert to chezmoi source path
3. Edit ONLY in `/Users/cffnpwr/.local/share/chezmoi/homedir/`

## Required Commands After Task Completion

### 1. Linting and Validation
```bash
# Lint Markdown files if modified
markdownlint **/*.md

# Lint Japanese text if documentation changed
textlint **/*.md

# Fix textlint issues
textlint --fix **/*.md
```

### 2. chezmoi Verification and Deployment
```bash
# MANDATORY: Preview changes
chezmoi diff --no-tty

# Validate changes (dry run)
chezmoi apply --dry-run --no-tty

# Deploy changes
chezmoi apply --no-tty
```

### 3. System Validation
```bash
# Check chezmoi health
chezmoi doctor

# Verify package dependencies if Brewfile changed
brew bundle check --file ~/.Brewfile

# Test configuration if shell files changed
zsh -n ~/.zshrc  # Syntax check for Zsh
```

### 4. Git Operations (Only via Claude Code slash commands)
```bash
# Use slash commands only
/git:status      # Check changes
/git:commit      # Commit with conventional format + Gitmoji
```

## Enforcement Checklist
Before completing ANY task:
- [ ] NO files edited in `/Users/cffnpwr/` (home directory)
- [ ] ALL edits made in `/Users/cffnpwr/.local/share/chezmoi/homedir/`
- [ ] `chezmoi diff --no-tty` executed successfully
- [ ] `chezmoi apply --no-tty` executed successfully
- [ ] Relevant linting tools run if applicable
- [ ] Target applications restarted/reloaded if necessary

## Path Mapping Examples
```text
~/.zshrc                    → homedir/dot_config/zsh/dot_zshrc
~/.config/starship.toml     → homedir/dot_config/starship.toml
~/.ssh/config              → homedir/private_dot_ssh/private_config
~/.Brewfile                → homedir/dot_Brewfile
```