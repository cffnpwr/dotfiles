locals {
  cloudflare_account_id = "086a84b440e09bc83330fe07f1966f5d"
  # NOTE: アカウントトークンには説明を設定できないため、ダッシュボードで人が作成したトークンと名前で区別する
  #       他のリポジトリが作成したトークンと区別するため、リポジトリ名も付ける
  cloudflare_account_token_name_prefix = "[managed by terraform] dotfiles/"

  # NOTE: アップロードしてからこの日数を過ぎたストアパスを削除する。使い続けているパスはCIが次にアップロードし直す
  nix_cache_retention_days = 30
}

resource "cloudflare_r2_bucket" "nix_cache" {
  account_id = local.cloudflare_account_id
  name       = "dotfiles-nix-cache"
}

# NOTE: 各マシンがsubstituterとしてHTTPSで読むための公開のドメイン
resource "cloudflare_r2_custom_domain" "nix_cache" {
  account_id  = local.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.nix_cache.name
  domain      = "nix-cache.${data.cloudflare_zone.cffnpwr_dev.name}"
  zone_id     = data.cloudflare_zone.cffnpwr_dev.zone_id
  enabled     = true
  min_tls     = "1.2"
}

resource "cloudflare_r2_bucket_lifecycle" "nix_cache" {
  account_id  = local.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.nix_cache.name

  rules = [{
    id      = "expire-store-paths"
    enabled = true
    conditions = {
      prefix = ""
    }
    delete_objects_transition = {
      condition = {
        type = "Age"
        # NOTE: R2のライフサイクルの経過時間は秒で指定する
        max_age = local.nix_cache_retention_days * 24 * 60 * 60
      }
    }
  }]
}

# NOTE: nix-cache-infoが無いと、Nixはsubstituterをバイナリキャッシュとして扱わずに失敗する
#       ライフサイクルのルールより優先されるロックで、nix-cache-infoを期限による削除の対象から外す
resource "cloudflare_r2_bucket_lock" "nix_cache" {
  account_id  = local.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.nix_cache.name

  rules = [{
    id      = "keep-nix-cache-info"
    enabled = true
    prefix  = "nix-cache-info"
    condition = {
      type = "Indefinite"
    }
  }]
}

data "cloudflare_account_api_token_permission_groups_list" "r2_bucket_item_write" {
  account_id = local.cloudflare_account_id
  name       = "Workers%20R2%20Storage%20Bucket%20Item%20Write"
}

# NOTE: Nixのworkflowがストアパスをアップロードするために使うトークン
resource "cloudflare_account_token" "nix_cache_upload" {
  account_id = local.cloudflare_account_id
  name       = "${local.cloudflare_account_token_name_prefix}nix-cache-upload"

  policies = [{
    effect = "allow"
    permission_groups = [{
      id = one(data.cloudflare_account_api_token_permission_groups_list.r2_bucket_item_write.result).id
    }]
    resources = jsonencode({
      "com.cloudflare.edge.r2.bucket.${local.cloudflare_account_id}_default_${cloudflare_r2_bucket.nix_cache.name}" = "*"
    })
  }]
}
