{ inputs, ... }:
{
  flake.modules.homeManager.zen =
    { lib, pkgs, ... }:
    let
      # 拡張機能のslugとaddon IDの組から、addon IDをキーにしたExtensionSettingsを生成する
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
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if ! ${pkgs.defaultbrowser}/bin/defaultbrowser | grep -qx '\* zen'; then
            run ${pkgs.defaultbrowser}/bin/defaultbrowser zen
          fi
        ''
      );
    };
}
