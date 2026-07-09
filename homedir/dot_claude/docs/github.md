# GitHub

GitHubリソースへのアクセスとツール選択のルール。

## ツールの優先順位

アクセスの種類によって優先順位が変わる。

1. 外部リポジトリの調査（コードベース・API・アーキテクチャ・設計の理解）→ `deepwiki` MCPを優先、`gh` CLIにフォールバック。
2. 外部リポジトリのファイルを実際に読む → ローカルクローンを読む（後述）。
3. 特定のGitHubリソース（Issue、PR、リリース、ワークフローrun、API呼び出し）→ `gh` CLI。
4. GitHubページに `WebFetch` を使わない。

## 外部リポジトリの調査: `deepwiki` MCPを優先

外部GitHubリポジトリについての調査的な問い（どう動くか、APIが何をするか、ある機能がどこに実装されているか）には、まず `deepwiki` を使う。リポジトリ全体をインデックスして1回の呼び出しで答えるため、ソースツリーを手で辿るより速く網羅的である。

利用できるツール:

- `mcp__deepwiki__read_wiki_structure` — リポジトリのドキュメントトピック一覧。
- `mcp__deepwiki__read_wiki_contents` — リポジトリの全ドキュメント。
- `mcp__deepwiki__ask_question` — リポジトリに関するAI Q&A。

読みたいファイルが最初から特定できている場合は、`deepwiki` を省いてクローンを読みに行く。

`deepwiki` が答えられない場合（プライベートリポジトリ、未インデックスのごく最近の変更等）はクローンを読むか `gh` CLIを使う。

## 外部リポジトリのファイルを読む: ローカルクローン

正確な現在のファイル内容が必要なときは、ghqのパス規約に沿ったローカルクローンを読む。`gh api .../contents/...` でファイルを1枚ずつ取得しない（Read・Grep・Globが使えず、参照が `file:line` で示せない）。

クローン先は `$(ghq root)/github.com/<owner>/<repo>`。`ghq` が無い環境でも同じパスに置く（`ghq root` は `~/git` として扱う）。

### 未クローンのとき

```bash
ghq get <owner>/<repo>
# ghqが無い環境（勝手にインストールしない）
git clone https://github.com/<owner>/<repo> ~/git/github.com/<owner>/<repo>
```

### クローン済みのとき

既存クローンはユーザーの作業リポジトリでありうる。**そのワークツリーのHEAD・未コミット変更に触れない**。fetchで最新化し、読み取り専用のワークツリーを別に生やして読む。

ワークツリーは対象リポジトリの外、`~/.cache/agent-worktrees/<owner>/<repo>/` 配下に置く。リポジトリ内に置くとGrep・Globが二重ヒットし、ビルドにも巻き込まれる。

置き場は `mktemp -d` で一意化する。並行セッションが同じリポジトリ・同じブランチを読んでも衝突しない。ブランチ名に含まれる `/` は `-` に潰す。

gitリポジトリ:

```bash
cd ~/git/github.com/<owner>/<repo>
git worktree prune                       # 残骸の管理ファイルを回収
git fetch origin
mkdir -p ~/.cache/agent-worktrees/<owner>/<repo>
D=$(mktemp -d ~/.cache/agent-worktrees/<owner>/<repo>/<branch>-XXXXXX)
git worktree add --detach "$D/tree" origin/<branch>
# "$D/tree" 以下を読む
git worktree remove --force "$D/tree"
rm -rf "$D"
```

jjリポジトリ（`.jj` あり）はjjコマンドで扱う。ワークスペース名も `$(basename "$D")` で一意にする。

```bash
cd ~/git/github.com/<owner>/<repo>
jj workspace list                        # 実体の無いワークスペースを forget して回収
jj git fetch
mkdir -p ~/.cache/agent-worktrees/<owner>/<repo>
D=$(mktemp -d ~/.cache/agent-worktrees/<owner>/<repo>/<branch>-XXXXXX)
jj workspace add --name "$(basename "$D")" -r '<branch>@origin' "$D/tree"
# "$D/tree" 以下を読む
jj workspace forget "$(basename "$D")"
rm -rf "$D"
```

`$D/tree` は事前に作らず、`add` に生成させる。

### ワークツリーの後始末

読み終えたらワークツリーを必ず撤去する。撤去前にセッションが落ちれば残るため、**新たに作る前に**回収を走らせる（gitは `git worktree prune`、jjは `jj workspace list` で実体の無いものを `jj workspace forget`）。

ディレクトリの実体が残った孤児は `~/.cache/agent-worktrees/` に集まる。他セッションが読んでいる最中でありうるので、自分が作った `$D` 以外は消さない。

## GitHubリソースは `gh` CLIで

Issue、PR、リリース、ワークフローrun、API呼び出しには、`WebFetch` でなく `gh` を使う。

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

# 誤り — ファイル内容をAPIで1枚ずつ取る
gh api repos/owner/repo/contents/src/auth.go

# 正しい — ファイルはローカルクローンをReadする
ghq get owner/repo
# ~/git/github.com/owner/repo/src/auth.go を読む

# 正しい — 特定リソースはgh
gh issue view 123 --repo owner/repo
gh pr view 456 --repo owner/repo
```

GitHub CLIのコマンド詳細を扱うスキルがあれば使う。
