{ ... }:
{
  programs.zed-editor = {
    enable = true;
    mutableUserSettings = false;

    extensions = [
      # Theme
      "tokyo-night"
      # Icons
      "vscode-icons"
      # Opencode
      "opencode"
      # Nix
      "nix"
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
    };
  };
}
