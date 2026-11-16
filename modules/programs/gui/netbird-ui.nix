{
  # nixpkgsのnetbird-uiはmacOSでbrokenのwebkitgtkに依存するためhomebrewから導入
  flake.modules.darwin.netbird-ui = {
    homebrew = {
      taps = [
        {
          name = "netbirdio/tap";
          trusted = true;
        }
      ];
      casks = [ "netbirdio/tap/netbird-ui" ];
    };
  };

  flake.modules.homeManager.netbird-ui =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.netbird-ui ];

      launchd.agents.netbird-ui = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        enable = true;
        config = {
          Label = "io.netbird.client";
          ProgramArguments = [ "/Applications/Netbird UI.app/netbird-ui" ];
          RunAtLoad = true;
          KeepAlive = false;
        };
      };
    };
}
