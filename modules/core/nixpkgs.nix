{ inputs, ... }:
{
  flake.modules.darwin.nixpkgs = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];
  };
}
