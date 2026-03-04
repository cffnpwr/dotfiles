---
status: accepted
date: 2026-03-05
---

# ADR-0002: VSCodeからZedへのエディタ移行

## コンテキスト

これまでメインエディタとしてVSCodeをNixのHome Managerで管理してきた。
VSCodeはElectronベースのため数GBのメモリを消費する。
そのため、マシンへの負荷が高いのでエディタをZedに移行し、Nixで宣言的に管理する方針を決定する必要がある。

## 検討した選択肢

### 選択肢1: VSCodeを継続使用

現状維持。

#### 良い点

- 移行コストがかからない
- 拡張機能エコシステムが成熟している

#### 悪い点

- Electronベースで起動・動作が重い

### 選択肢2: nixpkgsのZedパッケージを使用

`nixpkgs`に含まれる`pkgs.zed-editor`をそのまま使う。

#### 良い点

- 追加のFlake inputが不要
- nixpkgsのキャッシュ（`cache.nixos.org`）経由でバイナリが配布される可能性がある
- overlayによる即時ビルド問題が発生しない

#### 悪い点

- nixpkgsのパッケージは更新が遅延する（公式flake版との差: 約3バージョン）

### 選択肢3: 公式ZedのNix Flake Overlayを使用

`github:zed-industries/zed`をFlake inputとして追加し、`zed.overlays.default`を適用する。

#### 良い点

- 常に最新のZedを使用できる

#### 悪い点

- Flake inputが増える
- `aarch64-darwin`向けのバイナリキャッシュが存在せず、フルビルドが必要
- overlayの評価時点でビルドが即時実行されてしまう

## 決定

選択肢2（nixpkgsのZedパッケージ）を採用する。

公式overlayは`aarch64-darwin`向けのバイナリキャッシュが存在せずビルドが必須である上、
overlay評価時に即時ビルドが走る問題もある。
nixpkgs版との差は約3バージョンに留まり、実用上の影響は小さいと判断した。
VSCodeは拡張機能や設定の整理が完了するまで暫定的に共存させる。

## 結果

### 良い影響

- エディタの起動・動作が高速になる

### 悪い影響

- nixpkgsの更新タイミングに依存するため、最新バージョンの反映が数日〜数週間遅延する場合がある
