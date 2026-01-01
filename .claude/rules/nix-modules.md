---
paths: modules/**/*.nix
---

# Nix Module Guidelines

This file is automatically loaded when working with Nix modules in the `modules/` directory.

## Critical Requirements

1. **Follow nix-darwin conventions** for system-level configuration
2. **Use home-manager** for user-level configuration (programs, services)
3. **Always test with build before deploy** to catch errors early

## Module Structure

```
modules/
├── common/           # Cross-platform (shared between Darwin/Linux)
├── darwin/           # macOS-specific (system settings, system services)
└── home-manager/     # User-level (programs, user services)
```

**Placement rules:**
- System packages → `common/packages.nix` or `darwin/packages.nix`
- Program configuration → `home-manager/programs/<program>/`
- User services (LaunchAgents) → `home-manager/services/`
- System services (LaunchDaemons) → `darwin/services.nix`
- Environment variables → `common/environment.nix`

## Best Practices

### Code Style

- **Variable naming**: Follow existing patterns in the file
- **Alphabetical order**: Maintain in package lists and attribute sets
- **Comments**: Reference upstream documentation URLs for complex configurations
- **Formatting**: Hooks auto-format; manual fallback: `fd -e nix --exec-batch nix fmt`

### Configuration Patterns

**Programs** (declarative configuration):
```nix
programs.git = {
  enable = true;
  userName = "...";
  # ...
};
```

**Services** (LaunchAgents):
```nix
launchd.agents.<service-name> = {
  enable = true;
  serviceConfig = { ... };
};
```

**Packages** (installation only):
```nix
environment.systemPackages = with pkgs; [
  neovim
  # ...
];
```

## Deployment Workflow

**Always follow this sequence:**

```bash
# 1. Format (automated by Hooks, manual if needed)
fd -e nix --exec-batch nix fmt

# 2. Build (test without applying)
nix run nix-darwin -- build --flake .#cpwr-mba2

# 3. Deploy (REQUIRES sudo)
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 4. Verify changes work correctly
```

**CRITICAL**: Never skip the build step. It catches syntax errors and conflicts before deployment.

## Path Mapping Quick Reference

When user mentions a home directory file, translate to Nix module:

| User says | Edit this module |
|---|---|
| "Edit my zshrc" | `modules/home-manager/programs/zsh/default.nix` |
| "Change git config" | `modules/home-manager/programs/git/default.nix` |
| "Add a package" | `modules/common/packages.nix` or `modules/darwin/packages.nix` |
| "Configure SSH" | `modules/home-manager/programs/ssh/default.nix` |

**Full mapping**: `.claude/docs/reference/path-mapping.md`

## Common Issues

**Build errors**: See `.claude/docs/troubleshooting.md`

**Deployment fails**:
- Check `sudo` is used
- Verify no uncommitted changes in secrets/

**Changes not applied**:
- Restart affected application
- Check service status: `launchctl list | grep <service-name>`
