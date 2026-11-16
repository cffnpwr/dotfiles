{
  flake.modules.homeManager.eza =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.eza ];

      # programs.ezaのzsh integrationは別のエイリアスを定義するため無効化
      programs.zsh.shellAliases = {
        ea = "eza -a --icons --git";
        ee = "eza -aahl --icons --git";
        ei = "eza --icons --git";
        et = "eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons";
        eta = "eza -T -a -I 'node_modules|.git|.cache' --color=always --icons | less -r";
        l = "clear && ls";
        la = "ea";
        ll = "ee";
        ls = "ei";
        lt = "et";
        lta = "eta";
      };
    };
}
