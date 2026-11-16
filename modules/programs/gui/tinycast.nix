{
  # nixpkgsの更新が止まっているためhomebrewから導入
  flake.modules.darwin.tinycast = {
    homebrew.casks = [ "tinycast" ];
  };

  flake.modules.homeManager.tinycast =
    { lib, pkgs, ... }:
    {
      launchd.agents.tinycast = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        enable = true;
        config = {
          Label = "com.tinycast.app";
          ProgramArguments = [ "/Applications/Tinycast.app/Contents/MacOS/Tinycast" ];
          RunAtLoad = true;
          KeepAlive = false;
        };
      };
    };
}
