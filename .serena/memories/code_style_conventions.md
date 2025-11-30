# Code Style and Conventions

## Nix Code Style

### General Formatting

- **Indentation**: 2 spaces for all Nix files
- **Line Length**: Prefer 80 characters, max 120
- **String Literals**: Use double quotes `"string"` for simple strings
- **Multi-line Strings**: Use `''` for multi-line strings (heredoc)
- **Lists**: Always use trailing commas in multi-line lists
- **Attribute Sets**: Use trailing semicolons

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

### chezmoi Files (Legacy)

- `dot_*`: Files that become `.` prefixed in home directory
- `private_*`: Files containing sensitive information (SSH keys, credentials)
- `encrypted_*`: Files that are actually encrypted with age
- `*.tmpl`: Template files with variable expansion

## EditorConfig Standards

- **Indentation**: 2 spaces for most files
- **Nix Exception**: 2 spaces (not tabs)
- **Go Exception**: Tab indentation for Go files
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
config 🔧: Claude Code権限設定の調整
```

## Secret Management

### agenix Secrets

- Store secrets in `secrets/` directory
- Use `.age` extension for encrypted files
- Define secrets in `secrets/secrets.nix`
- Never commit unencrypted secrets

### Sensitive Information Handling

- Use `private_` prefix for sensitive but unencrypted files (chezmoi)
- Use `encrypted_` prefix for encrypted files (chezmoi)
- Use agenix for Nix-managed secrets
- Never log or display secret contents

## Configuration Management

### Nix Configuration (Primary)

- All system and package configuration through Nix
- Modular structure in `modules/` directory
- Host-specific configuration in `hosts/` directory
- Secrets managed with agenix
- Clear separation between common, Darwin, and Home Manager configs

### chezmoi Configuration (Legacy)

- Traditional dotfiles management
- Gradually migrating to Nix
- Template files support dynamic OS detection
- Clear separation between public and private configurations

## Code Organization

### Module Organization

```text
modules/
├── common/          # Cross-platform configuration
│   ├── default.nix  # Module loader
│   ├── packages.nix # Common packages
│   └── ...
├── darwin/          # macOS-specific
│   ├── default.nix  # Module loader
│   ├── system.nix   # System settings
│   └── ...
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
- **Packages**: `pkgs/` for custom derivations
- **Secrets**: `secrets/` for encrypted data
