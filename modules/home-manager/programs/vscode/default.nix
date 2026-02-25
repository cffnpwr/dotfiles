{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;

    profiles.default = {
      userSettings = {

        # Font settings
        "editor.fontFamily" = "'0xProto Nerd Font Mono', monospace";
        "editor.fontSize" = 12;
        "editor.fontLigatures" = true;

        # Editor settings
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = true;
        "editor.renderWhitespace" = "boundary";
        "editor.smoothScrolling" = true;

        # File settings
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;

        # Workbench settings
        "workbench.colorTheme" = "Tokyo Night";
        "workbench.startupEditor" = "none";
        "workbench.iconTheme" = "vscode-icons";

        # Terminal settings
        "terminal.integrated.fontFamily" = "'0xProto Nerd Font Mono', monospace";
        "terminal.integrated.fontSize" = 12;
        "terminal.integrated.suggest.enabled" = false;

        # Git settings
        "git.path" = pkgs.git.outPath;

        # Github Copilot settings
        "github.copilot.nextEditSuggestions.enabled" = true;

        # File nesting
        "explorer.fileNesting.enabled" = true;
        "explorer.fileNesting.patterns" = {
          "flake.nix" = "flake.lock";
          "*.nix" = "\${capture}.test.nix";
          "AGENTS.md" = "CLAUDE.md";
        };

        # Security settings
        "security.workspace.trust.untrustedFiles" = "open";

        # JSON schema settings
        # Allow downloading JSON schemas from trusted domains
        "json.schemaDownload.trustedDomains" = {
          "https://schemastore.azurewebsites.net/" = true;
          "https://raw.githubusercontent.com/" = true;
          "https://www.schemastore.org/" = true;
          "https://json.schemastore.org/" = true;
          "https://json-schema.org/" = true;
          "https://docs.renovatebot.com" = true;
        };
      };

      extensions = with pkgs.nix-vscode-extensions.vscode-marketplace-release; [
        # Theme
        enkia.tokyo-night

        # Icons
        vscode-icons-team.vscode-icons

        # Global extensions
        # opencode
        sst-dev.opencode
        # Path Intellisense
        christian-kohler.path-intellisense
        # EditorConfig
        editorconfig.editorconfig
        # Indent rainbow
        oderwat.indent-rainbow
        # Conventional Commits
        vivaxy.vscode-conventional-commits
      ];
    };
  };
}
