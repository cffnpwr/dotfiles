{ osConfig, lib, pkgs, packages, ... }:
let
  google-japanese-ime = packages.google-japanese-ime;

  imes = [
    google-japanese-ime
  ];
  imeSrcDir = pkgs.runCommand "declarative-ime-src" {
    nativeBuildInputs = [
      pkgs.fd
      pkgs.rsync
    ];
  } ''
    set -euo pipefail

    mkdir -p $out
    echo "Building declarative IME source directory..."

    for ime in ${lib.concatStringsSep " " (lib.map (ime: "\"${ime}\"") imes)}; do
      fd --base-directory "$ime/Library/Input Methods/" -d 1 -t dir -e app --exec rsync -a {} "$out/"
    done

    echo "Declarative IME source directory built at $out"
  '';
  imeDstDir = "${osConfig.homeDirectory}/Library/Input Methods";
in
{
  imports = [
    ./packages
    ./programs
    ./services
  ];

  # Disable home-manager's built-in Claude Code module to use our custom one
  disabledModules = [
    "programs/claude-code.nix"
  ];

  xdg.enable = true;

  home = {
    username = osConfig.username;
    homeDirectory = osConfig.homeDirectory;
    stateVersion = osConfig.stateVersion;

    activation.manageIMEs = lib.mkIf pkgs.stdenv.isDarwin (lib.hm.dag.entryAfter [ "installPackages" ] ''
      set -euo pipefail

      echo "Declarative IME activation started..."
      mkdir -p "${imeDstDir}"
      $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync -a --delete --no-perms --no-owner --no-group "${imeSrcDir}/" "${imeDstDir}/"

      echo "Registering IMEs with the system..."
      $DRY_RUN_CMD ${pkgs.fd}/bin/fd --base-directory "${imeDstDir}" -t dir -e app -d 1 --exec \
      /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -R -f {}

      echo "Reloading system settings..."
      $DRY_RUN_CMD /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

      echo "Declarative IME activation completed."
    '');
  };
}
