{
  flake.modules.homeManager.atuin = {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        enter_accept = true;
        search_mode_shell_up_key_binding = "fulltext";
      };
    };
  };
}
