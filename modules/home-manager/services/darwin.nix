{ pkgs, lib, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services = {
      alt-tab.enable = true;
      amphetamine.enable = true;
      bitwarden.enable = true;
      raycast.enable = true;
      runcat.enable = true;
      scroll-reverser.enable = true;
      stats.enable = true;
    };
  };
}
