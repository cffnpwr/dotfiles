provider "cloudflare" {}

provider "github" {
  owner = "cffnpwr"
  token = var.github_token
}
