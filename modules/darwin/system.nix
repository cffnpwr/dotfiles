{ config, ... }:
let
  homeDir = config.users.users.${config.username}.home;
  homeManagerAppsDir = "${homeDir}/Applications/Home Manager Apps";
in
{
  system = {
    # The primaryUser property is required for macOS system defaults configuration
    # This property can be removed once the transition to the `users.users.*` namespace is complete.
    # Ref: https://github.com/nix-darwin/nix-darwin/issues/1462\
    primaryUser = config.username;

    # macOS system defaults
    defaults = {
      # Control Center settings
      controlcenter = {
        BatteryShowPercentage = true; # Show battery percentage in menu bar
      };

      # Dock settings
      dock = {
        autohide = true; # Automatically hide and show the Dock
        expose-group-apps = true; # Group windows by application in Mission Control
        mineffect = "scale"; # Minimize effect: scale
        orientation = "bottom"; # Dock position: bottom
        show-recents = false; # Disable recently used apps in Dock

        # Hot corners - disable all corners
        wvous-bl-corner = 1; # Bottom-left:  Disabled
        wvous-br-corner = 1; # Bottom-right: Disabled
        wvous-tl-corner = 1; # Top-left:     Disabled
        wvous-tr-corner = 1; # Top-right:    Disabled

        # Persistent apps in Dock
        persistent-apps = [
          { app = "${homeManagerAppsDir}/Zen Browser (Beta).app"; }
          { app = "${homeManagerAppsDir}/Ghostty.app"; }
          { app = "/System/Applications/System Settings.app"; }
        ];
        persistent-others = [
          {
            folder = {
              path = "${homeDir}/Downloads";
              showas = "grid";
            };
          }
        ];
      };

      # Finder settings
      finder = {
        _FXShowPosixPathInTitle = true; # Show full POSIX path in title bar
        AppleShowAllExtensions = true; # Show all file extensions
        AppleShowAllFiles = true; # Show hidden files
        CreateDesktop = false; # Do not show desktop icons
        FXEnableExtensionChangeWarning = false; # Disable warning when changing file extensions
        ShowExternalHardDrivesOnDesktop = false; # Do not show external drives on desktop
        ShowPathbar = true; # Show path bar
        ShowStatusBar = true; # Show status bar
      };

      # Menu bar clock settingss
      menuExtraClock = {
        ShowSeconds = true; # Show clock with seconds
      };

      # Global macOS settings
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        "com.apple.keyboard.fnState" = true; # Use F1, F2, etc. keys as standard function keys
      };

      # Trackpad settings
      trackpad = {
        Clicking = true; # Enable tap to click
        TrackpadThreeFingerVertSwipeGesture = 2; # 3-finger swipe: down for Mission Control, up for App Exposé
      };
    };
  };
}
