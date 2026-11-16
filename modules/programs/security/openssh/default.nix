{
  flake.modules.homeManager.openssh =
    { lib, pkgs, ... }:
    {
      programs.ssh = {
        enable = true;
        package = pkgs.openssh;
        enableDefaultConfig = false;

        settings = {
          github = {
            HostName = "github.com";
            IdentitiesOnly = true;
            User = "git";
          };
          "*" = lib.hm.dag.entryAfter [ "github" ] {
            IdentityFile = "~/.ssh/id_ed25519_sk";
          };
        };
      };

      home.file = {
        ".ssh/id_ecdsa_secretive.pub".source = ./id_ecdsa_secretive.pub;
        ".ssh/id_ed25519_sk.pub".source = ./id_ed25519_sk.pub;
        # sshdはログインシェルを経由しないためgpgconfを絶対パスで指定
        ".ssh/rc" = {
          executable = true;
          text = ''
            agent_socket="$(${lib.getExe' pkgs.gnupg "gpgconf"} --list-dir agent-socket)"
            agent_extra_socket="$(${lib.getExe' pkgs.gnupg "gpgconf"} --list-dir agent-extra-socket)"
            if [ -S "$agent_socket" ]; then
              ln -nsf "$agent_socket" "$agent_extra_socket"
            fi
          '';
        };
      };

      home.activation.sshDirectoryPermission = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run chmod 700 "$HOME/.ssh"
      '';
    };
}
