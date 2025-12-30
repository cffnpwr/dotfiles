# Code Style and Conventions

## Nix Code Style

### General Formatting

- **Indentation**: 2 spaces for all Nix files
- **Line Length**: Prefer 80 characters, max 120
- **String Literals**: Use double quotes `"string"` for simple strings
- **Multi-line Strings**: Use `''` for multi-line strings (heredoc)
- **Lists**: Always use trailing commas in multi-line lists
- **Attribute Sets**: Use trailing semicolons
- **Formatter**: Use `nixfmt-rfc-style` (via `nix fmt`)

### Nix Best Practices

```nix
# Good: Trailing commas, proper indentation
{
  packages = [
    pkgs.git
    pkgs.vim
    pkgs.nodejs
  ];
  
  environment.variables = {
    EDITOR = "vim";
    LANG = "en_US.UTF-8";
  };
}

# Good: Use `lib` for conditionals
programs.git.enable = lib.mkDefault true;

# Good: Use `lib.mkIf` for conditional configuration
config = lib.mkIf config.programs.git.enable {
  # configuration here
};
```

### Module Structure

```nix
# Standard module template
{ config, pkgs, lib, ... }:
{
  options = {
    # Option definitions
  };
  
  config = {
    # Configuration implementation
  };
}
```

## File Naming Conventions

### Nix Files

- `default.nix`: Main module entry point
- `<program>.nix`: Program-specific configuration
- `<category>.nix`: Category-specific configuration (e.g., `packages.nix`)

### Directory Structure

```text
modules/
├── common/          # Cross-platform configuration
│   ├── default.nix  # Module loader
│   └── *.nix        # Individual modules
├── darwin/          # macOS-specific configuration
│   ├── default.nix  # Module loader
│   └── *.nix        # Individual modules
└── home-manager/    # User environment
    ├── default.nix  # Entry point
    ├── packages/    # Package lists
    ├── programs/    # Program configs
    └── services/    # User services
```

## EditorConfig Standards

- **Indentation**: 2 spaces for most files
- **Nix**: 2 spaces (not tabs)
- **Go**: Tab indentation for Go files
- **Line Endings**: LF (Unix-style)
- **Character Encoding**: UTF-8
- **Trailing Whitespace**: Trim automatically
- **Final Newline**: Always insert

## Markdown and Documentation

### Markdown Style

- **Linting**: markdownlint-cli with 120 character line length limit
- **Headings**: Use ATX style (`#` prefix)
- **Lists**: Consistent indentation (2 spaces)
- **Code Blocks**: Always specify language

### Japanese Text

- **Linting**: textlint with Japanese technical writing presets
  - ja-technical-writing preset
  - ai-writing preset
  - ja-spacing preset
  - Comments filtering enabled
- **Style**: Technical documentation style (体言止め for headings)

## Git Conventions

### Commit Message Format

Use Conventional Commits format with Gitmoji:

```text
<type> <emoji>: <Japanese message in noun form>
```

### Common Types and Emojis

- `feat ✨`: New feature
- `fix 🐛`: Bug fix
- `perf ⚡`: Performance improvement
- `refactor ♻️`: Code refactoring
- `style 🎨`: Code style/formatting
- `docs 📝`: Documentation
- `test ✅`: Tests
- `chore 🔧`: Maintenance
- `build 📦`: Build system
- `ci 👷`: CI/CD

### Examples

```text
feat ✨: Nix設定の追加
fix 🐛: Home Manager設定の修正
perf ⚡: ビルド時間の最適化
docs 📝: CLAUDE.md更新
chore 🔧: flake.lock更新
```

## Secret Management

### agenix Secrets

- Store secrets in `secrets/` directory
- Use `.age` extension for encrypted files
- Define secrets in `secrets/secrets.nix`
- Never commit unencrypted secrets
- Never log or display secret contents

### Age Key Management

- Age key location: `~/.config/age/key.txt` (permissions: 600)
- Encrypted age key in repository: `key.txt.age`
- Edit secrets: `agenix -e secrets/<file>.age`
- Rekey after key change: `agenix --rekey`

## Configuration Management

### Nix Configuration (Only Method)

- **ALL** system and package configuration through Nix
- Modular structure in `modules/` directory
- Host-specific configuration in `hosts/` directory
- Secrets managed with agenix
- Clear separation between common, Darwin, and Home Manager configs
- Custom packages in separate repository (cffnpwr-nixpkgs)

### Module Organization

```text
modules/
├── common/          # Cross-platform configuration
│   ├── default.nix  # Module loader
│   ├── packages.nix # Common packages
│   ├── environment.nix # Environment variables
│   ├── fonts.nix    # Font configuration
│   └── user.nix     # User account
├── darwin/          # macOS-specific
│   ├── default.nix  # Module loader
│   ├── system.nix   # System settings
│   ├── packages.nix # macOS packages
│   ├── services.nix # System services
│   └── user.nix     # User shell
└── home-manager/    # User environment
    ├── default.nix  # Entry point
    ├── packages/    # Package lists
    ├── programs/    # Program configs
    └── services/    # User services
```

### Separation of Concerns

- **System-level**: `modules/common/` and `modules/darwin/`
- **User-level**: `modules/home-manager/`
- **Host-specific**: `hosts/cpwr-mba2/`
- **Custom packages**: Managed in cffnpwr-nixpkgs repository
- **Secrets**: `secrets/` for encrypted data

## Flake Architecture

### Flake Structure with flake-parts

- **Multi-system support**: `aarch64-darwin`, `x86_64-darwin`, `x86_64-linux`, `aarch64-linux`
- **Overlay system**: Integrates cffnpwr-nixpkgs custom packages via overlays
- **Per-system configuration**: Development shell and formatter defined per-system
- **Unified Home Manager**: Home Manager integrated as Darwin module

### Best Practices

- Use `flake-parts` for modular organization
- Pin all inputs with `flake.lock`
- Use `follows` to minimize duplicate dependencies
- Keep custom packages in separate repository
- Use overlays for custom package integration
