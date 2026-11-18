{ inputs, ... }:
{
  flake.modules.homeManager.mise =
    { pkgs, ... }:
    {
      programs.mise = {
        enable = true;
        package = inputs.mise.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
          # GitHub ActionsのmacOSのrunnerでテストのプロセスがSIGSEGVで異常終了するため、miseのテストを省略
          doCheck = false;

          # jdx/miseのdefault.nixはaws-lc・zstdをbuildInputsに含めないため、システムのライブラリを使用せずにビルド
          dontCargoUseSystemLibs = true;

          # jdx/miseのdefault.nixは補完スクリプトをインストールしないため、ソースに含まれるzshの補完スクリプトをインストール
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.installShellFiles ];
          postInstall = (old.postInstall or "") + ''
            installShellCompletion --zsh ./completions/_mise
          '';
        });
        enableZshIntegration = true;
        globalConfig.settings = {
          experimental = true;
          not_found_auto_install = false;
        };
      };

      # 非対話シェル用（対話シェルではmise activateがこのディレクトリをPATHから外す）
      home.sessionPath = [ "$HOME/.local/share/mise/shims" ];
    };
}
