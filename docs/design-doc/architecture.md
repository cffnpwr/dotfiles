# 全体アーキテクチャ

## ディレクトリ構成

[chezmoi](https://www.chezmoi.io/)のソースディレクトリをリポジトリ直下の`homedir`に置き、`.chezmoiroot`でこれをソースルートに指定する。
リポジトリ直下にはドキュメントやライセンスなどソース外のファイルを置き、ホームへ反映する対象は`homedir`配下に限定する。

```text
.
├─ .chezmoiroot          # ソースルートを homedir に指定
├─ docs/                 # 設計ドキュメント
├─ README.md / LICENSE   # リポジトリのメタ情報
└─ homedir/              # chezmoi ソースルート
   ├─ .chezmoi.toml.tmpl # apply時の変数定義
   ├─ .chezmoidata/      # OS別パッケージなどのデータ
   ├─ .chezmoiscripts/   # ブートストラップスクリプト
   ├─ .chezmoiignore     # 配置除外の指定
   ├─ dot_config/        # 各種設定ファイル
   ├─ private_dot_ssh/   # SSH設定
   └─ encrypted_*        # 暗号化された秘密情報
```

## 命名規約

ソース内ファイルの命名規約は[chezmoiの仕様](https://www.chezmoi.io/reference/source-state-attributes/)に従う。
本リポジトリ固有の命名規約を設ける場合のみここに追記する。スクリプトの採番のように個別領域に閉じた規約は、該当する節で定める。

## プラットフォーム分岐

OS差分はテンプレートとデータで吸収する。テンプレートは`.chezmoi.os`などの組み込み変数で分岐し、macOSとdebian系Linuxで内容を出し分ける。
パッケージのようにOSごとに集合が異なるデータは、`.chezmoidata`にOS単位で定義し、スクリプトとテンプレートから参照する。
