{ pkgs, lib, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services = {
      kmonad.enable = true;
      azookey.enable = true;
    };
  };
}
