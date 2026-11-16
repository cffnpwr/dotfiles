{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.treefmt.withConfig {
        runtimeInputs = [
          pkgs.nixfmt
          pkgs.shfmt
          pkgs.yamlfmt
        ];
        configFile = ../../treefmt.toml;
      };
    };
}
