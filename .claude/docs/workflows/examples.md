# Workflow Examples

## Adding a Package

### Scenario
Add `neovim` to system packages.

### Steps

```bash
# 1. Edit package list
vim modules/common/packages.nix

# Add package to the list:
#   pkgs.neovim

# 2. Build and deploy (Hooks will format automatically)
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 3. Verify installation
which neovim
neovim --version
```

## Modifying Program Configuration

### Scenario
Change Git user name and email.

### Steps

```bash
# 1. Edit Git module
vim modules/home-manager/programs/git/default.nix

# Modify configuration:
#   userName = "New Name";
#   userEmail = "new@example.com";

# 2. Build and deploy
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 3. Verify changes
git config --global user.name
git config --global user.email
```

## Changing System Settings

### Scenario
Enable/disable system preferences (e.g., dock auto-hide).

### Steps

```bash
# 1. Edit system configuration
vim modules/darwin/system.nix

# Modify system preferences:
#   system.defaults.dock.autohide = true;

# 2. Build and deploy
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 3. Verify system settings
# (May require logout/login or restart to see changes)
```

## Adding Environment Variable

### Scenario
Add `EDITOR` environment variable.

### Steps

```bash
# 1. Edit environment configuration
vim modules/common/environment.nix

# Add variable:
#   environment.variables = {
#     EDITOR = "nvim";
#   };

# 2. Build and deploy
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 3. Verify (start new shell session)
echo $EDITOR
```

## Adding Zsh Plugin

### Scenario
Add new Zsh plugin via Sheldon.

### Steps

```bash
# 1. Edit Sheldon configuration
vim modules/home-manager/programs/sheldon/default.nix

# Add plugin to plugins attribute set:
#   "zsh-syntax-highlighting" = {
#     github = "zsh-users/zsh-syntax-highlighting";
#   };

# 2. Build and deploy
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 3. Verify (start new shell session)
# Plugin should be loaded automatically
```

## Updating SSH Configuration

### Scenario
Add new SSH host configuration.

### Steps

```bash
# 1. Edit SSH module
vim modules/home-manager/programs/ssh/default.nix

# Add host configuration:
#   matchBlocks."example.com" = {
#     hostname = "example.com";
#     user = "username";
#     identityFile = "~/.ssh/id_ed25519";
#   };

# 2. Build and deploy
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 3. Verify SSH configuration
cat ~/.ssh/config
ssh -T example.com
```

## Adding LaunchAgent Service

### Scenario
Add user service (LaunchAgent) for auto-starting application.

### Steps

```bash
# 1. Create service module
vim modules/home-manager/services/my-service.nix

# Define service (see existing services for examples)

# 2. Import service in darwin.nix
vim modules/home-manager/services/darwin.nix

# Add import:
#   ./my-service.nix

# 3. Build and deploy
nix run nix-darwin -- build --flake .#cpwr-mba2
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2

# 4. Verify service is loaded
launchctl list | grep my-service
```

## Manual Format Fallback

If Claude Code Hooks fail to format:

```bash
# Format all Nix files before build
fd -e nix --exec-batch nix fmt

# Then proceed with build
nix run nix-darwin -- build --flake .#cpwr-mba2
```
