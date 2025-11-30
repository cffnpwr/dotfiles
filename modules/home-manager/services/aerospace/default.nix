{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.aerospace;
in
{
  options.services.aerospace = {
    enable = lib.mkEnableOption "AeroSpace window manager";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.aerospace = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
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
