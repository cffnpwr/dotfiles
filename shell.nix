{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    git
    nil
    nixd
    nixfmt-rfc-style
  ];
}
