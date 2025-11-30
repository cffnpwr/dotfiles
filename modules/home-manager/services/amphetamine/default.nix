{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.amphetamine;
in
{
  options.services.amphetamine = {
    enable = lib.mkEnableOption "Amphetamine keep-awake utility";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.amphetamine = {
      enable = true;
      config = {
        ProgramArguments = [
          # Amphetamine is installed via mas
          "/Applications/Amphetamine.app/Contents/MacOS/Amphetamine"
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
