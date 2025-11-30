{ ... }:
{
  xdg.configFile = {
    "zsh/plugins/bindkey.zsh".source = ./bindkey.zsh;
    "zsh/plugins/fzf.zsh".source = ./fzf.zsh;
    "zsh/plugins/vscode.zsh".source = ./vscode.zsh;
  };
}
