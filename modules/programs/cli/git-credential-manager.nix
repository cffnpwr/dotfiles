{
  flake.modules.homeManager.git-credential-manager =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [
        pkgs.git-credential-manager
      ];
    };
}
