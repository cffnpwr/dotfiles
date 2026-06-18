---
name: chezmoi
description: このdotfilesリポジトリのchezmoi運用。chezmoiでファイルを編集・diff・apply・反映する時に参照する。chezmoiのsource（~/.local/share/chezmoi）と開発clone（このリポジトリ）が別の場所にある構成、--sourceでの指定、削除の非伝播、全体applyの副作用を扱う。chezmoi diffが空・反映されない・古いファイルが残る等で詰まった時に必ず読む。
compatibility: |
  chezmoi CLI が必要。外部の言語ランタイムは不要。
---

# chezmoi（このdotfilesリポジトリの運用）

chezmoiでdotfilesを編集・反映する際の、このリポジトリ固有の構成と注意点。

## Requirements

- chezmoi CLI。存在確認は `command -v chezmoi`。
- 不在なら停止し、ユーザーへエスカレーションする（勝手にインストールしない）。

## 構成: sourceと開発cloneが別物

このリポジトリ（開発clone）とchezmoiのsourceは**別の場所にある**。

| 役割 | パス | 用途 |
| --- | --- | --- |
| chezmoi source | `~/.local/share/chezmoi` | `chezmoi` がデフォルトで読む場所（https origin） |
| 開発clone | このリポジトリ（ssh origin、jj管理） | 編集・コミット・PRを行う場所 |

- `.chezmoiroot` は `homedir` を指す。source rootは `<repo>/homedir`。
- `chezmoi source-path` で実効sourceを確認できる。

## 編集と反映

編集は開発cloneで行う。`chezmoi` はデフォルトで `~/.local/share/chezmoi` を見るため、**開発cloneの変更をそのままapplyできない**（`chezmoi diff` が空になる原因）。

開発cloneの変更を反映する方法は2つ。

1. **`--source` で開発cloneを指定する**（即時反映したい時）。

   ```sh
   chezmoi diff  --source <repo root>
   chezmoi apply --source <repo root>
   ```

   `<repo root>` を渡せば `.chezmoiroot` で `homedir/` に入る。`diff` が空に見える時は target を絞らず全体で確認する。

2. **commit & push → source側で取り込む**（通常運用）。開発cloneでcommit & pushし、`~/.local/share/chezmoi` を `git pull` してから `chezmoi apply`。

## 注意点

- **source削除は自動反映されない。** sourceからファイルを消しても、実環境（`~/` 配下）には残る。削除を反映するには、実環境で手動削除するか `.chezmoiremove` を使う。
- **全体applyは `.chezmoiscripts` を実行する。** homebrewのinstall/upgrade、パッケージ導入、agent-skills導入などのスクリプトが走り、時間・ネットワーク・パッケージ変更の重い副作用がある。特定ファイルだけ反映したい時は target path を指定して範囲を絞る。

   ```sh
   chezmoi apply --source <repo root> ~/.claude/CLAUDE.md
   ```
