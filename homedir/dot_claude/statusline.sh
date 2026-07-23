#!/usr/bin/env bash
# Claude Code statusLine (3行)
# 1:  <cwd> | 󰊢 <branch>:<commit> <bookmark[+dist]>:<change-id>
# 2: 󰧑 <ctx bar> <ctx%> | 󰚩 <model>(<effort>)
# 3:  <5h bar> <5h%> | 󰨳 <7d bar> <7d%>
set -u

input=$(cat)

RESET=$'\033[0m'
DIM=$'\033[2m'
CYAN=$'\033[36m'
MAGENTA=$'\033[35m'
YELLOW=$'\033[33m'
GREEN=$'\033[32m'
RED=$'\033[31m'
ID_PREFIX=$'\033[1;38;5;4m'
ID_REST=$'\033[38;5;8m'

cwd=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
[ -z "$cwd" ] && cwd="$PWD"
display_cwd="${cwd/#$HOME/\~}"

model=$(jq -r '.model.display_name // empty' <<<"$input")
effort=$(jq -r '.effort.level // empty' <<<"$input")
ctx=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
five_h=$(jq -r '.rate_limits.five_hour.used_percentage // empty' <<<"$input")
seven_d=$(jq -r '.rate_limits.seven_day.used_percentage // empty' <<<"$input")

jjlog() {
  jj -R "$cwd" --ignore-working-copy log --no-graph "$@" 2>/dev/null
}

is_jj=0
is_git=0
jj -R "$cwd" --ignore-working-copy root >/dev/null 2>&1 && is_jj=1
git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1 && is_git=1

git_chunk=""
if [ "$is_git" = "1" ]; then
  branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch="HEAD"
  commit=""
  head_hash=$(git -C "$cwd" --no-optional-locks rev-parse HEAD 2>/dev/null)
  if [ "$is_jj" = "1" ] && [ -n "$head_hash" ]; then
    commit=$(jjlog -r "$head_hash" --color=always -T 'format_short_commit_id(commit_id)')
  fi
  if [ -z "$commit" ] && [ -n "$head_hash" ]; then
    uniq=$(git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    full8=${head_hash:0:8}
    [ -n "$uniq" ] && commit="${ID_PREFIX}${uniq}${RESET}${ID_REST}${full8:${#uniq}}${RESET}"
  fi
  git_chunk="${GREEN}${branch}${RESET}"
  [ -n "$commit" ] && git_chunk+=":${commit}"
fi

jj_chunk=""
if [ "$is_jj" = "1" ]; then
  change=$(jjlog -r @ --color=always -T 'format_short_change_id_with_change_offset(self)')
  bookmark=$(jjlog -r 'heads(::@ & bookmarks())' -T 'bookmarks.join(",") ++ "\n"' | paste -sd, - | sed 's/^,*//; s/,*$//')
  if [ -n "$bookmark" ]; then
    dist_marks=$(jjlog -r '(heads(::@ & bookmarks())..@) ~ (@ & empty() & description(exact:""))' -T '"."')
    dist=${#dist_marks}
    jj_chunk="${MAGENTA}${bookmark}${RESET}"
    [ "$dist" -gt 0 ] && jj_chunk+="${YELLOW}+${dist}${RESET}"
    [ -n "$change" ] && jj_chunk+=":"
  fi
  jj_chunk+="$change"
fi

# meter <pct>: 10文字バーと閾値色の百分率を出力（>=90赤 / >=70黄 / それ未満緑）
meter() {
  local pct pct_str
  pct=$(printf '%.0f' "$1" 2>/dev/null)
  [ -z "$pct" ] && pct=0
  pct_str=$(printf '%3d' "$pct")
  local color=$GREEN
  if [ "$pct" -ge 90 ]; then
    color=$RED
  elif [ "$pct" -ge 70 ]; then
    color=$YELLOW
  fi
  local filled=$(((pct + 5) / 10))
  [ "$filled" -gt 10 ] && filled=10
  [ "$filled" -lt 0 ] && filled=0
  local bar_filled bar_empty
  bar_filled=$(printf '█%.0s' $(seq 1 "$filled") 2>/dev/null)
  bar_empty=$(printf '░%.0s' $(seq 1 $((10 - filled))) 2>/dev/null)
  [ "$filled" -eq 0 ] && bar_filled=""
  [ "$filled" -eq 10 ] && bar_empty=""
  printf '%s %s' "${color}${bar_filled}${RESET}${DIM}${bar_empty}${RESET}" "${color}${pct_str}%${RESET}"
}

sep="${DIM} | ${RESET}"

ICON_DIR=$'\uf4d4'
ICON_GIT=$'\uf418'
ICON_CTX=$'\U000f09d1'
ICON_MODEL=$'\U000f06a9'
ICON_5H=$'\ue386'
ICON_7D=$'\U000f0a33'

line1="${ICON_DIR} ${CYAN}${display_cwd}${RESET}"
vcs=""
[ -n "$git_chunk" ] && vcs="${ICON_GIT} ${git_chunk}"
if [ -n "$jj_chunk" ]; then
  [ -n "$vcs" ] && vcs+=" "
  vcs+="$jj_chunk"
fi
[ -n "$vcs" ] && line1+="${sep}${vcs}"

line2="${ICON_CTX} $(meter "${ctx:-0}")${sep}${ICON_MODEL} ${YELLOW}${model}${RESET}"
[ -n "$effort" ] && line2+="${DIM}(${effort})${RESET}"

line3=""
[ -n "$five_h" ] && line3="${ICON_5H} $(meter "$five_h")"
if [ -n "$seven_d" ]; then
  [ -n "$line3" ] && line3+="$sep"
  line3+="${ICON_7D} $(meter "$seven_d")"
fi

printf '%s\n' "$line1"
printf '%s' "$line2"
if [ -n "$line3" ]; then
  printf '\n%s' "$line3"
fi
