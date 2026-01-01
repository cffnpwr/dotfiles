# Adding Program Modules

## Overview

Program modules configure user-facing applications and tools using Home Manager.

## Standard Workflow

### Step 1: Create Module File

Create new module in `modules/home-manager/programs/<program-name>/default.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  programs.<program-name> = {
    enable = true;
    # Add program-specific configuration
  };
}
```

**Best Practices:**
- Use `programs.<name>` for Home Manager programs
- Enable with `enable = true`
- Follow existing module patterns in repository
- Add comments for complex configurations

### Step 2: Import Module

Edit `modules/home-manager/programs/default.nix`:

```nix
{
  imports = [
    # ... existing imports
    ./<program-name>
  ];
}
```

### Step 3: Build and Deploy

```bash
# Build configuration
nix run nix-darwin -- build --flake .#cpwr-mba2

# Deploy if build succeeds
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Step 4: Verify

```bash
# Check program is available
which <program-name>

# Check configuration is applied
cat ~/.config/<program-name>/config
```

## Module Examples

### Simple Program (Config Only)

`modules/home-manager/programs/bat/default.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };
}
```

### Program with Plugins

`modules/home-manager/programs/neovim/default.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      telescope-nvim
    ];
  };
}
```

### Program with External Config Files

`modules/home-manager/programs/alacritty/default.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };
}
```

Directory structure:
```
modules/home-manager/programs/alacritty/
├── default.nix
└── config.toml
```

## Module Organization

### When to Create Separate Module

**Create separate module when:**
- Program has significant configuration (>20 lines)
- Configuration may change frequently
- Reusable across multiple hosts
- Has external config files

**Use inline configuration when:**
- Simple enable/disable
- Minimal configuration options
- Rarely changes

### Recommended Directory Structure

```
modules/home-manager/programs/<program-name>/
├── default.nix           # Main module
├── config/               # Config files (optional)
│   └── config.toml
└── scripts/              # Helper scripts (optional)
    └── helper.sh
```

## Common Home Manager Options

### Programs with Built-in Home Manager Support

Check Home Manager options:
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)

Examples:
```nix
programs.git.enable = true;
programs.zsh.enable = true;
programs.ssh.enable = true;
programs.starship.enable = true;
```

### Programs without Built-in Support

Install via `home.packages` and manage config with `xdg.configFile`:

```nix
{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.custom-tool ];

  xdg.configFile."custom-tool/config.yaml".text = ''
    option: value
  '';
}
```

## Troubleshooting

### Module Import Error

**Issue:** "error: attribute '...' missing"

**Solution:**
- Verify module is imported in `default.nix`
- Check for typos in import path
- Ensure module file exists

### Configuration Not Applied

**Issue:** Program configuration doesn't take effect

**Solution:**
- Verify module is enabled (`enable = true`)
- Check Home Manager applies configuration
- Some programs require restart to load new config
- Check `~/.config/<program>/` for generated config

### Program Not in PATH

**Issue:** Program installed but `which <program>` returns nothing

**Solution:**
- Restart shell to reload PATH
- Check program is in `home.packages` or `programs.<name>.package`
- Verify deployment completed successfully
