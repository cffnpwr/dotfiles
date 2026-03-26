{ pkgs, lib, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services = {
      azookey.enable = true;
    };
  };
}
