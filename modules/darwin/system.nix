{ config, pkgs, ... }:
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

    activationScripts = {
      # Set Zen Browser as the default browser
      # "zen" is derived from the last component of its bundle ID (app.zen-browser.zen)
      # Use launchctl asuser to run in the user's session context (required for LaunchServices API)
      defaultBrowser.text = ''
        launchctl asuser "$(id -u -- ${config.username})" sudo --user=${config.username} -- ${pkgs.defaultbrowser}/bin/defaultbrowser zen
      '';

      # Hide Spotlight from menu bar
      # CustomUserPreferences with ~/... path expands to /var/root when run as root,
      # so use defaults -currentHost write via launchctl asuser instead
      spotlightMenuItemHidden.text = ''
        launchctl asuser "$(id -u -- ${config.username})" sudo --user=${config.username} -- defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
      '';
    };

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
