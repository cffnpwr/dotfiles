#!/bin/bash

# Git commit署名検証スクリプト
# Bashツールでgit commitコマンド実行時に-Sオプションの存在をチェック

# 標準入力からコマンド情報を取得
command_info=$(cat)

# デバッグ情報出力
echo "DEBUG: Command info: '$command_info'" >&2

# コマンドを抽出
command=$(echo "$command_info" | jq -r '.command // empty' 2>/dev/null)

# commandが空の場合、直接文字列として処理
if [ -z "$command" ]; then
  command="$command_info"
fi

echo "DEBUG: Extracted command: '$command'" >&2

# git commitコマンドかチェック
if echo "$command" | grep -q "^git commit"; then
  echo "DEBUG: Git commit command detected" >&2
  
  # -Sオプションの存在チェック
  if echo "$command" | grep -q -- "-S"; then
    echo "✅ Git commit コマンドに署名オプション (-S) が含まれています" >&2
    echo '{
  "decision": "approve",
  "reason": "Git commit command includes GPG signing option (-S)"
}'
    exit 0
  else
    echo "❌ エラー: Git commit コマンドに署名オプション (-S) が含まれていません" >&2
    echo "GPG署名付きコミットを作成するため、必ず -S オプションを使用してください" >&2
    echo "例: git commit -S -m \"commit message\"" >&2
    echo "現在のコマンド: $command" >&2
    echo '{
  "decision": "block",
  "reason": "Git commit command missing required GPG signing option (-S). Use: git commit -S -m \"message\""
}'
    exit 1
  fi
else
  echo "DEBUG: Not a git commit command, skipping check" >&2
  echo '{
  "decision": "approve",
  "reason": "Not a git commit command, no signing validation required"
}'
  exit 0
fi