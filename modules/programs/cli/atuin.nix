{
  flake.modules.homeManager.atuin =
    { config, ... }:
    {
      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          data_dir = "${config.xdg.dataHome}/atuin";
          enter_accept = true;
          search_mode_shell_up_key_binding = "fulltext";
        };
      };
    };
}
