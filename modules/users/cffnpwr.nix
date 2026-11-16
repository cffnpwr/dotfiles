{
  config,
  ...
}:
{
  dotfiles.users.cffnpwr = {
    username = "cffnpwr";

    git = {
      username = "cffnpwr";
      email = "cffnpwr@cffnpwr.dev";
    };

    github.username = "cffnpwr";
  };

  flake.modules.darwin.cffnpwr =
    { ... }:
    let
      userConfig = config.dotfiles.users.cffnpwr;
    in
    {
      users.users.${userConfig.username} = {
        description = userConfig.username;
        name = userConfig.username;
        home = "/Users/${userConfig.username}";
      };

      system.primaryUser = userConfig.username;
    };
}
