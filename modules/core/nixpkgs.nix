{ inputs, ... }:
{
  flake.modules.darwin.nixpkgs = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      # numtideのバイナリキャッシュを使うため、llm-agents.nixのnixpkgsでビルドしたpackagesを使用
      (_final: prev: {
        llm-agents = inputs.llm-agents.packages.${prev.stdenv.hostPlatform.system};
      })
      # go.modのバージョンのGoを選択するgo-bin.fromGoModを使用
      inputs.go-overlay.overlays.default
    ];
  };
}
