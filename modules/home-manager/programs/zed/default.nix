{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;
    mutableUserKeymaps = false;

    extensions = [
      # Theme
      "tokyo-night"
      # Icons
      "vscode-icons"
      # Opencode
      "opencode"
      # Nix
      "nix"
      # Markdown
      "markdownlint"
    ];

    userSettings = {
      # Auto update is disabled because Zed is managed by Nix
      auto_update = false;

      # Theme
      theme = {
        mode = "dark";
        dark = "Tokyo Night Moon";
        light = "Tokyo Night Light";
      };

      # Icon theme
      icon_theme = {
        mode = "dark";
        dark = "VSCode Icons for Zed (Dark)";
        light = "VSCode Icons for Zed (Light)";
      };

      # Font settings
      buffer_font_family = "0xProto Nerd Font Mono";
      buffer_font_fallbacks = [ "Koruri" ];
      buffer_font_size = 13;
      buffer_font_features = {
        calt = true;
        liga = true;
      };
      ui_font_family = "0xProto Nerd Font Mono";
      ui_font_fallbacks = [ "Koruri" ];
      ui_font_size = 15;
      ui_font_features = {
        calt = true;
        liga = true;
      };

      # Editor settings
      cursor_blink = true;
      format_on_save = "on";
      show_whitespaces = "boundary";
      remove_trailing_whitespace_on_save = true;
      ensure_final_newline_on_save = true;
      restore_on_startup = "last_session";

      # Panel dock positions
      project_panel = {
        dock = "left";
      };
      outline_panel = {
        dock = "left";
      };
      collaboration_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };
      agent = {
        dock = "right";
      };

      # Minimap
      minimap = {
        show = "always";
      };

      # Indent guides (replaces indent-rainbow)
      indent_guides = {
        enabled = true;
        line_width = 1;
        active_line_width = 2;
        coloring = "indent_aware";
        background_coloring = "indent_aware";
      };

      # Git settings
      git = {
        inline_blame = {
          enabled = true;
        };
        git_gutter = "tracked_files";
      };

      # Terminal settings
      terminal = {
        font_family = "0xProto Nerd Font Mono";
        font_size = 13;
        font_features = {
          calt = true;
          liga = true;
        };
      };

      # Edit predictions
      edit_predictions = {
        provider = "copilot";
      };

      # Diagnostics
      diagnostics = {
        include_warnings = true;
        inline = {
          enabled = true;
        };
      };

      # Language-specific settings
      languages = {
        Markdown = {
          formatter = "none";
          format_on_save = "off";
        };
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };

      # LSP settings
      lsp = {
        nixd = {
          settings = {
            formatting = {
              command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
            };
          };
        };
        # Mirrors skills/markdown-standards/assets/.markdownlint-cli2.yaml
        markdownlint = {
          settings = {
            config = {
              default = true;
              MD013 = {
                tables = false;
              };
              MD024 = {
                siblings_only = true;
              };
              MD033 = {
                allowed_elements = [
                  "details"
                  "summary"
                ];
              };
            };
            ignores = [
              ".agents/**/*.md"
              "**/AGENTS.md"
              ".claude/**/*.md"
              "**/CLAUDE.md"
            ];
          };
        };
      };
    };

    userKeymaps = [
      {
        context = "Terminal";
        bindings = {
          # Send CSI u sequence for cmd+enter (super modifier)
          # Used by Claude Code / opencode to distinguish from plain enter
          "cmd-enter" = [
            "terminal::SendText"
            (builtins.fromJSON ''"\u001b[13;9u"'')
          ];
        };
      }
    ];
  };
}
