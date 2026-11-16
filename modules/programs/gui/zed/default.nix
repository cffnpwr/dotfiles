{
  flake.modules.homeManager.zed =
    { lib, pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        userSettings = import ./_settings.nix { inherit lib pkgs; };
        userKeymaps = [
          {
            bindings = {
              cmd-enter = [
                "terminal::SendText"
                (builtins.fromJSON ''"\u001b[13;9u"'')
              ];
            };
            context = "Terminal";
          }
        ];
      };
    };
}
