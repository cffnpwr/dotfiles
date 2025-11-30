{ ... }:
{
  programs.sheldon = {
    enable = true;
    enableZshIntegration = false; # Managed manually in zshrc
  };

  # 順序を保持するため、外部TOMLファイルから読み込み
  xdg.configFile."sheldon/plugins.toml".source = ./plugins.toml;
}
