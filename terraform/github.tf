locals {
  repository = "dotfiles"
  # NOTE: environmentはbootstrapのrootが作成
  nix_cache_environment = "nix-cache"
}

resource "github_actions_environment_secret" "nix_cache_aws_access_key_id" {
  repository  = local.repository
  environment = local.nix_cache_environment
  secret_name = "AWS_ACCESS_KEY_ID"
  value       = cloudflare_account_token.nix_cache_upload.id
}

resource "github_actions_environment_secret" "nix_cache_aws_secret_access_key" {
  repository  = local.repository
  environment = local.nix_cache_environment
  secret_name = "AWS_SECRET_ACCESS_KEY"
  # NOTE: R2のSecret Access KeyはAPIトークンの値をSHA-256でハッシュ化した値
  value = sha256(cloudflare_account_token.nix_cache_upload.value)
}
