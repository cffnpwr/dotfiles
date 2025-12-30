{ pkgs, lib, ... }:
{
  # macOS-specific packages
  # Note: Packages managed by programs.* modules are NOT listed here
  # (ghostty, mas, google-japanese-ime, etc.)
  home.packages = lib.mkIf pkgs.stdenv.isDarwin (
    with pkgs;
    [
      # Window Manager
      aerospace

      # Utilities
      alt-tab-macos
      iproute2mac
      pinentry_mac
      raycast
      scroll-reverser
      stats

      # Office
      microsoft-office.word
      microsoft-office.excel
      microsoft-office.powerpoint
      teams
    ]
  );
}
