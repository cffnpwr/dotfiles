# Working with Custom Packages

## Overview

Custom packages are managed in separate repository: [cffnpwr/nixpkgs](https://github.com/cffnpwr/nixpkgs)

These packages are integrated into this configuration via flake overlays.

**To see available packages**, check the cffnpwr-nixpkgs repository or run:
```bash
nix flake show github:cffnpwr/nixpkgs
```

## Using Custom Packages

Custom packages are available via overlay:

```nix
{ config, lib, pkgs, ... }:

{
  home.packages = [
    pkgs.custom-package-name  # From cffnpwr-nixpkgs overlay
  ];
}
```

### Example: Installing Custom Package

`modules/home-manager/packages/darwin.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ... other packages

    # Custom packages from cffnpwr-nixpkgs
    claude-desktop
    obsidian
  ];
}
```

## Updating Custom Packages

### Update All Custom Packages

```bash
# Update cffnpwr-nixpkgs flake input
nix flake lock --update-input cffnpwr-nixpkgs

# Rebuild to use updated packages
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Update Specific Package

Custom packages are updated in the cffnpwr-nixpkgs repository.
After updating in that repository, update the flake input here.

## Checking Custom Package Version

```bash
# Show current cffnpwr-nixpkgs version
nix flake metadata | grep cffnpwr-nixpkgs

# List available custom packages
nix flake show github:cffnpwr/nixpkgs

# Show package details
nix eval .#packages.aarch64-darwin.<package-name>.version
```

## Adding New Custom Package

New custom packages must be added in the cffnpwr-nixpkgs repository first.

### Workflow

1. **Add package to cffnpwr-nixpkgs repository**
   - Create package derivation
   - Add to overlay
   - Test build
   - Commit and push

2. **Update flake input in this repository**
   ```bash
   nix flake lock --update-input cffnpwr-nixpkgs
   ```

3. **Use package in configuration**
   ```nix
   home.packages = [ pkgs.new-custom-package ];
   ```

4. **Build and deploy**
   ```bash
   nix run nix-darwin -- build --flake .#cpwr-mba2
   sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
   ```

## Custom Package Integration

### Flake Configuration

`flake.nix`:

```nix
{
  inputs = {
    cffnpwr-nixpkgs.url = "github:cffnpwr/nixpkgs";
  };

  outputs = { self, nixpkgs, cffnpwr-nixpkgs, ... }: {
    # Overlay integrates custom packages
    overlays.default = cffnpwr-nixpkgs.overlays.default;
  };
}
```

### Overlay System

Custom packages are available as regular packages through overlay:

```nix
# In any module
{ pkgs, ... }:

{
  # Custom packages work like built-in packages
  home.packages = [ pkgs.claude-desktop ];
}
```

## Troubleshooting

### Custom Package Not Found

**Issue:** "error: attribute 'package-name' missing"

**Solution:**
```bash
# 1. Verify package exists in cffnpwr-nixpkgs
nix flake show github:cffnpwr/nixpkgs

# 2. Update flake input
nix flake lock --update-input cffnpwr-nixpkgs

# 3. Check overlay is applied
# Verify in flake.nix that overlay is configured
```

### Custom Package Build Fails

**Issue:** Build fails for custom package

**Solution:**
1. Check cffnpwr-nixpkgs repository for known issues
2. Verify package derivation is correct
3. May need to update package in cffnpwr-nixpkgs first
4. Check build logs for specific error

### Custom Package Version Outdated

**Issue:** Custom package is older version than expected

**Solution:**
```bash
# Update cffnpwr-nixpkgs input to latest commit
nix flake lock --update-input cffnpwr-nixpkgs

# Rebuild with updated package
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

## Best Practices

1. **Pin versions**: Use specific commits for stability
2. **Test updates**: Test custom package updates before deploying
3. **Documentation**: Document custom package usage in config comments
4. **Separation**: Keep custom packages in separate repository for maintainability
5. **Overlay usage**: Always use overlay system, don't duplicate package definitions
