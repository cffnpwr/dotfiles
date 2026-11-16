locals {
  terraform_plan_permission_groups = {
    # NOTE: stateの読み取りは、Workers R2 Storage Readで許可
    account = [
      "Account API Tokens Read",
      "Workers R2 Storage Read",
    ]
    zone = ["DNS Read", "Zone Read"]
  }
}

data "cloudflare_account_api_token_permission_groups_list" "terraform_plan" {
  for_each = toset(concat(local.terraform_plan_permission_groups.account, local.terraform_plan_permission_groups.zone))

  account_id = local.cloudflare_account_id
  name       = urlencode(each.key)
}

# NOTE: mainのplan jobでS3 backendのstateの読み取りとCloudflare providerに使うトークン
resource "cloudflare_account_token" "terraform_plan" {
  account_id = local.cloudflare_account_id
  name       = "${local.cloudflare_account_token_name_prefix}terraform-plan"

  policies = [
    {
      effect = "allow"
      permission_groups = [
        for name in local.terraform_plan_permission_groups.account : { id = one(data.cloudflare_account_api_token_permission_groups_list.terraform_plan[name].result).id }
      ]
      resources = jsonencode({
        "com.cloudflare.api.account.${local.cloudflare_account_id}" = "*"
      })
    },
    {
      effect = "allow"
      permission_groups = [
        for name in local.terraform_plan_permission_groups.zone : { id = one(data.cloudflare_account_api_token_permission_groups_list.terraform_plan[name].result).id }
      ]
      resources = jsonencode({
        "com.cloudflare.api.account.zone.${data.cloudflare_zone.cffnpwr_dev.zone_id}" = "*"
      })
    },
  ]
}
