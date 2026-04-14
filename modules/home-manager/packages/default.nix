{ pkgs, ... }:
{
  # Import platform-specific packages
  imports = [
    ./darwin.nix
    ./linux.nix
  ];

  # Common packages for all platforms
  # Note: Packages managed by programs.* modules are NOT listed here
  # (git, starship, sheldon, mise, zellij, zen-browser, etc.)
  home.packages = with pkgs; [
    # git tools
    gh
    ghq

    # editor
    neovim

    # shell tools
    android-tools
    bat
    coreutils
    eza
    fd
    fzf
    nix-search-cli
    ripgrep
    tree
    xh
    zoxide

    # build tools
    mold

    # data processing
    jq
    yq

    # utilities
    fastfetch

    # container Tools
    docker
    docker-compose
    podman

    # network Tools
    wakeonlan
    wireshark
    rquickshare

    # media
    spotify

    # knowledge management
    obsidian

    # LLM Chat
    claude

    # LaTeX
    texliveFull

    # communication
    discord

    # fonts
    nerd-fonts._0xproto
    koruri
  ];
}
