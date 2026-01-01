# Critical Rules

## 🚨 ABSOLUTE CONSTRAINTS - VIOLATION = IMMEDIATE TASK FAILURE

### Core Principle

**ALL configurations are managed via Nix modules.**

- ✅ CORRECT: Edit files in `modules/` directory
- ❌ FORBIDDEN: Direct editing of files in home directory

### Mandatory Pre-Execution Check

**BEFORE ANY FILE OPERATION**, verify the target path:

1. **DETECTION**: Check if path is in home directory (e.g., `~/.config/`, `~/.zshrc`)
2. **BLOCKING**: If home directory detected → IMMEDIATELY STOP → NEVER PROCEED
3. **CORRECTION**: Map to corresponding Nix module (see path-mapping.md)
4. **EXECUTION**: Edit ONLY Nix modules in repository

### Violation Consequences

- ANY direct home directory edit = IMMEDIATE TASK FAILURE
- NO EXCEPTIONS for "quick fixes", "temporary changes", or "urgent updates"
- MUST restart entire workflow with proper Nix module management

### Deployment Requirements

**CRITICAL**: Deployment commands REQUIRE sudo privilege.

❌ WRONG:
```bash
nix run nix-darwin -- switch --flake .#cpwr-mba2
```

✅ CORRECT:
```bash
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Common Violations to Avoid

**❌ DO NOT DO THIS:**
```bash
# Direct editing of home directory files
vim ~/.zshrc
echo "alias foo='bar'" >> ~/.zshrc
git config --global user.name "John Doe"
ssh-keygen -f ~/.ssh/id_ed25519
```

**✅ DO THIS INSTEAD:**
```bash
# Edit corresponding Nix module
vim modules/home-manager/programs/zsh/default.nix
vim modules/home-manager/programs/git/default.nix
vim modules/home-manager/programs/ssh/default.nix

# Format, build, and deploy
fd -e nix --exec-batch nix fmt
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Safety Protocols

**YOU MUST:**
- Create backups before critical system configuration changes
- Apply system-wide changes (zsh, ssh, etc.) incrementally
- Test build before deployment (`build` before `switch`)
- Verify changes after deployment

**NEVER:**
- Edit files in home directory directly
- Skip formatting before build
- Deploy without testing build first
- Forget to use sudo for deployment
