module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "app_configuration" {
  source  = "cloudnationhq/appcfg/azure"
  version = "~> 3.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location

  app_configurations = {
    dev = {
      name = module.naming.app_configuration.name_unique
      sku  = "standard"

      role_assignments = {
        data_owner = {
          role_definition_name = "App Configuration Data Owner"
        }
      }

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
            default = {
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
          timewindow_filter = {
            q4 = {
              start = "2026-10-01T00:00:00Z"
              end   = "2026-12-31T23:59:59Z"
            }
          }
        }
      }
    }
  }

  tags = { environment = "demo" }
}
