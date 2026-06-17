# GitHub

GitHubリソースへのアクセスとツール選択のルール。

## ツールの優先順位

アクセスの種類によって優先順位が変わる。

1. 外部リポジトリの調査（コードベース・API・アーキテクチャ・設計の理解）→ `deepwiki` MCPを優先、`gh` CLIにフォールバック。
2. 特定のGitHubリソース（Issue、PR、リリース、ワークフローrun、API呼び出し）→ `gh` CLI。
3. GitHubページに `WebFetch` を使わない。

## 外部リポジトリの調査: `deepwiki` MCPを優先

外部GitHubリポジトリについての調査的な問い（どう動くか、APIが何をするか、ある機能がどこに実装されているか）には、まず `deepwiki` を使う。リポジトリ全体をインデックスして1回の呼び出しで答えるため、ソースツリーを手で辿るより速く網羅的である。

利用できるツール:

- `mcp__deepwiki__read_wiki_structure` — リポジトリのドキュメントトピック一覧。
- `mcp__deepwiki__read_wiki_contents` — リポジトリの全ドキュメント。
- `mcp__deepwiki__ask_question` — リポジトリに関するAI Q&A。

次の場合は `gh` CLIにフォールバックする。

- `deepwiki` が答えられない（プライベートリポジトリ、未インデックスのごく最近の変更等）。
- 正確な現在のファイル内容、コミット履歴、特定のGitHubオブジェクトが必要。

## GitHubリソースは `gh` CLIで

Issue、PR、リリース、ワークフローrun、生のファイル内容、API呼び出しには、`WebFetch` でなく `gh` を使う。

### なぜ

GitHubページはクライアントサイドレンダリング（JavaScript）を使う。`WebFetch` はJavaScriptを実行せず生のHTMLを取得するため、内容が欠落するか空になりうる。`gh` はGitHub APIを直接呼び、完全で構造化されたデータを返す。

### 例

```bash
# 誤り — JavaScriptが実行されず内容が欠落
WebFetch("https://github.com/owner/repo/issues/123")

# 誤り — 調査的な問いにはdeepwikiを使う
gh api repos/owner/repo/contents/src/auth.go  # その後20ファイル読んで認証を理解

# 正しい — 調査的な問いはdeepwiki
mcp__deepwiki__ask_question(repoName="owner/repo", question="How is authentication implemented?")

# 正しい — 特定リソースはgh
gh issue view 123 --repo owner/repo
gh pr view 456 --repo owner/repo
gh api repos/owner/repo/contents/path/to/file.md
```

GitHub CLIのコマンド詳細を扱うスキルがあれば使う。
