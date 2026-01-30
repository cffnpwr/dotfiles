{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.azookey;
in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.azookey = {
      enable = false;
      # enable = true;

      settings = {
        punctuationStyle = 1;
        keyboardLayout = "qwerty";
        inputStyle = "custom";
        typeBackSlash = true;
        typeHalfSpace = true;
      };

      customInputTable = cfg.presets.presetAzik ++ [
        {
          input = "ji";
          output = "じ";
        }
      ];
    };
  };
}
