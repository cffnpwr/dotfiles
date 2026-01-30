{
  pkgs,
  config,
  lib,
  ...
}:
let
  username = config.username;
in
{
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "cffnpwr";
      description = "default username";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "cffnpwr@gmail.com";
      description = "default user email";
    };

    homeDirectory = lib.mkOption {
      type = lib.types.str;
      description = "User home directory";
    };
  };

  config = {
    users.users.${username} = {
      name = username;
      home = config.homeDirectory;
      shell = pkgs.zsh;
      createHome = true;
    };
  };
}
