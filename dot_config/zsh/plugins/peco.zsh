#!/bin/zsh

# Peco
# 履歴検索
function peco-select-history() {
    BUFFER=$(\history -r -n 1 | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
# ghqで管理しているリポジトリをpecoで選択してcdする
function peco-cd-src () {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
# cdr
function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}

zle -N peco-select-history
zle -N peco-cd-src
zle -N peco-cdr
