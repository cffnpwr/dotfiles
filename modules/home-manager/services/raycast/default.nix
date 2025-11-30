{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.raycast;
in
{
  options.services.raycast = {
    enable = lib.mkEnableOption "Raycast launcher";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.raycast = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast"
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
