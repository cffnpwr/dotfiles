{{- if eq .os "darwin" -}}
# 継承PATHに依存せず、既知の最小PATHで実行する。壊れた・応答しないPATHエントリ
# (死んだネットワークマウント・automount等)でのコマンド探索ハングを避ける。
# apm/fc-cache/mas を解決するため、先頭に brew prefix を置く。
# 優先度: HOMEBREW_PREFIX > 既定(/opt/homebrew) > Intel(/usr/local)。
__brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"
[ -x "${__brew_prefix}/bin/brew" ] || __brew_prefix="/usr/local"
export PATH="${__brew_prefix}/bin:${__brew_prefix}/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
unset __brew_prefix
{{- else -}}
# 継承PATHに依存せず、既知の最小PATHで実行する。壊れた・応答しないPATHエントリ
# (死んだネットワークマウント・automount等)でのコマンド探索ハングを避ける。
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
{{- end -}}
