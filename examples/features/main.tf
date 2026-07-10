module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.26"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "app_configuration" {
  source  = "cloudnationhq/appcfg/azure"
  version = "~> 2.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  configs = {
    dev = {
      name = module.naming.app_configuration.name_unique
      sku  = "standard"

      features = {
        dark_mode = {
          name        = "DarkMode"
          description = "enables dark mode for all users"
          enabled     = true
        }

        beta_rollout = {
          name    = "BetaRollout"
          enabled = false
          label   = "beta"
          targeting_filter = {
            default_rollout_percentage = 10
            users                      = ["alice@example.com", "bob@example.com"]
            groups = {
              internal = {
                name               = "internal-testers"
                rollout_percentage = 100
              }
            }
          }
        }
      }
    }
  }

  tags = { environment = "demo" }
}
