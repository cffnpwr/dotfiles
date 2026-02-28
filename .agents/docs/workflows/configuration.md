# Configuration Change Workflow

## Standard Workflow for Configuration Changes

Use this workflow for ANY configuration change:
- Adding/removing packages
- Modifying program settings
- Changing system preferences
- Updating environment variables

### Step-by-Step Process

#### 1. IDENTIFY

Determine which component needs modification.

**Examples:**
- "Add neovim package" → System packages
- "Change SSH settings" → SSH program configuration
- "Update environment variable" → Environment configuration
- "Add LaunchAgent" → User service configuration

#### 2. LOCATE

Find corresponding Nix module using path mapping.

**Quick Reference:**
- System packages → `modules/common/packages.nix` or `modules/darwin/packages.nix`
- Program configs → `modules/home-manager/programs/<program-name>/`
- System settings → `modules/darwin/system.nix`
- Environment vars → `modules/common/environment.nix`
- User services → `modules/home-manager/services/`

**Full mapping**: See `.claude/docs/reference/path-mapping.md`

#### 3. EDIT

Modify the appropriate `.nix` file in `modules/` directory.

**Best Practices:**
- Follow existing code style and patterns
- Use meaningful variable names
- Add comments for complex configurations
- Reference upstream documentation in comments

#### 4. FORMAT

**Primary**: Claude Code Hooks will automatically format Nix files.

**Manual Fallback** (if Hooks fail):
```bash
# Format all Nix files in repository
fd -e nix --exec-batch nix fmt

# Format specific file or directory
nix fmt <path>
```

#### 5. BUILD

Test configuration without applying changes.

```bash
# Build configuration (does NOT apply changes)
nix run nix-darwin -- build --flake .#cpwr-mba2
```

**Check for:**
- Build errors (syntax errors, undefined variables)
- Warnings (deprecated options, conflicts)
- Successful completion message

#### 6. VALIDATE

Review build output for errors and warnings.

**Common Issues:**
- Syntax errors in Nix expression
- Undefined packages or options
- Module conflicts or duplicates
- Missing dependencies

**If build fails:**
- Read error message carefully
- Fix identified issues
- Return to step 4 (FORMAT) and repeat

#### 7. DEPLOY

Apply changes to system (REQUIRES SUDO).

```bash
# Apply configuration to system
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

**CRITICAL:** Must use `sudo` prefix.

**During deployment:**
- System will rebuild configuration
- Changed programs will be relinked
- Services will be restarted if needed
- May take several minutes

#### 8. VERIFY

Confirm changes are applied correctly.

**Verification steps:**
- Check target application launches correctly
- Verify configuration changes are active
- Test functionality affected by changes
- Review service status if services were modified

**Verification commands:**
```bash
# Check Nix package is installed
which <package-name>

# Verify program configuration
cat ~/.config/<program>/config

# Check service status (for LaunchAgents)
launchctl list | grep <service-name>
```

## Incremental Changes

For complex configurations:
1. Make small, incremental changes
2. Build and deploy after each change
3. Verify before proceeding to next change
4. Easier to identify issues and rollback if needed

## Rollback

If deployment causes issues:

```bash
# List previous generations
nix-env --list-generations

# Rollback to previous generation
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2 --rollback
```

## Workflow Examples

See `.claude/docs/workflows/examples.md` for practical workflow examples:
- Adding a package
- Modifying program configuration
- Changing system settings
