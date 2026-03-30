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

module "features" {
  source = "cloudnationhq/appcfg/azure//modules/features"
  version = "~> 2.0"

  configuration_store_id = module.app_configuration.configs.dev.id

  configs = {
    features = {
      dark_mode = {
        name        = "DarkMode"
        description = "Controls dark mode availability"
        enabled     = true
      }

      beta_dashboard = {
        name        = "BetaDashboard"
        description = "Beta dashboard feature"
        enabled     = true

        percentage_filter_value = 50

        targeting_filter = {
          default_rollout_percentage = 25
          users                      = ["user1@example.com", "user2@example.com"]
          groups = {
            beta_testers = {
              name               = "BetaTesters"
              rollout_percentage = 100
            }
          }
        }

        timewindow_filter = {
          start = "2026-04-01T00:00:00Z"
          end   = "2026-06-01T00:00:00Z"
        }
      }
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
      name                  = module.naming.app_configuration.name_unique
      sku                   = "standard"
      public_network_access = "Enabled"
    }
  }
}
