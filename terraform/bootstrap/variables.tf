variable "github_token" {
  description = "GitHub providerのトークン"
  type        = string
  default     = null
  sensitive   = true
}

variable "cloudflare_api_token_apply" {
  description = "CIのapplyがCloudflare providerで使う読み書きできるAPIトークン"
  type        = string
  sensitive   = true
}

variable "plan_app_client_id" {
  description = "CIでのterraform planで使用するGitHub providerのトークンの発行に使うGitHub AppのClient ID"
  type        = string
}

variable "plan_app_private_key" {
  description = "CIでのterraform planで使用するGitHub providerのトークンの発行に使うGitHub Appの秘密鍵"
  type        = string
  sensitive   = true
}

variable "apply_app_client_id" {
  description = "CIでのterraform applyで使用するGitHub providerのトークンの発行に使うGitHub AppのClient ID"
  type        = string
}

variable "apply_app_private_key" {
  description = "CIでのterraform applyで使用するGitHub providerのトークンの発行に使うGitHub Appの秘密鍵"
  type        = string
  sensitive   = true
}

variable "nix_signing_key" {
  description = "CIでのNixのバイナリキャッシュとしてアップロードするストアパスの署名に使う秘密鍵"
  type        = string
  sensitive   = true
}
