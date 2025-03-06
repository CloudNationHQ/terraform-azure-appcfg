module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.22"

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
  source = "../../"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  configs = {
    dev = {
      name = module.naming.app_configuration.name_unique
    }
  }
}
