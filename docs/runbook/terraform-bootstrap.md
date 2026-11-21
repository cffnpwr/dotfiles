# Terraformのbootstrap

`terraform/bootstrap/`をローカルでapplyして、CIが使うリソースを作成する。

## Prerequisites

- `mise install`でツールをインストール済み
- `gh auth login`でGitHubにログイン済み

## Terraformのroot

bootstrapのstateにはCIの認証情報が入るため、CIが実行する`terraform/`とrootを分けている。

| root | 実行する場所 | 管理するリソース |
| --- | --- | --- |
| `terraform/bootstrap/` | ローカル | tfstate用のR2 Bucket・GitHubのenvironmentとCIの認証情報・CIのplanが使うCloudflareのトークン |
| `terraform/` | CI | Nixのバイナリキャッシュ用のR2 Bucket・custom domain・アップロード用のトークン・`nix-cache`のenvironmentのsecret |

tfstateはR2 Bucketの`dotfiles-tfstate`にSSE-Cで暗号化した状態で保存する。

## 用意するもの

### GitHub App

CIは3つのGitHub Appのトークンを使う。
CIのplan・applyはcffnpwr/home-iacのCIと共有する2つのGitHub Appを使う。
2つのGitHub Appの定義はcffnpwr/actionsの[`modules/github-app/apps/`](https://github.com/cffnpwr/actions/tree/main/modules/github-app/apps)にある。
`.github/workflows/flake-lock.yaml`は、RenovateのPRに`flake.lock`の更新をコミットするためにGitHub Appを使う。
このGitHub AppにはContentsの書き込み権限が必要である。

| 種類 | GitHub App | Client IDと秘密鍵の登録先 |
| --- | --- | --- |
| `plan` | `cffnpwr-terraform-plan` | `terraform-plan`の`PLAN_APP_CLIENT_ID`・`PLAN_APP_PRIVATE_KEY` |
| `apply` | `cffnpwr-terraform-apply` | `terraform-apply`の`APPLY_APP_CLIENT_ID`・`APPLY_APP_PRIVATE_KEY` |
| `flake-lock` | `cffnpwr-update-bot` | `flake-lock`の`FLAKE_LOCK_APP_CLIENT_ID`・`FLAKE_LOCK_APP_PRIVATE_KEY` |

`renovate.json`の`gitIgnoredAuthors`には`cffnpwr-update-bot`のbotユーザーのメールアドレスを書いている。
`flake-lock`で別のGitHub Appを使う場合は、`gitIgnoredAuthors`をそのGitHub Appのbotユーザーのメールアドレスに変更する。

plan・apply用のGitHub Appが無い場合はcffnpwr/actionsの[create-github-app](https://github.com/cffnpwr/actions/tree/main/modules/github-app)の手順で作成する。
GitHub Appが既にある場合は3つのGitHub Appごとに次の手順を行なう。

1. GitHub Appのinstallationに`dotfiles`を追加する。
   個人アカウントのinstallationにはAPIでリポジトリを追加できないため、設定画面で行なう
   1. GitHubの「Settings」で「Applications」を開き、「Installed GitHub Apps」を選ぶ
   2. 対象のGitHub Appの「Configure」を選ぶ
   3. 「Repository access」で「Only select repositories」を選び、「Select repositories」で`dotfiles`を追加する
   4. 「Save」を選ぶ
2. GitHub Appの設定画面の「Key pairs」で「New key」を選び、dotfiles用の秘密鍵を作成する
3. GitHub Appの設定画面に表示されたClient IDを確認する

### Cloudflareのトークン

Cloudflareのダッシュボードでアカウントのトークン（Account API Tokens）を2つ作成する。
`terraform-bootstrap`はアカウントのトークンの検証APIでトークンのIDを取得するため、アカウントのトークン以外は使えない。
CIのapply用のトークンにはAccount API Tokens Writeの権限が必要である。
APIで作成したトークンにはこの権限を付けられないため、CIのapply用のトークンもダッシュボードで作成する。

bootstrap用のトークンには`terraform/bootstrap/`が管理するリソースに合わせて次の権限を付ける。

| 権限 | 使うリソース |
| --- | --- |
| Account API Tokens Write | CIのplan用のトークンの作成・権限グループの取得 |
| Workers R2 Storage Write | tfstate用のR2 Bucket・bootstrapのstate |
| Zone Read | `cffnpwr.dev`のゾーンの取得 |

CIのapply用のトークンには`terraform/`が管理するリソースに合わせて次の権限を付ける。

| 権限 | 使うリソース |
| --- | --- |
| Account API Tokens Write | アップロード用のトークンの作成・権限グループの取得 |
| Workers R2 Storage Write | Nixのバイナリキャッシュ用のR2 Bucket・`terraform/`のstate |
| Zone Read | `cffnpwr.dev`のゾーンの取得 |

custom domain・Object lifecycles・Bucket locksの設定に必要な権限は、CloudflareのAPIのドキュメントに記載がない。

### SSE-Cの鍵

bootstrapのstateを暗号化するSSE-Cの鍵は、`terraform/bootstrap/sse-customer-key.age`にageで暗号化して置く。
初回のapplyの前に次のコマンドで鍵を生成する。
宛先（recipient）は`terraform/bootstrap/recipients.yaml`のConfigMapの`data["recipients.txt"]`に1行ずつ書いてある。
生成した`sse-customer-key.age`はコミットする。

```sh
mise run tf:bootstrap:generate-sse-customer-key
```

### ageのidentityファイル

`terraform-bootstrap`は`AWS_SSE_CUSTOMER_KEY`が未設定の場合に`sse-customer-key.age`を復号してSSE-Cの鍵にする。
復号には`AGE_IDENTITY_FILE`のidentityファイルを使う。
`AGE_IDENTITY_FILE`の相対パスはリポジトリのルートを基準にする。

`recipients.txt`の宛先は次の2つで、どちらか1つのidentityがあれば復号できる。

| 宛先の接頭辞 | 鍵の場所 | identityファイルの作り方 |
| --- | --- | --- |
| `age1yubikey1` | YubiKeyのPIVの鍵 | YubiKeyを接続し、`age-plugin-yubikey --identity > <ファイル>`を実行する |
| `age1tag1` | 鍵を作成したMacのSecure Enclave | `age-plugin-se keygen -o <ファイル>`で鍵を作成したときの`<ファイル>`を使う |

identityファイルだけでは復号できず、参照先の鍵が必要である。
このため、YubiKeyを使う場合は鍵のあるYubiKeyを接続して`mise run tf:bootstrap`を実行する。
Secure Enclaveを使う場合は、鍵を作成したMacで`mise run tf:bootstrap`を実行する。

### Nixの署名鍵

CIがNixのバイナリキャッシュにアップロードするストアパスは、Nixの署名鍵で署名する。
次のコマンドで秘密鍵を生成し、公開鍵を表示する。
`--key-name`の値は公開鍵の接頭辞になる。

```sh
nix key generate-secret --key-name nix-cache.cffnpwr.dev-1 > <秘密鍵のパス>
nix key convert-secret-to-public < <秘密鍵のパス>
```

秘密鍵は`TF_VAR_nix_signing_key`で`terraform/bootstrap/`に渡す。
`terraform/bootstrap/`は、この秘密鍵を`nix-cache`の`NIX_SIGNING_KEY`に登録する。
公開鍵は`flake.nix`の`nixConfig`の`extra-trusted-public-keys`に書く。

## 環境変数

`mise run tf:bootstrap`はcffnpwr/actionsの`terraform-bootstrap`を経由して`terraform`を実行する。
`terraform-bootstrap`は`CLOUDFLARE_API_TOKEN`のトークンからS3 backendの認証情報を作る。
タスクは`go run`で`terraform-bootstrap`を実行するため、`terraform`が0以外の終了ステータスで終了すると、タスクは終了ステータス1で終了する。

| 環境変数 | 内容 |
| --- | --- |
| `CLOUDFLARE_API_TOKEN` | bootstrap用のCloudflareのトークン |
| `AGE_IDENTITY_FILE` | `sse-customer-key.age`を復号するageのidentityファイルのパス（`AWS_SSE_CUSTOMER_KEY`を設定する場合は不要） |
| `TF_VAR_cloudflare_api_token_apply` | `terraform-apply`の`CLOUDFLARE_API_TOKEN`に登録する、CIのapply用のCloudflareのトークン |
| `TF_VAR_plan_app_client_id` | `terraform-plan`の`PLAN_APP_CLIENT_ID`に登録する、plan用のGitHub AppのClient ID |
| `TF_VAR_plan_app_private_key` | `terraform-plan`の`PLAN_APP_PRIVATE_KEY`に登録する、plan用のGitHub Appの秘密鍵 |
| `TF_VAR_apply_app_client_id` | `terraform-apply`の`APPLY_APP_CLIENT_ID`に登録する、apply用のGitHub AppのClient ID |
| `TF_VAR_apply_app_private_key` | `terraform-apply`の`APPLY_APP_PRIVATE_KEY`に登録する、apply用のGitHub Appの秘密鍵 |
| `TF_VAR_flake_lock_app_client_id` | `flake-lock`の`FLAKE_LOCK_APP_CLIENT_ID`に登録する、flake.lockの更新用のGitHub AppのClient ID |
| `TF_VAR_flake_lock_app_private_key` | `flake-lock`の`FLAKE_LOCK_APP_PRIVATE_KEY`に登録する、flake.lockの更新用のGitHub Appの秘密鍵 |
| `TF_VAR_nix_signing_key` | `nix-cache`の`NIX_SIGNING_KEY`に登録する、Nixの署名鍵の秘密鍵 |

GitHub providerは`TF_VAR_github_token`・`GITHUB_TOKEN`環境変数のトークンを使う。
どちらも未設定の場合は`gh auth token`のトークンを使う。

## 初回のapply

bootstrapのstateを保存するR2 Bucketはbootstrapが作成する。
そのため、初回はローカルのbackendでapplyし、applyの後にstateをR2 Bucketへ移す。

1. [用意するもの](#用意するもの)を用意し、[環境変数](#環境変数)を設定する
2. `terraform/bootstrap/backend_override.tf`に次の内容を記載する。
   このファイルは`terraform/.gitignore`の`*_override.tf`でGitの管理から除外されている

   ```hcl
   terraform {
     backend "local" {}
   }
   ```

3. bootstrapをapplyする

   ```sh
   mise run tf:bootstrap init
   mise run tf:bootstrap plan
   mise run tf:bootstrap apply
   ```

4. `terraform/bootstrap/backend_override.tf`を削除する
5. stateをR2 Bucketへ移行し、ローカルのstateを削除する

   ```sh
   mise run tf:bootstrap init -migrate-state
   rm -f terraform/bootstrap/terraform.tfstate terraform/bootstrap/terraform.tfstate.backup
   ```

6. 変更をコミットし、mainブランチにpushする。
   `.github/workflows/terraform-apply.yaml`のworkflowが`terraform/`をapplyする
7. `terraform/`のapplyが成功した後に、`.github/workflows/nix.yaml`のworkflowが成功していることを確認する。
   同じpushで実行したNixのworkflowは、`nix-cache`のsecretが登録される前にアップロードを実行した場合に失敗する。
   失敗した場合はNixのworkflowを再実行する

## bootstrapの再実行

`terraform/bootstrap/`は次の値を更新する場合にローカルからapplyする。

- CIのapply用のCloudflareのトークン
- GitHub Appの秘密鍵
- Nixの署名鍵

新しい値を[環境変数](#環境変数)に設定してapplyする。
bootstrapの変数の値の変更はplanの差分になる。
Nixの署名鍵を変更した場合は、`flake.nix`の`extra-trusted-public-keys`の公開鍵も変更する。

```sh
mise run tf:bootstrap plan
mise run tf:bootstrap apply
```
