# Troubleshooting

## Build Errors

### Syntax Error in Nix Expression

**Issue**: Build fails with syntax error

**Error Example**:
```
error: syntax error, unexpected '}'
```

**Solutions**:
1. Check Nix syntax in recent changes
2. Verify bracket/parenthesis matching
3. Run formatter:
   ```bash
   fd -e nix --exec-batch nix fmt
   ```
4. Use Nix LSP (nil/nixd) in editor for real-time syntax checking

### Undefined Attribute

**Issue**: "error: attribute 'X' missing"

**Solutions**:
1. **For packages**: Verify package exists in nixpkgs
   ```bash
   nix search nixpkgs <package-name>
   ```

2. **For options**: Check option exists
   - Search [Home Manager options](https://nix-community.github.io/home-manager/options.html)
   - Search [nix-darwin options](https://daiderd.com/nix-darwin/manual/index.html)

3. **For modules**: Verify module is imported
   ```bash
   rg "import.*<module-name>" modules/
   ```

### Module Import Error

**Issue**: Module not found or import fails

**Solutions**:
1. Check module path is correct
2. Verify `default.nix` imports the module
3. Ensure module file exists:
   ```bash
   ls -la modules/home-manager/programs/<module-name>/
   ```

### Infinite Recursion

**Issue**: "error: infinite recursion encountered"

**Solutions**:
1. Check for circular dependencies between modules
2. Review recent module imports
3. Use `nix-instantiate` to debug:
   ```bash
   nix-instantiate --eval flake.nix
   ```

## Deployment Errors

### Permission Denied

**Issue**: Deployment fails with permission error

**Solution**:
```bash
# ALWAYS use sudo for deployment
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
```

### Service Activation Failed

**Issue**: LaunchAgent fails to activate during deployment

**Solutions**:
1. Check service logs:
   ```bash
   log show --predicate 'process == "launchd"' --last 5m
   ```

2. Verify service plist:
   ```bash
   plutil ~/Library/LaunchAgents/<service-name>.plist
   ```

3. Manually load service:
   ```bash
   launchctl load ~/Library/LaunchAgents/<service-name>.plist
   ```

### Profile Activation Failed

**Issue**: "error: activation script failed"

**Solutions**:
1. Check activation script output for errors
2. Review recent system configuration changes
3. Try rollback:
   ```bash
   sudo nix run nix-darwin -- switch --flake .#cpwr-mba2 --rollback
   ```

## Configuration Issues

### Configuration Not Applied

**Issue**: Changed configuration but not taking effect

**Solutions**:
1. Verify build completed successfully
2. Confirm deployment ran (not just build)
3. Check configuration file was actually changed:
   ```bash
   cat ~/.config/<program>/config
   ```
4. Some programs require restart to load new config
5. Verify module is enabled:
   ```nix
   programs.<name>.enable = true;
   ```

### Program Not Found After Installation

**Issue**: `which <program>` returns nothing after deployment

**Solutions**:
1. Restart shell to reload PATH:
   ```bash
   exec zsh
   ```

2. Verify program is in packages:
   ```bash
   home-manager packages | grep <program>
   ```

3. Check deployment completed without errors

4. Verify program package name is correct in Nix

## Secret Management Issues

### Cannot Edit Secret

**Issue**: `agenix -e` fails

**Solutions**:
1. Check age key exists and has correct permissions:
   ```bash
   ls -la ~/.config/age/key.txt
   # Should be: -rw------- (600)
   chmod 600 ~/.config/age/key.txt
   ```

2. Verify your public key is in `secrets/secrets.nix`

3. Check $EDITOR is set:
   ```bash
   echo $EDITOR
   export EDITOR=vim  # or nvim, nano, etc.
   ```

### Secret Not Available After Deployment

**Issue**: `/run/agenix/<secret>` doesn't exist

**Solutions**:
1. Verify secret is defined in `secrets/secrets.nix`
2. Ensure secret is referenced in Nix module:
   ```nix
   age.secrets.<name>.file = ../../secrets/<name>.age;
   ```
3. Rebuild and redeploy:
   ```bash
   sudo nix run nix-darwin -- switch --flake .#cpwr-mba2
   ```

### Cannot Decrypt Secret After Key Change

**Issue**: Secrets can't be decrypted with new key

**Solution**:
1. Restore old key temporarily
2. Rekey secrets:
   ```bash
   agenix --rekey
   ```
3. Switch back to new key

## Service Issues

### Service Not Starting

**Issue**: LaunchAgent doesn't start

**Solutions**:
1. Check service is loaded:
   ```bash
   launchctl list | grep <service-name>
   ```

2. Check for errors:
   ```bash
   tail -f /tmp/<service-name>.err.log
   ```

3. Verify executable path:
   ```bash
   ls -la /path/to/executable
   ```

4. Check service configuration:
   ```bash
   launchctl print gui/$(id -u)/<service-name>
   ```

### Service Exits Immediately

**Issue**: Service starts but exits right away

**Solutions**:
1. Check error logs:
   ```bash
   cat /tmp/<service-name>.err.log
   ```

2. Test command manually:
   ```bash
   /path/to/executable [arguments]
   ```

3. Verify working directory exists
4. Check environment variables are set correctly

### Service Not Restarting

**Issue**: Service exits and doesn't restart

**Solutions**:
1. Verify `KeepAlive = true` in service config
2. Check service exit status indicates error (not intentional exit)
3. Review service logs for crash reason

## Flake Issues

### Flake Lock Conflict

**Issue**: "error: flake lock file is out of date"

**Solution**:
```bash
nix flake lock --update-input <input-name>
# or update all inputs
nix flake update
```

### Input Not Found

**Issue**: "error: input 'X' not found"

**Solutions**:
1. Verify input is defined in `flake.nix` inputs
2. Check input URL is correct
3. Update flake lock:
   ```bash
   nix flake update
   ```

### Flake Check Fails

**Issue**: `nix flake check` reports errors

**Solutions**:
1. Read error output carefully
2. Fix reported issues in modules
3. Verify all imports are correct
4. Check for unused imports or definitions

## Package Issues

### Package Build Fails

**Issue**: Package fails to build during deployment

**Solutions**:
1. Check package is available for your system:
   ```bash
   nix search nixpkgs <package-name>
   ```

2. Update nixpkgs input:
   ```bash
   nix flake lock --update-input nixpkgs
   ```

3. Check package build logs for specific errors

4. Try building package separately:
   ```bash
   nix build nixpkgs#<package-name>
   ```

### Custom Package Not Found

**Issue**: Custom package from cffnpwr-nixpkgs not found

**Solutions**:
1. Verify package exists:
   ```bash
   nix flake show github:cffnpwr/nixpkgs
   ```

2. Update custom packages input:
   ```bash
   nix flake lock --update-input cffnpwr-nixpkgs
   ```

3. Check overlay is configured in `flake.nix`

## System Issues

### Disk Space Full

**Issue**: Nix store consuming too much disk space

**Solution**:
```bash
# Delete old generations
nix-env --delete-generations old

# Run garbage collection
nix store gc

# Check disk usage
df -h
du -sh /nix/store
```

### Slow Build Times

**Issue**: Builds taking very long

**Solutions**:
1. Enable binary cache (usually enabled by default)
2. Check network connection
3. Clean up old generations to free space:
   ```bash
   nix store gc
   ```
4. Consider using `--option builders ""` to force local builds

## General Debugging

### Enable Verbose Output

```bash
# Build with verbose output
nix run nix-darwin -- build --flake .#cpwr-mba2 --show-trace

# Very verbose
nix run nix-darwin -- build --flake .#cpwr-mba2 --show-trace -vvv
```

### Check System Logs

```bash
# View recent system logs
log show --last 10m

# Filter for specific process
log show --predicate 'process == "launchd"' --last 5m
```

### Verify File Permissions

```bash
# Check file permissions
ls -la <file-path>

# Fix common permission issues
chmod 600 ~/.config/age/key.txt
chmod 644 ~/.config/<program>/config
```

## Getting Help

### Check Documentation

1. This troubleshooting guide
2. Workflow documentation: `.claude/docs/workflows/`
3. Reference documentation: `.claude/docs/reference/`
4. Critical rules: `.claude/docs/critical/rules.md`

### Search for Similar Issues

```bash
# Search codebase for similar configurations
rg "<search-term>" modules/

# Check git history
git log --oneline -- <file-path>
```

### Rollback Strategy

If all else fails:
```bash
# Rollback to previous working generation
sudo nix run nix-darwin -- switch --flake .#cpwr-mba2 --rollback

# List generations to rollback to specific one
nix-env --list-generations
```
