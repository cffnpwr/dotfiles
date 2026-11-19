{ inputs, ... }:
{
  flake.modules.homeManager.zen =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
      zenAppPath = "${config.home.homeDirectory}/${config.targets.darwin.copyApps.directory}/${config.programs.zen-browser.finalPackage.applicationName}.app";

      # 拡張機能のslugとaddon IDの組からaddon IDをキーにしたExtensionSettingsを生成
      mkExtensionSettings = lib.mapAttrs' (
        _: extId:
        lib.nameValuePair extId {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${extId}/latest.xpi";
          installation_mode = "force_installed";
        }
      );
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;
        # macOSはactivation scriptで設定
        setAsDefaultBrowser = true;

        policies.ExtensionSettings = mkExtensionSettings (import ./_extensions.nix);

        profiles.default = {
          id = 0;
          settings = import ./_prefs.nix;
        }
        // import ./_session.nix;
      };

      home.activation.zenDefaultBrowser = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
        lib.hm.dag.entryAfter [ "copyApps" ] ''
          # defaultbrowserはLaunchServicesに登録されたアプリだけを選択できるため、ZenをLaunchServicesに登録
          run ${lsregister} -f ${lib.escapeShellArg zenAppPath}
          run ${pkgs.defaultbrowser}/bin/defaultbrowser zen
        ''
      );
    };
}
