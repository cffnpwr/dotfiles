# dotfiles for cffnpwr

## 概要

[Nix](https://nixos.org/)でmacOSとLinuxの開発環境を宣言的に構築する個人用dotfiles。
macOSは[nix-darwin](https://github.com/nix-darwin/nix-darwin)と[home-manager](https://github.com/nix-community/home-manager)、Linuxはhome-managerで構成する。

## ディレクトリ構成

- `flake.nix`: inputsと、`modules/`を読み込むoutputsだけを書く
- `modules/`: flake-partsのモジュール。import-treeが全ファイルを読み込む
  - `modules/core/`: ソフトウェア単位ではない機能
  - `modules/users/<name>.nix`: ユーザー情報とLinuxのhome-managerの構成
  - `modules/hosts/<hostname>.nix`: macOSのホストの構成
  - `modules/programs/<category>/`: ソフトウェアの導入と設定
- `secrets/`: agenixで暗号化したファイル
- `docs/runbook/`: 手順書

## 編集と反映

- flakeはGitで追跡しているファイルだけを読み込む。新しく作成したファイルは評価・適用の前に`git add`する
- 評価・ビルドの確認は`darwin-rebuild build --flake .#<hostname>`で行なう。適用（`darwin-rebuild switch`）はHomebrewのパッケージの導入・削除などシステムを変更するため、ユーザーの許可を得てから行なう
- `modules/`配下のファイル名がパスに`/_`を含む場合、import-treeはそのファイルを読み込まない。`default.nix`から`import`するファイルは名前を`_`で始める
- 変更したNixのファイルは`nix fmt`で整形する

## バージョン管理

- **mainへの直接pushを許可する。** 軽微な更新が多いため、フィーチャーブランチ・PRを必須にしない

## 規約・制約

- 設定はこのリポジトリのNix式を編集して反映する。ホームの設定ファイルを直接編集しない
- 設定はhome-managerのモジュールのオプションまたは`pkgs.formats`のNix式で書く。Nix式で表現できないファイルだけをモジュールの隣に置く
- 1つのソフトウェアの導入と設定（nix-darwin・home-manager）を1つのファイルにまとめる
- パッケージはnixpkgsから導入する。nixpkgsに無い・更新が止まっている場合に限り、他の手段を使う
- リポジトリに含める秘密情報はagenixで暗号化し、平文では置かない
