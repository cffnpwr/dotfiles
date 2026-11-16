{
  flake.modules.homeManager.aerospace =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      programs.aerospace = {
        enable = true;
        launchd = {
          enable = true;
          keepAlive = false;
        };
        settings = import ./_settings.nix;
      };
    };
}
