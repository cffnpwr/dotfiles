{
  flake.modules.homeManager.opencode =
    { pkgs, ... }:
    {
      programs.opencode = {
        enable = true;
        # opencode2は実行ファイルをopencode2という名前で配置するため、opencodeでも起動できるようにする
        package = pkgs.llm-agents.opencode2.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            ln -s $out/bin/opencode2 $out/bin/opencode
          '';
        });
        settings = {
          model = "google/gemini-3.1-pro-preview";
        };
      };
    };
}
