{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    settings = {
      # Font Configuration
      font-family = [
        "0xProto Nerd Font"
        "Koruri"
      ];
      font-family-bold = "0xProto Nerd Font";
      font-family-italic = "0xProto Nerd Font";
      font-family-bold-italic = "0xProto Nerd Font";
      font-size = 13;

      # Theme and Appearance
      theme = "tokyonight";
      background-opacity = 0.9;

      # Window Configuration
      window-width = 192;
      window-height = 64;

      # Shell Integration
      command = "/bin/zsh -l -c zellij attach wezterm --create";

      # macOS Specific
      macos-option-as-alt = "left";
    };
  };
}
