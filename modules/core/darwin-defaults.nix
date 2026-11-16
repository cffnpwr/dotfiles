{
  flake.modules.darwin.darwin-defaults =
    { config, lib, ... }:
    let
      # nix-darwinはDock以外を再起動しないため、宣言値の変更時に再起動するプロセス
      restartTargets = [
        "Finder"
        "ControlCenter"
        "SystemUIServer"
      ];
      defaultsHash = builtins.hashString "sha256" config.system.activationScripts.userDefaults.text;
      stampFile = "/var/db/dotfiles/defaults.sha256";
      inherit (config.users.users.${config.system.primaryUser}) home;
      # targets.darwin.copyAppsによるアプリの配置先
      hmApps = "${home}/Applications/Home Manager Apps";
    in
    {
      system.activationScripts.postActivation.text = lib.mkAfter ''
        if [ "$(cat ${stampFile} 2>/dev/null)" != ${lib.escapeShellArg defaultsHash} ]; then
          echo >&2 "restarting ${lib.concatStringsSep " " restartTargets}..."
          ${lib.concatMapStringsSep "\n" (
            t: "killall -qu ${lib.escapeShellArg config.system.primaryUser} ${t} || true"
          ) restartTargets}
          mkdir -p ${dirOf stampFile}
          printf '%s' ${lib.escapeShellArg defaultsHash} > ${stampFile}
        fi
      '';

      system.defaults = {
        controlcenter.BatteryShowPercentage = true;

        dock = {
          autohide = true;
          expose-group-apps = true;
          mineffect = "scale";
          orientation = "bottom";
          show-recents = false;

          # ホットコーナーの値1は無効
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;

          persistent-apps = [
            { app = "${hmApps}/Zen Browser (Beta).app"; }
            { app = "${hmApps}/Ghostty.app"; }
            { app = "/System/Applications/System Settings.app"; }
          ];
          persistent-others = [
            {
              folder = {
                path = "${home}/Downloads";
                showas = "grid";
              };
            }
          ];
        };

        finder = {
          _FXShowPosixPathInTitle = true;
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          CreateDesktop = false;
          FXEnableExtensionChangeWarning = false;
          ShowExternalHardDrivesOnDesktop = false;
          ShowPathbar = true;
          ShowStatusBar = true;
        };

        menuExtraClock.ShowSeconds = true;

        NSGlobalDomain = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          "com.apple.keyboard.fnState" = true;
        };

        trackpad = {
          Clicking = true;
          # 2は上へのスワイプでMission Control・下へのスワイプでApp Exposé
          TrackpadThreeFingerVertSwipeGesture = 2;
        };
      };
    };

  # currentHostの設定はユーザー単位のため、home-managerで書き込む
  flake.modules.homeManager.darwin-defaults =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      targets.darwin.currentHostDefaults."com.apple.Spotlight".MenuItemHidden = 1;
    };
}
