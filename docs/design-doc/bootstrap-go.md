# ブートストラップのGo実装

ブートストラップスクリプトの本体ロジックを、リポジトリ直下のGoモジュール`tools/bootstrap/`に実装する。
`.chezmoiscripts`のスクリプトは薄いラッパーに縮退させ、go templateとシェルロジックの交錯を排する。
宣言データの処理は型付き構造体で表現し、`go test`によるユニットテストで担保する。
スクリプトの分類（`run_`/`run_onchange`）と実行順序の規約は[ブートストラップ設計](./bootstrap.md)に従い、本書は実装形態のみを定める。

## 構成

| 場所 | 役割 |
| --- | --- |
| `tools/bootstrap/` | Goモジュール。単一のmainパッケージで、段階ごとのサブコマンドを持つ |
| `homedir/.chezmoiscripts/run_*.sh.tmpl` | ラッパー。OSゲート・変更検知対象の展開・データファイルパスとフラグの受け渡し・Goの起動のみを担う |

`tools/`はchezmoiのソースルート（`homedir/`）の外にあるため、chezmoiはこれをホームディレクトリへ反映しない。

## 実行方式

ラッパーは次の形とする。

```bash
#!/usr/bin/env bash
set -euo pipefail
{{ includeTemplate "path.sh" . }}

{{ $data := list ".chezmoidata/packages.yaml" ".chezmoidata/ignore.yaml" -}}
# data hash: {{ range $data }}{{ include . | sha256sum }} {{ end }}
# {{ includeTemplate "go-sources-hash.tmpl" . }}
exec go run "$CHEZMOI_WORKING_TREE/tools/bootstrap" <サブコマンド> --os {{ .os }}{{ range $data }} "$CHEZMOI_SOURCE_DIR/{{ . }}"{{ end }}
```

- `CHEZMOI_WORKING_TREE`はchezmoiがスクリプト実行時に設定する環境変数で、ソースのgitワークツリー（このリポジトリのcloneのルート）を指す。
  `~/.local/share/chezmoi`からのapplyでも`--source`指定のapplyでも、実行に使ったclone自身の`tools/`を指す
- PATHは既存の共有テンプレート`path.sh`で解決し、`go`はその上で探索する
- Goツールチェーンは20段（パッケージマネージャー・最小パッケージの導入）で導入する。
  macOSはHomebrew導入後に`brew install go`、debianは最小パッケージへの追加で導入する

## データの受け渡し

宣言データは`.chezmoidata`のYAMLファイルパスを引数で渡し、GoがYAMLを型付き構造体へデコードする。
`.os`などconfig由来の変数（`.chezmoi.toml.tmpl`で判定）はフラグで渡し、OS判定の単一情報源を保つ。

- サブコマンドが読むデータファイルは、ラッパー内の単一のリスト変数（例の`$data`）で宣言する。
  変更検知用のハッシュ行と引数の両方をこのリストから生成するため、両者は食い違わない。
  列挙が漏れたファイルは引数からも漏れるため、沈黙した検知漏れにならずデータ欠落として実行時に顕在化する
- Goが宣言データの実ファイルを直接読むため、テストも同じYAMLを入力にできる

## 変更検知

`run_onchange`はレンダリング後のスクリプト本文の変化で再実行を判定する。
追従すべき変更は3種類ある。

- 宣言データの変更: リスト変数から生成するハッシュ行（`include`＋`sha256sum`）で検知する
- config由来の変数の変更: フラグ値の本文展開で検知する
- Goソースの変更: 全Goソースと`go.mod`・`go.sum`のハッシュを展開して検知する

Goソースのハッシュは共有テンプレート`.chezmoitemplates/go-sources-hash.tmpl`に置き、Go化した全ラッパーから`includeTemplate`で参照する。

```text
{{ range glob (joinPath .chezmoi.workingTree "tools/bootstrap/**/*.go") }}{{ include . | sha256sum }}{{ end }}{{ range glob (joinPath .chezmoi.workingTree "tools/bootstrap/go.*") }}{{ include . | sha256sum }}{{ end }}
```

実体状態のフィンガープリント（`darwin-package-state.tmpl`・`darwin-outdated-state.tmpl`）は変更検知のみを担うため、現行のままラッパーに残す。

## OS分岐

- 両OSに存在する段はラッパー1本とし、標準入力の`os`（`darwin`/`debian`）によりGoの内部で分岐する。
  ファイル名からOSトークンを外す（例: `run_onchange_40_install-packages.sh.tmpl`）
- 片OS専用の段は現行どおりラッパー全体を`{{ if eq .os "..." }}`で囲む。
  テンプレート展開の結果が空のスクリプトをchezmoiは実行しない

テンプレートによる空化とGoの内部の分岐は役割が異なり、前者は段の存否を、後者は挙動のOS差を担う。
存在しない段のスクリプトを生成しないことで、無関係なOSでの`go run`の起動と`run_onchange`状態の管理を避ける。

## 移行範囲

| スクリプト | 扱い | 根拠 |
| --- | --- | --- |
| `run_onchange_before_10_decrypt-key` | シェルのまま | before段はファイル適用より前に走り、Go導入（20段）に先行する |
| `run_20_darwin_install-homebrew`・`run_20_debian_bootstrap` | シェルのまま | Goを導入する段自身のため |
| 25段以降の全スクリプト | Go化 | 20段の完了によりGoが利用可能 |

25段以降はロジック量の多少にかかわらず一律でGo化し、実行形態を統一する。

## テスト

- 宣言データの解釈と生成物（Brewfile・launchd plist・systemd unit・defaults設定列など）の構築は純粋関数として実装し、`go test`でユニットテストする
- 外部コマンドの実行（brew・launchctl・systemctlなど）は実行層として分離し、テストでは差し替える

## 制約

- Goモジュールの外部依存はYAMLデコーダー1つに限る。
  初回の`go run`はその取得にネットワークを使う
- `go.mod`の`go`ディレクティブは、両OSのパッケージ導入手段で入るGoのバージョン以下に保つ
- `go run`は初回実行とGoソース変更後の実行でコンパイルを伴う。
  それ以外はビルドキャッシュが効く
