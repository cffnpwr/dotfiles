locals {
  cloudflare_account_id = "086a84b440e09bc83330fe07f1966f5d"
  # NOTE: アカウントトークンには説明を設定できないためダッシュボードで人が作成したトークンと名前で区別
  #       他のリポジトリが作成したトークンと区別するためリポジトリ名をprefixに付与
  cloudflare_account_token_name_prefix = "[managed by terraform] dotfiles/"
}

resource "cloudflare_r2_bucket" "tfstate" {
  account_id = local.cloudflare_account_id
  name       = "dotfiles-tfstate"

  lifecycle {
    # NOTE: 破棄するとbootstrap・mainの全リソースのstateが失われる
    prevent_destroy = true
  }
}
