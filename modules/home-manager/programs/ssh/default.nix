{ osConfig, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        IgnoreUnknown = "UseKeychain";
        UseKeychain = "yes";
        AddKeysToAgent = "yes";
      };

      "cpwr-rpi0" = {
        HostName = "192.168.0.129";
        User = osConfig.username;
        IdentitiesOnly = true;
        ForwardAgent = true;
        ForwardX11 = true;
        ForwardX11Trusted = true;
      };

      "cpwr-dev0" = {
        HostName = "192.168.0.131";
        User = osConfig.username;
        IdentitiesOnly = true;
        ForwardAgent = true;
        ForwardX11 = true;
        ForwardX11Trusted = true;
      };

      "github" = {
        HostName = "github.com";
        User = "git";
        IdentitiesOnly = true;
      };
    };
  };
  home = {
    # SSH起動時に実行されるスクリプト
    # GPGエージェントのソケットをリンク
    file.".ssh/rc" = {
      text = ''
        ln -nsf $(gpgconf --list-dir agent-socket) $(gpgconf --list-dir agent-extra-socket)
      '';
      executable = true;
    };

    # SSH公開鍵の配置
    file.".ssh/id_ed25519.pub" = {
      text = osConfig.sshPublicKey;
    };
  };
}
