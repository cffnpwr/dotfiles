{
  flake.modules.homeManager.herdr =
    { lib, pkgs, ... }:
    let
      serviceName = "dev.herdr";
    in
    {
      programs.herdr = {
        enable = true;
        settings = {
          onboarding = false;
          theme = {
            name = "tokyo-night";
          };
          terminal = { };
          update = { };
          keys = {
            prefix = "ctrl+h";
          };
          ui = {
            agent_panel_sort = "priority";
            toast = {
              delivery = "terminal";
              herdr = { };
              clipboard = { };
            };
            sound.enabled = false;
          };
          session = { };
          remote = { };
          experimental = {
            pane_history = false;
          };
          advanced = { };
        };
      };

      home.file.".local/bin/herdr-attach" = {
        source = pkgs.replaceVars ./herdr-attach { inherit serviceName; };
        executable = true;
      };

      launchd.agents.herdr = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        enable = true;
        config = {
          Label = serviceName;
          ProgramArguments = [
            "${lib.getExe pkgs.zsh}"
            "-l"
            "-c"
            "exec herdr server"
          ];
          RunAtLoad = true;
          KeepAlive = true;
        };
      };

      systemd.user.services.${serviceName} = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        Unit.Description = "herdr server";
        Service = {
          ExecStart = "${lib.getExe pkgs.zsh} -l -c 'exec herdr server'";
          Restart = "always";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
