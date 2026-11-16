{
  flake.modules.darwin.koruri =
    { pkgs, ... }:
    {
      fonts.packages = [ pkgs.koruri ];
    };

  flake.modules.homeManager.koruri =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      fonts.fontconfig.enable = true;
      home.packages = [ pkgs.koruri ];
    };
}
