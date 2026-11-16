{
  flake.modules.homeManager.docker =
    { pkgs, ... }:
    {
      # CLIのみを導入
      home.packages = [ pkgs.docker-client ];
    };
}
