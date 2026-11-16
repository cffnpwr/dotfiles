{
  flake.modules.darwin."0xproto-nerd-font" =
    { pkgs, ... }:
    {
      fonts.packages = [ pkgs.nerd-fonts._0xproto ];
    };

  flake.modules.homeManager."0xproto-nerd-font" =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      fonts.fontconfig.enable = true;
      home.packages = [ pkgs.nerd-fonts._0xproto ];
    };
}
