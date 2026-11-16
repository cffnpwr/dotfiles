{ lib, ... }:
{
  options.dotfiles.users = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          username = lib.mkOption { type = lib.types.str; };
          homedir = {
            darwin = lib.mkOption { type = lib.types.str; };
            linux = lib.mkOption { type = lib.types.str; };
          };
          git = {
            username = lib.mkOption { type = lib.types.str; };
            email = lib.mkOption { type = lib.types.str; };
          };
          github.username = lib.mkOption { type = lib.types.str; };
        };
      }
    );
    default = { };
  };
}
