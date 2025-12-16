{ ... }:

{
  imports = [
    # import service module definitions
    ./alt-tab
    ./amphetamine
    ./bitwarden
    ./darwin.nix
    ./raycast
    ./runcat
    ./scroll-reverser
    ./stats

    # import service configurations
    ./darwin.nix
  ];
}
