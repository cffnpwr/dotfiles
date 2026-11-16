{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = import ./_settings.nix;
    };
  };
}
