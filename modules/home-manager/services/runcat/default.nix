{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.runcat;
in
{
  options.services.runcat = {
    enable = lib.mkEnableOption "RunCat activity monitor";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.runcat = {
      enable = true;
      config = {
        ProgramArguments = [
          # Runcat is installed via mas
          "/Applications/RunCat.app/Contents/MacOS/RunCat"
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
