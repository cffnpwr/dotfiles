locals {
  repository = "dotfiles"
}

resource "github_repository_environment" "terraform_plan" {
  repository  = local.repository
  environment = "terraform-plan"
}

resource "github_repository_environment" "terraform_apply" {
  repository  = local.repository
  environment = "terraform-apply"

  # NOTE: シークレットを読めるブランチをmainブランチに限定
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "terraform_apply_main" {
  repository     = github_repository_environment.terraform_apply.repository
  environment    = github_repository_environment.terraform_apply.environment
  branch_pattern = "main"
}

# NOTE: Nixのバイナリキャッシュにアップロードするjobのenvironment。R2の認証情報はmainのrootが登録
resource "github_repository_environment" "nix_cache" {
  repository  = local.repository
  environment = "nix-cache"

  # NOTE: シークレットを読めるブランチをmainブランチに限定
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "nix_cache_main" {
  repository     = github_repository_environment.nix_cache.repository
  environment    = github_repository_environment.nix_cache.environment
  branch_pattern = "main"
}

# NOTE: pull_requestではブランチの条件と照合するGITHUB_REFがPRのブランチ名にならないため、限定しない
resource "github_repository_environment" "flake_lock" {
  repository  = local.repository
  environment = "flake-lock"
}

# NOTE: applyのS3 backendの認証情報はworkflowがCLOUDFLARE_API_TOKENから作成
resource "github_actions_environment_secret" "terraform_plan_aws_access_key_id" {
  repository  = local.repository
  environment = github_repository_environment.terraform_plan.environment
  secret_name = "AWS_ACCESS_KEY_ID"
  value       = cloudflare_account_token.terraform_plan.id
}

resource "github_actions_environment_secret" "terraform_plan_aws_secret_access_key" {
  repository  = local.repository
  environment = github_repository_environment.terraform_plan.environment
  secret_name = "AWS_SECRET_ACCESS_KEY"
  # NOTE: R2のSecret Access KeyはAPIトークンの値をSHA-256でハッシュ化した値
  value = sha256(cloudflare_account_token.terraform_plan.value)
}

resource "github_actions_environment_secret" "terraform_plan_cloudflare_api_token" {
  repository  = local.repository
  environment = github_repository_environment.terraform_plan.environment
  secret_name = "CLOUDFLARE_API_TOKEN"
  value       = cloudflare_account_token.terraform_plan.value
}

# NOTE: APIトークンで作成したトークンにはAccount API Tokens Writeを付けられないため、ダッシュボードで作成したトークンを変数で受け取る
resource "github_actions_environment_secret" "terraform_apply_cloudflare_api_token" {
  repository  = local.repository
  environment = github_repository_environment.terraform_apply.environment
  secret_name = "CLOUDFLARE_API_TOKEN"
  value       = var.cloudflare_api_token_apply
}

resource "github_actions_environment_variable" "terraform_plan_app_client_id" {
  repository    = local.repository
  environment   = github_repository_environment.terraform_plan.environment
  variable_name = "PLAN_APP_CLIENT_ID"
  value         = var.plan_app_client_id
}

resource "github_actions_environment_secret" "terraform_plan_app_private_key" {
  repository  = local.repository
  environment = github_repository_environment.terraform_plan.environment
  secret_name = "PLAN_APP_PRIVATE_KEY"
  value       = var.plan_app_private_key
}

resource "github_actions_environment_variable" "terraform_apply_app_client_id" {
  repository    = local.repository
  environment   = github_repository_environment.terraform_apply.environment
  variable_name = "APPLY_APP_CLIENT_ID"
  value         = var.apply_app_client_id
}

resource "github_actions_environment_secret" "terraform_apply_app_private_key" {
  repository  = local.repository
  environment = github_repository_environment.terraform_apply.environment
  secret_name = "APPLY_APP_PRIVATE_KEY"
  value       = var.apply_app_private_key
}

resource "github_actions_environment_variable" "flake_lock_app_client_id" {
  repository    = local.repository
  environment   = github_repository_environment.flake_lock.environment
  variable_name = "FLAKE_LOCK_APP_CLIENT_ID"
  value         = var.flake_lock_app_client_id
}

resource "github_actions_environment_secret" "flake_lock_app_private_key" {
  repository  = local.repository
  environment = github_repository_environment.flake_lock.environment
  secret_name = "FLAKE_LOCK_APP_PRIVATE_KEY"
  value       = var.flake_lock_app_private_key
}

resource "github_actions_environment_secret" "nix_cache_signing_key" {
  repository  = local.repository
  environment = github_repository_environment.nix_cache.environment
  secret_name = "NIX_SIGNING_KEY"
  value       = var.nix_signing_key
}
