{
  flake.modules.homeManager.claude =
    { lib, pkgs, ... }:
    {
      home.packages = lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) [
        pkgs.llm-agents.claude-desktop
      ];
    };
}
