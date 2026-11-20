{ config, ... }:
let
  users = config.dotfiles.users;
in
{
  flake.modules.homeManager.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      user = users.${config.home.username};
      sshDir = "${config.home.homeDirectory}/.ssh";
      pruneGoneBranches = pkgs.buildGoModule {
        name = "git-prune-gone-branches";
        src = ./prune-gone-branches;
        vendorHash = null;
        subPackages = [ "cmd/git-prune-gone-branches" ];
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
        postInstall = ''
          wrapProgram $out/bin/git-prune-gone-branches --prefix PATH : ${
            lib.makeBinPath [ config.programs.git.package ]
          }
        '';
        meta.mainProgram = "git-prune-gone-branches";
      };
    in
    {
      imports = [ (import ./_commitlint.nix { inherit users; }) ];

      programs.git = {
        enable = true;
        settings = {
          user = {
            name = user.git.username;
            inherit (user.git) email;
          };

          alias = {
            b = "branch";
            ci = "commit";
            st = "status";
            lg = "log --graph --date=iso-strict-local --format='%C(bold blue)%h%C(reset) %C(yellow)%ae%C(reset) %C(cyan)%cd%C(reset)%C(auto)%(decorate:prefix= ,suffix=,separator= ,tag=)%C(reset) %C(green)%G?%C(reset)%n%s'";
            lg-full = "log --graph --date=iso-strict-local --format='%C(bold blue)%h%C(reset) %C(yellow)%ae%C(reset) %C(cyan)%cd%C(reset)%C(auto)%(decorate:prefix= ,suffix=,separator= ,tag=)%C(reset)%nSignature: %G? %GS %GK%n%B'";
          };

          fetch.prune = true;
          # fetch.pruneはローカルブランチを削除しないため、上流が消えたローカルブランチをフックで削除
          hook.prune-gone-branches = {
            event = "reference-transaction";
            command = lib.getExe pruneGoneBranches;
          };
          init.defaultBranch = "main";
          url."git@github.com:".insteadOf = "https://github.com/";
        };
        signing = {
          format = "ssh";
          # macOSではSecretiveの鍵、それ以外ではFIDOの鍵で署名する
          key =
            if pkgs.stdenv.hostPlatform.isDarwin then
              "${sshDir}/id_ecdsa_secretive.pub"
            else
              "${sshDir}/id_ed25519_sk.pub";
          signByDefault = true;
          allowedSigners = builtins.concatStringsSep "\n" (
            map (key: "${user.git.email} namespaces=\"git\" ${pkgs.lib.trim (builtins.readFile key)}") [
              ../../security/openssh/id_ecdsa_secretive.pub
              ../../security/openssh/id_ed25519_sk.pub
            ]
          );
        };
        ignores = [
          # Created by https://www.toptal.com/developers/gitignore/api/macos
          # Edit at https://www.toptal.com/developers/gitignore?templates=macos

          ### macOS ###
          # General
          ".DS_Store"
          ".AppleDouble"
          ".LSOverride"

          # Icon must end with two \r
          "Icon"

          # Thumbnails
          "._*"

          # Files that might appear in the root of a volume
          ".DocumentRevisions-V100"
          ".fseventsd"
          ".Spotlight-V100"
          ".TemporaryItems"
          ".Trashes"
          ".VolumeIcon.icns"
          ".com.apple.timemachine.donotpresent"

          # Directories potentially created on remote AFP share
          ".AppleDB"
          ".AppleDesktop"
          "Network Trash Folder"
          "Temporary Items"
          ".apdisk"

          ### macOS Patch ###
          # iCloud generated files
          "*.icloud"

          # End of https://www.toptal.com/developers/gitignore/api/macos

          # Claude Code local settings
          "**/.claude/settings.local.json"

          # Git Worktree用ディレクトリ
          ".worktrees/"

          # 一時ファイル
          ".tmp/"
          "tmp/"

          # Emacs・Vimがファイル名の末尾に~を付けて作成するバックアップファイル
          "*~"

          # KDE PlasmaのファイルマネージャーDolphinが作成するメタデータ
          ".directory"

          # 各パーティション・ディスクのLinuxのゴミ箱
          ".Trash-*"

          # NFSで、アクセス中に削除したファイルの代わりに残るファイル
          ".nfs*"

          # Vimのスワップファイル（.swpが既にある場合は.swo）
          "*.swp"
          "*.swo"

          # Emacsのロックファイル（未保存の変更があるファイルを示す）
          ".\\#*"

          # Emacsの自動保存ファイル
          "\\#*\\#"
        ];
      };
    };
}
