# dotfiles Design Doc

chezmoiを使用したmacOSとLinuxの開発環境を宣言的に構築するdotfilesの設計。

## スコープと非スコープ

### スコープ

- macOSとdebian系Linuxを対象
- OS設定とアプリケーション設定の管理方法
- パッケージ管理方法
- シークレット管理方法

### 非スコープ

- 導入するアプリケーションの選定

## 目次

| ドキュメント | 内容 |
| --- | --- |
| [設計原則](./principles.md) | 全体を通しての原則 |
| [全体アーキテクチャ](./architecture.md) | ディレクトリ構成、命名規約、プラットフォーム分岐 |
| [パッケージ管理](./packages.md) | OSごとのパッケージ管理 |
| [シークレット管理](./secrets.md) | シークレットの暗号化 |
| [ブートストラップ](./bootstrap.md) | run_onceとrun_onchangeの規約、システム設定とログイン項目の適用 |
| [運用](./operations.md) | 設定追加、適用方法、新環境セットアップ |
