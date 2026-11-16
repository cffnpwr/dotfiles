flake:
let
  # NOTE: ホストのシステムでビルドできるGitHub-hosted runner
  runners = {
    aarch64-darwin = "macos-26";
    x86_64-linux = "ubuntu-26.04";
    aarch64-linux = "ubuntu-26.04-arm";
  };

  listHosts =
    {
      output,
      buildAttr,
      systemOf,
    }:
    map (
      name:
      let
        system = systemOf flake.${output}.${name};
      in
      {
        name = "${output}.${name}";
        attr = "${output}.${name}${buildAttr}";
        runner = runners.${system};
      }
    ) (builtins.attrNames (flake.${output} or { }));
in
listHosts {
  output = "darwinConfigurations";
  buildAttr = ".system";
  systemOf = host: host.config.nixpkgs.hostPlatform.system;
}
++ listHosts {
  output = "nixosConfigurations";
  buildAttr = ".config.system.build.toplevel";
  systemOf = host: host.config.nixpkgs.hostPlatform.system;
}
++ listHosts {
  output = "systemConfigs";
  buildAttr = "";
  systemOf = host: host.system;
}
