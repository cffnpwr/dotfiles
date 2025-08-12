# Code Style and Conventions

## EditorConfig Standards
- **Indentation**: 2 spaces for all files
- **Go Exception**: Tab indentation for Go files
- **Line Endings**: LF (Unix-style)
- **Character Encoding**: UTF-8
- **Trailing Whitespace**: Trim automatically
- **Final Newline**: Always insert

## File Naming Conventions
- `dot_*`: Files that become `.` prefixed in home directory
- `private_*`: Files containing sensitive information (SSH keys, credentials)
- `encrypted_*`: Files that are actually encrypted with age
- `*.tmpl`: Template files with variable expansion

## Markdown and Documentation
- **Linting**: markdownlint-cli with 120 character line length limit
- **Japanese Text**: textlint with Japanese technical writing presets
  - ja-technical-writing preset
  - ai-writing preset  
  - ja-spacing preset
  - Comments filtering enabled

## Git Conventions
- Use Conventional Commits format with Gitmoji
- Japanese commit messages in noun form (体言止め)
- Format: `<type> <emoji>: <Japanese message>`
- Examples: `feat ✨: Wezterm設定の追加`, `fix 🐛: Zsh補完設定の修正`

## Configuration Management
- All configurations managed through chezmoi
- Template files support dynamic OS and environment detection
- Sensitive files encrypted with age
- Clear separation between public and private configurations