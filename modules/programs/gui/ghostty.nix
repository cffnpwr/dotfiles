{
  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        enableZshIntegration = true;

        settings = {
          adjust-cell-height = "-23%";
          background-opacity = 0.9;
          command = ''/bin/zsh -l -c "herdr-attach default"'';
          font-family = [
            "0xProto Nerd Font Mono"
            "Koruri"
          ];
          font-family-bold = "0xProto Nerd Font Mono";
          font-family-bold-italic = "0xProto Nerd Font Mono";
          font-family-italic = "0xProto Nerd Font Mono";
          font-size = 13;
          keybind = [ "cmd+enter=text:\\x1b[13;9u" ];
          macos-option-as-alt = "left";
          theme = "tokyonight";
          window-height = 64;
          window-width = 192;
        };
      };
    };
}
