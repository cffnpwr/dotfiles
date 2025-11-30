{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.scroll-reverser;
in
{
  options.services.scroll-reverser = {
    enable = lib.mkEnableOption "Scroll Reverser";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.scroll-reverser = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.scroll-reverser}/Applications/Scroll Reverser.app/Contents/MacOS/Scroll Reverser"
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
