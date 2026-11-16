{
  flake.modules.homeManager.atuin = {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings.search_mode_shell_up_key_binding = "fulltext";
    };
  };
}
