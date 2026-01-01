# Module Management

## Overview

This section covers adding new programs and services to the Nix configuration.

**Module Types:**
- **Program modules**: User-facing applications and tools
- **Service modules**: Background services (LaunchAgents)
- **Custom packages**: Packages from cffnpwr-nixpkgs repository

## Task-Specific Guides

### Adding Programs

Adding new program with Home Manager configuration.

→ Read: `.claude/docs/workflows/modules/adding-programs.md`

**Common tasks:**
- Install new CLI tool with configuration
- Add GUI application
- Configure existing program

### Adding Services

Adding background services (LaunchAgents).

→ Read: `.claude/docs/workflows/modules/adding-services.md`

**Common tasks:**
- Auto-start applications
- Run background processes
- Schedule periodic tasks

### Working with Custom Packages

Using packages from cffnpwr-nixpkgs repository.

→ Read: `.claude/docs/workflows/modules/custom-packages.md`

**Common tasks:**
- Use custom package in configuration
- Update custom packages
- Add new custom package (requires editing cffnpwr-nixpkgs repo)
