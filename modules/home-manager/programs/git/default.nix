{ osConfig, ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = osConfig.username;
        email = osConfig.email;
      };

      init = {
        defaultBranch = "main";
      };

      ghq = {
        root = "~/git";
      };

      credential = {
        helper = "/usr/local/share/gcm-core/git-credential-manager";
      };

      commit = {
        gpgsign = true;
      };

      gpg = {
        ssh = {
          allowedSignersFile = "${osConfig.homeDirectory}/.config/git/allowed_signers";
        };
      };
    };

    signing = {
      format = "ssh";
      key = "${osConfig.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    ignores = [
      # macOS
      ".DS_Store"

      # Claude Code local settings
      "**/.claude/settings.local.json"

      # git worktrees and jj workspaces
      ".worktrees/"

      # scratch files
      ".scratches/"
    ];
  };

  xdg.configFile."git/allowed_signers".text = ''
    ${osConfig.email} namespaces="git" ${osConfig.sshPublicKey}
  '';
}
