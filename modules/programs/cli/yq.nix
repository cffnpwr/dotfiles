{
  flake.modules.homeManager.yq =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.yq-go ];
    };
}
