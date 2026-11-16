{
  # ブラウザ拡張機能との連携のためMac App Storeから導入
  flake.modules.darwin.bitwarden = {
    homebrew.masApps.Bitwarden = 1352778147;
  };

  flake.modules.homeManager.bitwarden =
    { lib, pkgs, ... }:
    {
      launchd.agents.bitwarden = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        enable = true;
        config = {
          Label = "com.bitwarden.desktop";
          ProgramArguments = [ "/Applications/Bitwarden.app/Contents/MacOS/Bitwarden" ];
          RunAtLoad = true;
          KeepAlive = false;
        };
      };
    };
}
