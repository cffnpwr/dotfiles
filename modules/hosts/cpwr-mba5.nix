{ inputs, config, ... }:
{
  flake.darwinConfigurations.cpwr-mba5 =
    let
      module = builtins.attrValues config.flake.modules.darwin;
    in
    inputs.nix-darwin.lib.darwinSystem {
      modules =
        let
          userCffnpwr = config.dotfiles.users.cffnpwr;
        in
        module
        ++ [
          inputs.home-manager.darwinModules.home-manager
          {
            nixpkgs.hostPlatform = "aarch64-darwin";

            users.knownUsers = [ userCffnpwr.username ];
            users.users.${userCffnpwr.username}.uid = 501;

            home-manager.users.${userCffnpwr.username}.imports =
              builtins.attrValues config.flake.modules.homeManager;
          }
        ];
    };
}
