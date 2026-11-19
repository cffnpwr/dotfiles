{ inputs, ... }:
{
  flake.modules.darwin.homebrew =
    { config, lib, ... }:
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;
        user = config.system.primaryUser;
        mutableTaps = false;
        # homebrew.tapsのtap（<owner>/<repo>）を<owner>-homebrew-<repo>のflake inputから導入
        taps = lib.listToAttrs (
          map (
            tap:
            let
              repository = lib.replaceStrings [ "/" ] [ "/homebrew-" ] tap.name;
            in
            lib.nameValuePair repository inputs.${lib.replaceStrings [ "/" ] [ "-" ] repository}
          ) config.homebrew.taps
        );
      };

      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "uninstall";
          # masAppsの処理で失敗するため無効化
          autoUpdate = false;
          upgrade = false;
        };
        # 仮想環境ではApp StoreにサインインできないためmasAppsのインストールを省略
        extraConfig = ''
          if `/usr/sbin/sysctl -n kern.hv_vmm_present`.strip == "1"
            ENV["HOMEBREW_BUNDLE_MAS_SKIP"] = "${
              lib.concatMapStringsSep " " toString (lib.attrValues config.homebrew.masApps)
            }"
          end
        '';
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
