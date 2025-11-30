{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services = {
      aerospace.enable = true;
      alt-tab.enable = true;
      amphetamine.enable = true;
      bitwarden.enable = true;
      google-japanese-ime.enable = true;
      raycast.enable = true;
      runcat.enable = true;
      scroll-reverser.enable = true;
      stats.enable = true;
    };
  };
}
