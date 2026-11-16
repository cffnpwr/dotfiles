{
  flake.modules.homeManager.iproute2mac =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.iproute2mac ];
    };
}
