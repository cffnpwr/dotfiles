{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.bitwarden;
in
{
  options.services.bitwarden = {
    enable = lib.mkEnableOption "Bitwarden password manager";
  };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.isDarwin) {
    launchd.agents.bitwarden = {
      enable = true;
      config = {
        ProgramArguments = [
          # Bitwarden is installed via mas
          "/Applications/Bitwarden.app/Contents/MacOS/Bitwarden"
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
