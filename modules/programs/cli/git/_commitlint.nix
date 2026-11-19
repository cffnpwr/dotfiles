{ users }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = users.${config.home.username};
  sharedConfig = pkgs.fetchzip {
    url = "https://registry.npmjs.org/@cffnpwr/commitlint-config/-/commitlint-config-2.0.0.tgz";
    hash = "sha256-kIqXjG/9PMarZUajtSbI9S0ZFaXpR8NRI/jnejmzEq4=";
  };
  globalConfig = ''
    export { default } from "${sharedConfig}/dist/index.js";
  '';
in
{
  # commitlintはリポジトリのルートから$HOMEまで設定ファイルを探し、見つからない場合にユーザーの設定ディレクトリの設定ファイルを読み込む
  # 設定ディレクトリはcosmiconfigが使うenv-pathsが決め、macOSでは~/Library/Preferences/commitlint、Linuxでは$XDG_CONFIG_HOME/commitlintになる
  home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    "Library/Preferences/commitlint/config.mjs".text = globalConfig;
  };
  xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "commitlint/config.mjs".text = globalConfig;
  };

  programs.git.includes = [
    {
      # 他者のリポジトリの規約と衝突しないよう、自分のリポジトリだけでcommit-msgのフックを実行
      condition = "gitdir:${config.programs.git.settings.ghq.root}/github.com/${user.github.username}/";
      contents.hook.commitlint = {
        event = "commit-msg";
        command = "${lib.getExe pkgs.commitlint} --edit";
      };
    }
  ];
}
