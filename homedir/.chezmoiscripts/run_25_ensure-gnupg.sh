#!/usr/bin/env bash
set -euo pipefail

printf '==> [ensure-gnupg] %s\n' "checking ~/.gnupg permissions" >&2

# gpg は ~/.gnupg のパーミッションが緩いと警告・拒否するため、
# 存在と権限を毎回検査して満たされていなければmode 700でディレクトリを作成。
install -d -m 700 "$HOME/.gnupg"
