{
  # nixpkgsの更新が止まっているため
  flake.modules.darwin.karabiner-elements = {
    homebrew.casks = [ "karabiner-elements" ];
  };

  flake.modules.homeManager.karabiner-elements =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      settings = import ./_settings.nix;
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      # アプリがkarabiner.jsonを書き換えるため、シンボリックリンクにせず宣言値で上書き
      home.activation.karabinerSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] (
        lib.hm.generators.mkImpureConfigMerger {
          inherit pkgs;
          format = "json";
          empty = "{}";
          jqOperation = "$static";
          path = "${config.xdg.configHome}/karabiner/karabiner.json";
          staticSettings = (pkgs.formats.json { }).generate "karabiner.json" settings;
        }
      );
    };
}
