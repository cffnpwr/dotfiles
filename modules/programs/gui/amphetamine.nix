{
  flake.modules.darwin.amphetamine = {
    homebrew.masApps.Amphetamine = 937984704;
  };

  flake.modules.homeManager.amphetamine =
    { lib, pkgs, ... }:
    {
      launchd.agents.amphetamine = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        enable = true;
        config = {
          Label = "com.if.Amphetamine";
          ProgramArguments = [ "/Applications/Amphetamine.app/Contents/MacOS/Amphetamine" ];
          RunAtLoad = true;
          KeepAlive = false;
        };
      };
    };
}
