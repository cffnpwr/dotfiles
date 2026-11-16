{ inputs, ... }:
{
  flake.modules.homeManager.mise =
    { pkgs, ... }:
    {
      programs.mise = {
        enable = true;
        # GitHub ActionsのmacOSのrunnerでテストのプロセスがSIGSEGVで異常終了するため、miseのテストを省略
        package = inputs.mise.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
          doCheck = false;
        };
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
