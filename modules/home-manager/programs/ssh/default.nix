{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        extraOptions = {
          IgnoreUnknown = "UseKeychain";
          UseKeychain = "yes";
          AddKeysToAgent = "yes";
        };
      };

      "cpwr-rpi0" = {
        hostname = "192.168.0.129";
        user = "cffnpwr";
        identitiesOnly = true;
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };

      "cpwr-dev0" = {
        hostname = "192.168.0.131";
        user = "cffnpwr";
        identitiesOnly = true;
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
        # proxyCommand = "/Users/cffnpwr/.local/bin/quicssh-rs client quic://%h:4433";
      };

      "tmcit-312" = {
        hostname = "172.24.20.128";
        user = "cffnpwr";
        identitiesOnly = true;
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/Users/cffnpwr/.gnupg/S.gpg-agent.extra";
          }
        ];
      };

      "github" = {
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
      };
    };
  };

  # SSH起動時に実行されるスクリプト
  # GPGエージェントのソケットをリンク
  home.file.".ssh/rc" = {
    text = ''
      ln -nsf $(gpgconf --list-dir agent-socket) $(gpgconf --list-dir agent-extra-socket)
    '';
    executable = true;
  };

  # SSH公開鍵の配置
  home.file.".ssh/id_ed25519.pub" = {
    text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElBJtWJa3BS8FTy3t7UO31pi/3MsSMHTEkkILOsBQtF cpwr-mba2
    '';
  };
}
