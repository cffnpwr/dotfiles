#!/bin/zsh

# fzf plugin functions for zsh

function _is_command() {
  command -v "$1" >/dev/null
}

# Fuzzy search through command history

function fzf_history() {
  BUFFER=$(history -r -n 1 | fzf --layout reverse --height 40% --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N fzf_history


# Fuzzy change directory to a ghq repository

function fzf_cd_ghq() {
  local selected_dir=$(ghq list -p | fzf --layout reverse --height 40% --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="$(_is_command z && echo "z" || echo "cd") ${selected_dir}"
    zle accept-line
  fi
}
zle -N fzf_cd_ghq


# Fuzzy change directory to a git worktree

function fzf_cd_git_worktree() {
  local selected_dir=$(git worktree list | fzf --layout reverse --height 40% --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    local worktree_path=${selected_dir%% *}
    BUFFER="$(_is_command z && echo "z" || echo "cd") $worktree_path"
    zle accept-line
  fi
}
zle -N fzf_cd_git_worktree


# Bindings
bindkey '^R' fzf_history
bindkey '^X' fzf_cd_ghq
bindkey '^G' fzf_cd_git_worktree
