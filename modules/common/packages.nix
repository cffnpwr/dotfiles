{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # git
    git
    lazygit

    # build tools
    gcc
    cmake
    gnumake
    pkgconf

    # network
    openssh
    openssl
    curl
    wget
    cacert
    tailscale

    # security
    gnupg

    # dotfiles management
    chezmoi
  ];
}
