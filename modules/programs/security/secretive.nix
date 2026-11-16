{
  # nixpkgsの更新が止まっているためhomebrewで導入
  flake.modules.darwin.secretive = {
    homebrew.casks = [ "secretive" ];
  };

  flake.modules.homeManager.secretive =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      socket = "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
    in
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.sessionVariables.SSH_AUTH_SOCK = socket;

      # 全ホストに適用するため、openssh/default.nixの"*"より前に挿入
      programs.ssh.settings.secretive = lib.hm.dag.entryBefore [ "*" ] {
        header = "Host *";
        IdentityAgent = socket;
        IdentityFile = "~/.ssh/id_ecdsa_secretive.pub";
      };
    };
}
