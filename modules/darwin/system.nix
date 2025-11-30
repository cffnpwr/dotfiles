{ config, ... }:
{
  # zsh enable
  programs.zsh.enable = true;

  # Primary user設定
  system.primaryUser = config.username;

  # PATH設定
  environment.systemPath = [
    "/Library/TeX/texbin"
  ];

  # macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };
}
