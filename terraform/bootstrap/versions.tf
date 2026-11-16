terraform {
  required_version = "1.17.2"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.29.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.13.0"
    }
  }
}
