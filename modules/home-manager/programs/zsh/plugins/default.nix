{ ... }:
{
  imports = [
    ./fzf.nix
  ];

  xdg.configFile = {
    "zsh/plugins/bindkey.zsh".source = ./bindkey.zsh;
    "zsh/plugins/vscode.zsh".source = ./vscode.zsh;
  };
}
