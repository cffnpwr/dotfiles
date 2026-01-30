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
    };
  };
}
