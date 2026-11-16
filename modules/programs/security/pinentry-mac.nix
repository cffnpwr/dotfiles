{
  flake.modules.homeManager.pinentry-mac =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.pinentry_mac ];
    };
}
