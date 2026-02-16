{
  osConfig,
  ...
}:
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = osConfig.username;
        email = osConfig.email;
      };
      ui.default-command = "log";

      signing = {
        behavior = "own";
        backend = "ssh";
        key = "${osConfig.homeDirectory}/.ssh/id_ed25519.pub";
        backends.ssh.allowed-signers = "${osConfig.homeDirectory}/.config/git/allowed_signers";
      };
    };
  };
}
