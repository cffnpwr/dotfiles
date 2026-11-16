# Dotfiles for cffnpwr

個人用のdotfilesです。
[Nix](https://nixos.org/)を使って管理しています。

## How to use

### How to install

macOSではMac App Storeのアプリの導入にApp Storeへのサインインが必要なため、App Storeにサインインしてから以下のコマンドを実行します。

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/cffnpwr/dotfiles/main/install.sh)" -- [-b|--branch <branch>] [--host <host>]
```

### How to update

dotfilesの導入後はmiseを使用して操作が可能です。

```bash
# flake.lockの更新
mise update
# dotfilesのビルド
mise build
# dotfilesの適用
mise apply
```

## License

[MIT License](./LICENSE)
