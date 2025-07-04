#!/bin/bash

# コミットメッセージ検証スクリプト
# Conventional Commits + Gitmoji 形式をチェックします
# 形式: <type> <emoji>: <Japanese message in noun form>

# 標準入力からコミットメッセージを取得
full_message=$(cat)
commit_message=$(echo "$full_message" | head -n 1)

# デバッグ情報出力
echo "DEBUG: Full message: '$full_message'" >&2
echo "DEBUG: Commit message: '$commit_message'" >&2

# 空のメッセージチェック
if [ -z "$commit_message" ]; then
  echo "❌ エラー: コミットメッセージが空です"
  exit 1
fi

# 改行チェック
line_count=$(echo "$full_message" | wc -l | tr -d ' ')
if [ "$line_count" -gt 1 ]; then
  echo "❌ エラー: コミットメッセージに改行が含まれています"
  echo "コミットメッセージは1行で記述してください"
  echo "現在の行数: $line_count 行"
  exit 1
fi

# 基本パターンチェック
# 形式: <type> <emoji>: <message>
if ! echo "$commit_message" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert) [^\s]+: .+'; then
  echo "❌ エラー: コミットメッセージの形式が正しくありません"
  echo "正しい形式: <type> <emoji>: <Japanese message in noun form>"
  echo "例: feat ✨: Wezterm設定の追加"
  echo "例: fix 🐛: Zsh補完設定の修正"
  echo "例: perf ⚡: Sheldonプラグイン起動の最適化"
  echo ""
  echo "現在のメッセージ: $commit_message"
  exit 1
fi

# 有効なtype一覧
valid_types=("feat" "fix" "docs" "style" "refactor" "perf" "test" "chore" "ci" "build" "revert")

# typeを抽出
type=$(echo "$commit_message" | cut -d' ' -f1)

# typeの妥当性チェック
if [[ ! " ${valid_types[@]} " =~ " ${type} " ]]; then
  echo "❌ エラー: 無効なtype '$type' です"
  echo "有効なtype: ${valid_types[*]}"
  exit 1
fi

# 絵文字の存在チェック（UTF-8文字で判定）
emoji=$(echo "$commit_message" | cut -d' ' -f2)
if [ -z "$emoji" ] || [ "$emoji" = ":" ]; then
  echo "❌ エラー: 絵文字が含まれていません"
  echo "type '$type' の後に適切な絵文字を追加してください"
  echo "例: feat ✨, fix 🐛, docs 📚, perf ⚡"
  exit 1
fi

# 絵文字が有効なUnicodeかチェック
if ! echo "$emoji" | grep -qP '\p{So}|\p{Sm}|\p{Sc}|\p{Sk}' 2>/dev/null; then
  # grepでUnicodeサポートがない場合の代替チェック
  emoji_byte_length=$(echo -n "$emoji" | wc -c | tr -d ' ')
  if [ "$emoji_byte_length" -lt 3 ]; then
    echo "❌ エラー: 有効な絵文字が含まれていません"
    echo "type '$type' の後に適切な絵文字を追加してください"
    echo "例: feat ✨, fix 🐛, docs 📚, perf ⚡"
    exit 1
  fi
fi

# コロンの存在チェック
if ! echo "$commit_message" | grep -q ': '; then
  echo "❌ エラー: コロンとスペース (': ') が見つかりません"
  echo "正しい形式: <type> <emoji>: <message>"
  exit 1
fi

# メッセージ部分の抽出と検証
message_part=$(echo "$commit_message" | sed 's/^[a-z]* [^:]*: //')

# メッセージが空でないかチェック
if [ -z "$message_part" ]; then
  echo "❌ エラー: メッセージ部分が空です"
  exit 1
fi

# メッセージの長さチェック（50文字以下を推奨）
if [ ${#message_part} -gt 50 ]; then
  echo "⚠️  警告: メッセージが長すぎます (${#message_part}文字)"
  echo "推奨: 50文字以下"
fi

echo "✅ コミットメッセージの形式が正しいです"
echo "Type: $type"
echo "Emoji: $emoji"
echo "Message: $message_part"

exit 0