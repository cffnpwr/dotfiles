{
  flake.modules.homeManager.ghq =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [ pkgs.ghq ];

      programs.git.settings.ghq.root = "~/git";
    };
}
