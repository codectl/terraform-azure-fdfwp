module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "westeurope"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "policy" {
  source  = "codectl/fdfwp/azure"
  version = "~> 1.0"

  cdn_frontdoor_firewall_policy = {
    name                = module.naming.cdn_frontdoor_firewall_policy.name
    resource_group_name = module.rg.groups.demo.name
    sku_name            = "Premium_AzureFrontDoor"
    managed_rules = {
      default_ruleset = {
        type    = "DefaultRuleSet"
        version = "1.0"
        action  = "Block"
      }
      bot_protection = {
        type    = "Microsoft_BotManagerRuleSet"
        version = "1.0"
        action  = "Block"
      }
    }
  }
}
