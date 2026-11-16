{
  # netbird-uiが依存するためmacOSではnetbird-uiと同じtapから導入
  flake.modules.darwin.netbird = {
    homebrew = {
      taps = [
        {
          name = "netbirdio/tap";
          trusted = true;
        }
      ];
      brews = [ "netbirdio/tap/netbird" ];
    };
  };

  flake.modules.homeManager.netbird =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.netbird ];
    };
}
