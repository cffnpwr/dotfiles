# Adding Service Modules

## Overview

Service modules configure LaunchAgents that run in the background on macOS.

## Standard Workflow

### Step 1: Create Service Module

Create new module in `modules/home-manager/services/<service-name>.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  launchd.agents.<service-name> = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.<package>}/bin/<executable>"
        # Add arguments
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
```

### Step 2: Import Service

Edit `modules/home-manager/services/darwin.nix`:

```nix
{
  imports = [
    # ... existing imports
    ./<service-name>.nix
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

### Step 4: Verify Service

```bash
# Check service is loaded
launchctl list | grep <service-name>

# Check service status
launchctl print gui/$(id -u)/<service-name>

# View service logs (if configured)
tail -f /tmp/<service-name>.log
```

## Common LaunchAgent Options

### Essential Options

```nix
{
  ProgramArguments = [ ... ];  # Command and arguments to run
  RunAtLoad = true;            # Start service when loaded
  KeepAlive = true;            # Restart if service exits
}
```

### Logging Options

```nix
{
  StandardOutPath = "/tmp/<service-name>.out.log";
  StandardErrorPath = "/tmp/<service-name>.err.log";
}
```

### Execution Options

```nix
{
  WorkingDirectory = "/path/to/directory";  # Set working directory
  EnvironmentVariables = {                  # Set environment variables
    PATH = "/usr/bin:/bin";
  };
}
```

### Scheduling Options

```nix
{
  StartInterval = 3600;  # Run every hour (in seconds)

  # Or use StartCalendarInterval for specific times
  StartCalendarInterval = {
    Hour = 9;
    Minute = 0;
  };
}
```

## Service Examples

### Simple Application Auto-Start

`modules/home-manager/services/custom-app.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  launchd.agents.custom-app = {
    enable = true;
    config = {
      ProgramArguments = [
        "/Applications/CustomApp.app/Contents/MacOS/CustomApp"
      ];
      RunAtLoad = true;
      KeepAlive = false;  # Don't restart if user quits
    };
  };
}
```

### Background Service with Logging

`modules/home-manager/services/monitor.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  launchd.agents.monitor = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.my-monitor}/bin/monitor"
        "--config"
        "${config.home.homeDirectory}/.config/monitor/config.json"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/monitor.out.log";
      StandardErrorPath = "/tmp/monitor.err.log";
    };
  };
}
```

### Scheduled Task

`modules/home-manager/services/backup.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  launchd.agents.backup = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.restic}/bin/restic"
        "backup"
        "${config.home.homeDirectory}/Documents"
      ];
      StartCalendarInterval = {
        Hour = 2;    # Run at 2:00 AM
        Minute = 0;
      };
      StandardOutPath = "/tmp/backup.out.log";
      StandardErrorPath = "/tmp/backup.err.log";
    };
  };
}
```

## Service Management

### Manually Control Service

```bash
# Load service
launchctl load ~/Library/LaunchAgents/<service-name>.plist

# Unload service
launchctl unload ~/Library/LaunchAgents/<service-name>.plist

# Start service
launchctl start <service-name>

# Stop service
launchctl stop <service-name>
```

### Check Service Status

```bash
# List all user services
launchctl list

# Get detailed service info
launchctl print gui/$(id -u)/<service-name>

# Check if service is running
launchctl list | grep <service-name>
```

### View Service Logs

```bash
# View standard output
tail -f /tmp/<service-name>.out.log

# View standard error
tail -f /tmp/<service-name>.err.log

# View system logs for launchd
log show --predicate 'process == "launchd"' --last 5m
```

## Troubleshooting

### Service Not Starting

**Issue:** LaunchAgent doesn't start after deployment

**Solutions:**
```bash
# 1. Check service is loaded
launchctl list | grep <service-name>

# 2. Manually load service
launchctl load ~/Library/LaunchAgents/<service-name>.plist

# 3. Check for errors in system logs
log show --predicate 'process == "launchd"' --last 5m

# 4. Verify plist file exists and is valid
plutil ~/Library/LaunchAgents/<service-name>.plist
```

### Service Exits Immediately

**Issue:** Service starts but exits immediately

**Solutions:**
- Check `StandardErrorPath` log for error messages
- Verify `ProgramArguments` path is correct
- Ensure executable has proper permissions
- Check `WorkingDirectory` exists if specified
- Verify environment variables are set correctly

### Service Not Restarting

**Issue:** Service exits and doesn't restart

**Solution:**
- Ensure `KeepAlive = true` is set
- Check service exit status in logs
- LaunchAgent won't restart if exit status indicates intentional exit

### Service Runs at Wrong Time

**Issue:** Scheduled service runs at incorrect time

**Solution:**
- Verify `StartCalendarInterval` values
- Check system time and timezone
- Use `StartInterval` for simple periodic execution
- Note: Times are in 24-hour format

## Best Practices

1. **Logging**: Always configure `StandardOutPath` and `StandardErrorPath` for debugging
2. **KeepAlive**: Use cautiously - only for services that should always run
3. **Testing**: Test service manually before adding to Nix configuration
4. **Permissions**: Ensure service has necessary file/directory permissions
5. **Resources**: Be mindful of resource usage for always-running services
