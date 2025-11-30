{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # macOS specific tools
    pinentry_mac
    iproute2mac
  ];
}
