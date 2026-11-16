{ inputs, ... }:
{
  flake.modules.darwin.determinate-nix =
    { config, ... }:
    {
      imports = [ inputs.determinate.darwinModules.default ];

      determinateNix = {
        enable = true;
        # flake.nixのnixConfig（llm-agents.nixのバイナリキャッシュ）を使うため
        customSettings.trusted-users = [
          "root"
          config.system.primaryUser
        ];
      };
    };
}
