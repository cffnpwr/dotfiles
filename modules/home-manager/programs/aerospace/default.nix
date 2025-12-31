{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.aerospace = {
      enable = true;

      launchd = {
        enable = true;
      };

      settings = {
        after-startup-command = [ ];
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        accordion-padding = 30;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
        automatically-unhide-macos-hidden-apps = false;

        key-mapping = {
          preset = "qwerty";
        };

        gaps = {
          inner = {
            horizontal = 10;
            vertical = 10;
          };
          outer = {
            left = 10;
            bottom = 10;
            top = 10;
            right = 10;
          };
        };

        mode = {
          main = {
            binding = {
              # layout switching
              alt-slash = "layout tiles horizontal vertical";
              alt-comma = "layout accordion horizontal vertical";

              # focus
              alt-h = "focus left";
              alt-j = "focus down";
              alt-k = "focus up";
              alt-l = "focus right";

              # move
              alt-shift-h = "move left";
              alt-shift-j = "move down";
              alt-shift-k = "move up";
              alt-shift-l = "move right";

              # resize
              alt-minus = "resize smart -50";
              alt-equal = "resize smart +50";

              # workspaces
              alt-1 = "workspace 1";
              alt-2 = "workspace 2";
              alt-3 = "workspace 3";
              alt-4 = "workspace 4";
              alt-5 = "workspace 5";
              alt-6 = "workspace 6";
              alt-7 = "workspace 7";
              alt-8 = "workspace 8";
              alt-9 = "workspace 9";
              alt-a = "workspace A";
              alt-b = "workspace B";
              alt-c = "workspace C";
              alt-d = "workspace D";
              alt-e = "workspace E";
              alt-f = "workspace F";
              alt-g = "workspace G";
              alt-i = "workspace I";
              alt-m = "workspace M";
              alt-n = "workspace N";
              alt-o = "workspace O";
              alt-p = "workspace P";
              alt-q = "workspace Q";
              alt-r = "workspace R";
              alt-s = "workspace S";
              alt-t = "workspace T";
              alt-u = "workspace U";
              alt-v = "workspace V";
              alt-w = "workspace W";
              alt-x = "workspace X";
              alt-y = "workspace Y";
              alt-z = "workspace Z";

              # move to workspace
              alt-shift-1 = "move-node-to-workspace 1";
              alt-shift-2 = "move-node-to-workspace 2";
              alt-shift-3 = "move-node-to-workspace 3";
              alt-shift-4 = "move-node-to-workspace 4";
              alt-shift-5 = "move-node-to-workspace 5";
              alt-shift-6 = "move-node-to-workspace 6";
              alt-shift-7 = "move-node-to-workspace 7";
              alt-shift-8 = "move-node-to-workspace 8";
              alt-shift-9 = "move-node-to-workspace 9";
              alt-shift-a = "move-node-to-workspace A";
              alt-shift-b = "move-node-to-workspace B";
              alt-shift-c = "move-node-to-workspace C";
              alt-shift-d = "move-node-to-workspace D";
              alt-shift-e = "move-node-to-workspace E";
              alt-shift-f = "move-node-to-workspace F";
              alt-shift-g = "move-node-to-workspace G";
              alt-shift-i = "move-node-to-workspace I";
              alt-shift-m = "move-node-to-workspace M";
              alt-shift-n = "move-node-to-workspace N";
              alt-shift-o = "move-node-to-workspace O";
              alt-shift-p = "move-node-to-workspace P";
              alt-shift-q = "move-node-to-workspace Q";
              alt-shift-r = "move-node-to-workspace R";
              alt-shift-s = "move-node-to-workspace S";
              alt-shift-t = "move-node-to-workspace T";
              alt-shift-u = "move-node-to-workspace U";
              alt-shift-v = "move-node-to-workspace V";
              alt-shift-w = "move-node-to-workspace W";
              alt-shift-x = "move-node-to-workspace X";
              alt-shift-y = "move-node-to-workspace Y";
              alt-shift-z = "move-node-to-workspace Z";

              # workspace navigation
              alt-tab = "workspace-back-and-forth";
              alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

              # change mode
              alt-shift-semicolon = "mode service";
            };
          };

          service = {
            binding = {
              # reload config
              esc = [
                "reload-config"
                "mode main"
              ];

              # reset layout
              r = [
                "flatten-workspace-tree"
                "mode main"
              ];

              # floating tile
              f = [
                "layout floating tiling"
                "mode main"
              ];

              # close all windows but current
              backspace = [
                "close-all-windows-but-current"
                "mode main"
              ];

              alt-shift-h = [
                "join-with left"
                "mode main"
              ];
              alt-shift-j = [
                "join-with down"
                "mode main"
              ];
              alt-shift-k = [
                "join-with up"
                "mode main"
              ];
              alt-shift-l = [
                "join-with right"
                "mode main"
              ];

              down = "volume down";
              up = "volume up";
              shift-down = [
                "volume set 0"
                "mode main"
              ];
            };
          };
        };

        workspace-to-monitor-force-assignment = {
          "1" = [
            "mi monitor"
            "MSI MP251"
          ];
          "2" = [
            "mi monitor"
            "MSI MP251"
          ];
          "3" = [
            "mi monitor"
            "MSI MP251"
          ];
          "4" = [
            "mi monitor"
            "MSI MP251"
          ];
          "5" = [
            "mi monitor"
            "MSI MP251"
          ];
          "6" = [
            "mi monitor"
            "MSI MP251"
          ];
          "7" = [
            "mi monitor"
            "MSI MP251"
          ];
          "8" = [
            "mi monitor"
            "MSI MP251"
          ];
          "9" = [
            "mi monitor"
            "MSI MP251"
          ];
          "0" = [
            "mi monitor"
            "MSI MP251"
          ];
        };

        on-window-detected = [
          {
            "if" = {
              app-id = "app.zen-browser.zen";
            };
            run = "move-node-to-workspace B";
          }
          {
            "if" = {
              app-id = "md.obsidian";
            };
            run = "move-node-to-workspace O";
          }
          {
            "if" = {
              app-id = "com.hnc.Discord";
            };
            run = "move-node-to-workspace D";
          }
          {
            "if" = {
              app-id = "com.microsoft.teams2";
            };
            run = "move-node-to-workspace M";
          }
          {
            "if" = {
              app-id = "com.spotify.client";
            };
            run = "move-node-to-workspace S";
          }
          {
            "if" = {
              app-id = "com.mitchellh.ghostty";
            };
            run = "move-node-to-workspace T";
          }
          {
            "if" = {
              app-id = "com.apple.finder";
            };
            run = "layout floating";
          }
          {
            "if" = {
              app-id = "com.bitwarden.desktop";
            };
            run = "layout floating";
          }
          {
            "if" = {
              app-id = "dev.mandre.rquickshare";
            };
            run = "layout floating";
          }
        ];
      };
    };
  };
}
