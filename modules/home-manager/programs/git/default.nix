{ ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "CaffeinePower";
        email = "cffnpwr@gmail.com";
      };

      init = {
        templatedir = "~/.config/git/template";
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
          allowedSignersFile = "~/.config/git/allowed_signers";
        };
      };
    };

    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    ignores = [
      # macOS
      ".DS_Store"

      # Claude Code local settings
      "**/.claude/settings.local.json"
    ];
  };
}
