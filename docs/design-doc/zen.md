# Zen Browser の宣言管理

Zen Browser の状態を`homedir/.chezmoidata/zen.yaml`で宣言し、run_onchange スクリプトで適用する。
対象は拡張機能の policy と、spaces / pins(essential タブ)の2系統。

| 対象 | データ | スクリプト |
| --- | --- | --- |
| 拡張機能の policy | `zen.extensions` | `run_onchange_85_darwin_zen-policies.sh.tmpl` |
| spaces / pins | `zen.spaces` / `zen.pins` | `run_onchange_86_darwin_zen-sessions.sh.tmpl` |

本節は拡張機能の policy 適用を扱う。spaces / pins のマージ仕様はスクリプト本文のコメントに従う。

## macOS の policy ソース: CFPreferences を正準とする

Zen は Firefox 系の enterprise policy を持ち、macOS では policy ソースが2つある。

- バンドル内 `Zen.app/Contents/Resources/distribution/policies.json`
- アプリの CFPreferences(`app.zen-browser.zen` の user defaults)

CFPreferences 側の policy を有効化するには`EnterprisePoliciesEnabled`を true にする必要がある([mozilla/policy-templates mac/README](https://github.com/mozilla/policy-templates/blob/master/mac/README.md))。
また優先順位は CFPreferences 側が上で、CFPreferences で policy が有効な間は policies.json は参照されない([Manage policies on macOS desktops](https://support.mozilla.org/en-US/kb/managing-policies-macos-desktops))。

**決定: CFPreferences を単一の正準ソースとし、policies.json は配置しない。** 理由は次の3点。

- macOS で実際に優先されるのは CFPreferences 側であり、両ソースが併存すると古い CFPreferences がバンドル側の更新を打ち消す(旧 home-manager から移行した実機で発生)。
- user defaults は Zen / brew の更新で消えない。バンドル内 policies.json はアプリ更新で消えるため再配置が要り、タイミング次第で欠落する。
- 毎 apply で`ExtensionSettings`辞書を全体置換するため、既存環境に残った古い policy を確実に打ち消せる。

適用は `run_onchange_85` が担う。

- `defaults write app.zen-browser.zen EnterprisePoliciesEnabled -bool true`
- `defaults write app.zen-browser.zen ExtensionSettings <plist>`(`ExtensionSettings`キーの全体置換)
- 旧方式で置いたバンドル内 policies.json があれば削除する。

## 有効/無効の宣言と installation_mode

`ExtensionSettings`の`installation_mode`は4値([ExtensionSettings](https://mozilla.github.io/policy-templates/#extensionsettings))。

| 値 | 挙動 |
| --- | --- |
| `allowed` | ユーザーの手動導入を許可(既定) |
| `blocked` | 導入を阻止し、既に入っていれば削除する |
| `force_installed` | 自動導入し、ユーザーによる削除・無効化を禁止する |
| `normal_installed` | 自動導入するが、ユーザーが無効化できる |

**「導入したまま無効」に相当するモードは存在しない。** よって`zen.yaml`の`enabled`は次のように写す。

- `enabled: true`(既定) → `force_installed`
- `enabled: false` → `blocked`

「無効」は policy 上「削除 + 導入阻止」で表す。UI で灰色にして残す挙動は policy では表現できない。

## スキーマ: extId 一本化

各エントリは`extId`と`enabled`を持つ。

- `extId`: AMO の addon ID。`ExtensionSettings`のキーと`install_url`の両方に使う。
- `enabled`: 有効/無効の宣言。省略時は true。

`install_url`は`extId`から組む。

```
https://addons.mozilla.org/firefox/downloads/latest/<extId>/latest.xpi
```

latest.xpi エンドポイントは addon ID(GUID や`@`形式の id)をそのまま受け付ける([ExtensionSettings](https://mozilla.github.io/policy-templates/#extensionsettings))。GUID は`{...}`の中括弧を含めて渡す。
以前は AMO スラッグを`pluginId`として別に持っていたが、`extId`で URL を組めるため廃止した(スラッグ検索の手間を省く)。

## extId の引き方

addon ID は次のいずれかで確認する。

1. Zen で導入済みなら`about:debugging`(または`about:support`)の拡張一覧に内部 ID が出る。
2. AMO API で引く。中括弧は`%7B`/`%7D`にエンコードする。`guid`フィールドが`extId`。

   ```sh
   curl -sS "https://addons.mozilla.org/api/v5/addons/addon/<id-or-slug-or-guid>/" \
     | python3 -c 'import sys,json;print(json.load(sys.stdin)["guid"])'
   ```

3. 検証: 次が xpi へリダイレクトすれば正しい。

   ```sh
   curl -gsSI "https://addons.mozilla.org/firefox/downloads/latest/<extId>/latest.xpi"
   ```

## 旧 home-manager からの移行

旧構成は同じ CFPreferences(`app.zen-browser.zen`)に`EnterprisePoliciesEnabled`/`ExtensionSettings`を書いていた。
新構成も同じ domain を全体置換するため、通常は再 apply で収束する。
既存プロファイルの拡張 DB 不整合で「導入済みだが無効・有効化不能」が残る場合は、CFPreferences の削除とプロファイル側の掃除が要る。これは1回限りの手作業とする。

## 適用と確認

反映は chezmoi の通常フロー([運用](./operations.md)、[chezmoi スキル](../../.claude/skills/chezmoi/SKILL.md))に従う。適用後は次で確認する。

```sh
defaults read app.zen-browser.zen EnterprisePoliciesEnabled
defaults read app.zen-browser.zen ExtensionSettings
```
