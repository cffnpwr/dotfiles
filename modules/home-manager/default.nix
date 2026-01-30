{
  osConfig,
  config,
  ...
}:
let
  # home-manager state version
  stateVersion = "26.05";
in
{
  imports = [
    ./packages
    ./programs
    ./services
  ];

  # Enable XDG support
  xdg.enable = true;

  # enable fontconfig
  fonts.fontconfig.enable = true;

  # Copy apps instead of symlinking to fix macOS privacy permissions (TCC)
  # Symlinked apps from Nix store are not properly recognized by macOS privacy system
  # This fixes screen sharing issues with apps like Discord
  targets.darwin = {
    copyApps.enable = true;
    linkApps.enable = false;
  };

  home = {
    username = osConfig.username;
    homeDirectory = osConfig.homeDirectory;
    stateVersion = stateVersion;
  };

  # agenix secrets
  age = {
    identityPaths = [
      "${config.xdg.configHome}/age/key.txt"
    ];

    secrets.github-token = {
      file = ../../secrets/github-token.age;
    };
  };
}
