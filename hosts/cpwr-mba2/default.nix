{ ... }:
{
  system.stateVersion = 6;

  # ホスト名設定
  networking = {
    hostName = "cpwr-mba2";
    computerName = "cpwr-mba2";

    knownNetworkServices = [
      "Wi-Fi"
      "AX88179A"
      "USB 10/100/1000 LAN"
      "Tailscale"
    ];
  };

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
