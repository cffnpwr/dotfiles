{
  flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      historyWidget.command = "";
    };

    programs.zsh.initContent = ''
      function fzf_cd_ghq() {
        local selected_dir=$(ghq list -p | fzf --layout reverse --height 40% --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
          BUFFER="$(command -v z >/dev/null && echo "z" || echo "cd") ''${selected_dir}"
          zle accept-line
        fi
      }
      zle -N fzf_cd_ghq

      function fzf_cd_git_worktree() {
        local selected_dir=$(git worktree list | fzf --layout reverse --height 40% --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
          local worktree_path=''${selected_dir%% *}
          BUFFER="$(command -v z >/dev/null && echo "z" || echo "cd") $worktree_path"
          zle accept-line
        fi
      }
      zle -N fzf_cd_git_worktree

      bindkey '^X' fzf_cd_ghq
      bindkey '^G' fzf_cd_git_worktree
    '';
  };
}
