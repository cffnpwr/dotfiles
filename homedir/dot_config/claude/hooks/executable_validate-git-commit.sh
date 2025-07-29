#!/bin/bash

# Git commit統合検証スクリプト
# GPG署名チェック + Conventional Commits + Gitmoji 形式チェック
# 形式: <type> <emoji>: <Japanese message in noun form>

# 標準入力からJSON形式の情報を取得
json_input=$(cat)

# デバッグ情報出力
echo "DEBUG: JSON input: '$json_input'" >&2

# JSONからコマンドを抽出
command=$(echo "$json_input" | jq -r '.tool_input.command // empty' 2>/dev/null)

# commandが空の場合、エラー
if [ -z "$command" ]; then
  echo "DEBUG: Failed to extract command from JSON input" >&2
  exit 0
fi

echo "DEBUG: Extracted command: '$command'" >&2

# git commitコマンドでない場合は検証をスキップ
if ! echo "$command" | grep -q "^git commit"; then
  echo "DEBUG: Not a git commit command, skipping validation" >&2
  echo '{
  "decision": "approve",
  "reason": "Not a git commit command, no validation required"
}'
  exit 0
fi

echo "DEBUG: Git commit command detected" >&2

# ===========================================
# 1. GPG署名検証
# ===========================================

# -Sオプションの存在チェック
if echo "$command" | grep -q -- "-S"; then
  echo "✅ Git commit コマンドに署名オプション (-S) が含まれています" >&2
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

# ===========================================
# 2. コミットメッセージ形式検証
# ===========================================

# コマンドから -m オプションでコミットメッセージを抽出
if echo "$command" | grep -q -- "-m"; then
  # -m "message" の形式からメッセージを抽出（改行文字を削除）
  commit_message=$(printf '%s' "$command" | sed 's/.*-m[[:space:]]*["'\'']//' | sed 's/["'\''].*$//')
else
  echo "DEBUG: No -m option found in git commit command, skipping message validation" >&2
  echo '{
  "decision": "approve",
  "reason": "Git commit command with GPG signing verified. No -m option for message validation."
}'
  exit 0
fi

echo "DEBUG: Extracted commit message: '$commit_message'" >&2

# 空のメッセージチェック
if [ -z "$commit_message" ]; then
  echo "❌ エラー: コミットメッセージが空です" >&2
  echo "使用方法: git commit -S -m \"feat ✨: 新機能の追加\"" >&2
  echo "形式: <type> <emoji>: <Japanese message in noun form>" >&2
  echo '{
  "decision": "block",
  "reason": "Empty commit message. Use format: <type> <emoji>: <Japanese message in noun form>"
}'
  exit 1
fi

# 改行チェック（複数行でないことを確認）
line_count=$(echo "$commit_message" | wc -l | tr -d ' ')
if [ "$line_count" -ne 1 ]; then
  echo "❌ エラー: コミットメッセージが複数行になっています" >&2
  echo "コミットメッセージは1行で記述してください" >&2
  echo "現在の行数: $line_count 行" >&2
  echo '{
  "decision": "block",
  "reason": "Commit message contains multiple lines. Please use single line format."
}'
  exit 1
fi

# 基本パターンチェック
# 形式: <type> <emoji>: <message>
if ! echo "$commit_message" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert) [^\s]+: .+'; then
  echo "❌ エラー: コミットメッセージの形式が正しくありません" >&2
  echo "正しい形式: <type> <emoji>: <Japanese message in noun form>" >&2
  echo "例: feat ✨: Wezterm設定の追加" >&2
  echo "例: fix 🐛: Zsh補完設定の修正" >&2
  echo "例: perf ⚡: Sheldonプラグイン起動の最適化" >&2
  echo "" >&2
  echo "現在のメッセージ: $commit_message" >&2
  echo '{
  "decision": "block",
  "reason": "Invalid commit message format. Expected: <type> <emoji>: <Japanese message in noun form>"
}'
  exit 1
fi

# 有効なtype一覧
valid_types=("feat" "fix" "docs" "style" "refactor" "perf" "test" "chore" "ci" "build" "revert")

# typeを抽出
type=$(echo "$commit_message" | cut -d' ' -f1)

# typeの妥当性チェック
type_found=false
for valid_type in "${valid_types[@]}"; do
  if [ "$type" = "$valid_type" ]; then
    type_found=true
    break
  fi
done

if [ "$type_found" = false ]; then
  echo "❌ エラー: 無効なtype '$type' です" >&2
  echo "有効なtype: ${valid_types[*]}" >&2
  echo '{
  "decision": "block",
  "reason": "Invalid commit type '"$type"'. Valid types: '"${valid_types[*]}"'"
}'
  exit 1
fi

# 絵文字の存在チェック（UTF-8文字で判定）
emoji=$(echo "$commit_message" | cut -d' ' -f2)
if [ -z "$emoji" ] || [ "$emoji" = ":" ]; then
  echo "❌ エラー: 絵文字が含まれていません" >&2
  echo "type '$type' の後に適切な絵文字を追加してください" >&2
  echo "例: feat ✨, fix 🐛, docs 📚, perf ⚡" >&2
  echo '{
  "decision": "block",
  "reason": "Missing emoji after type '"$type"'. Examples: feat ✨, fix 🐛, docs 📚, perf ⚡"
}'
  exit 1
fi

# 絵文字が有効なUnicodeかチェック
if ! echo "$emoji" | grep -qP '\p{So}|\p{Sm}|\p{Sc}|\p{Sk}' 2>/dev/null; then
  # grepでUnicodeサポートがない場合の代替チェック
  emoji_byte_length=$(echo -n "$emoji" | wc -c | tr -d ' ')
  if [ "$emoji_byte_length" -lt 3 ]; then
    echo "❌ エラー: 有効な絵文字が含まれていません" >&2
    echo "type '$type' の後に適切な絵文字を追加してください" >&2
    echo "例: feat ✨, fix 🐛, docs 📚, perf ⚡" >&2
    echo '{
  "decision": "block",
  "reason": "Invalid emoji after type '"$type"'. Please use valid emoji. Examples: feat ✨, fix 🐛, docs 📚, perf ⚡"
}'
    exit 1
  fi
fi

# コロンの存在チェック
if ! echo "$commit_message" | grep -q ': '; then
  echo "❌ エラー: コロンとスペース (': ') が見つかりません" >&2
  echo "正しい形式: <type> <emoji>: <message>" >&2
  echo '{
  "decision": "block",
  "reason": "Missing colon and space (': '). Correct format: <type> <emoji>: <message>"
}'
  exit 1
fi

# メッセージ部分の抽出と検証
message_part=${commit_message#*: }

# メッセージが空でないかチェック
if [ -z "$message_part" ]; then
  echo "❌ エラー: メッセージ部分が空です" >&2
  echo '{
  "decision": "block",
  "reason": "Empty message part. Please provide meaningful commit message."
}'
  exit 1
fi

# メッセージの長さチェック（50文字以下を推奨）
if [ ${#message_part} -gt 50 ]; then
  echo "⚠️  警告: メッセージが長すぎます (${#message_part}文字)" >&2
  echo "推奨: 50文字以下" >&2
fi

echo "✅ Git commitコマンドの検証が完了しました" >&2
echo "GPG署名: ✅" >&2
echo "Type: $type" >&2
echo "Emoji: $emoji" >&2
echo "Message: $message_part" >&2

echo '{
  "decision": "approve",
  "reason": "Valid git commit command with GPG signing and proper message format: '"$type $emoji: $message_part"'"
}'

exit 0