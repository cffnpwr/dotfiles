#!/bin/zsh

# fzf
# 履歴検索
function fzf-select-history() {
    BUFFER=$(\history -r -n 1 | fzf --layout reverse --height 40% --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
# ghqで管理しているリポジトリをfzfで選択してcdする
function fzf-cd-src () {
    local selected_dir=$(ghq list -p | fzf --layout reverse --height 40% --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
# cdr
function fzf-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]* *//' | fzf --layout reverse --height 40% --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}

zle -N fzf-select-history
zle -N fzf-cd-src
zle -N fzf-cdr
