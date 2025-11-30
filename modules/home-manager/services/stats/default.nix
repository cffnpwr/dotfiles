{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.stats;
in
{
  options.services.stats = {
    enable = lib.mkEnableOption "Stats system monitor";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.stats = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.stats}/Applications/Stats.app/Contents/MacOS/Stats"
        ];
        RunAtLoad = true;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Interactive";
      };
    };
  };
}
