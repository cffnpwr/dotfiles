{
  flake.modules.darwin.homeManager = { ... }: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      backupFileExtension = "backup-before-hm";
    };
  };

  flake.modules.homeManager.core = { ... }: {
    programs.home-manager.enable = true;

    fonts.fontconfig.enable = true;

    targets.darwin = {
      copyApps.enable = true;
      linkApps.enable = false;
    };
  };
}
