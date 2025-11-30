{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.alt-tab;
in
{
  options.services.alt-tab = {
    enable = lib.mkEnableOption "AltTab window switcher";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.alt-tab = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.alt-tab-macos}/Applications/AltTab.app/Contents/MacOS/AltTab"
        ];
        RunAtLoad = true;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Interactive";
        LimitLoadToSessionType = "Aqua";
      };
    };
  };
}
