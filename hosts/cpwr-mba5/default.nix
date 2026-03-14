{ ... }:
{
  system.stateVersion = 6;

  # ホスト名設定
  networking = {
    hostName = "cpwr-mba5";
    computerName = "cpwr-mba5";

    knownNetworkServices = [
      "Wi-Fi"
      "AX88179A"
      "USB 10/100/1000 LAN"
      "Tailscale"
    ];
  };

  # Install Rosetta 2 for running x86_64 binaries on Apple Silicon
  # nix-darwin has no built-in option; use activationScripts instead
  # Ref: https://github.com/nix-darwin/nix-darwin/issues/786
  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
