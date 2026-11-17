{ inputs, ... }:
{
  flake.modules.darwin.homebrew =
    { config, ... }:
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;
        user = config.system.primaryUser;
        # 既存のHomebrewをnix-homebrewの管理へ移行（導入済みのパッケージは残す）
        autoMigrate = true;
        # brew bundleがtapを追加するため
        mutableTaps = true;
      };

      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "uninstall";
          # masAppsの処理で失敗するため無効化
          autoUpdate = false;
          upgrade = true;
        };
      };
    };

  flake.modules.homeManager.homebrew =
    { lib, pkgs, ... }:
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      programs.zsh.profileExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # brewのサブプロセス内ではbrew shellenvがfpathへ追加しないため
        fpath=("''${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" $fpath)
      '';
    };
}
