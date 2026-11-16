{
  flake.modules.homeManager.defaultbrowser =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.defaultbrowser ];
    };
}
