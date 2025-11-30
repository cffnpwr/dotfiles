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

    homeDirectory = lib.mkOption {
      type = lib.types.str;
      description = "User home directory";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "24.11";
      description = "Home Manager state version";
    };
  };

  config = {
    # システムレベルのユーザー設定
    users.users.${username} = {
      name = username;
      home = config.homeDirectory;
      shell = pkgs.zsh;
    };
  };
}
