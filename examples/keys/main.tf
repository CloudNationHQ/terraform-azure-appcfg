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

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 3.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

    secrets = {
      connection-string1 = {
        value = module.storage1.account.primary_connection_string
      }
      connection-string2 = {
        value = module.storage2.account.primary_connection_string
      }
      random_string = {
        example = {
          length  = 24
          special = false
        }
      }
    }
  }
}

module "storage1" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 2.0"

  storage = {
    name           = module.naming.storage_account.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "storage2" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 2.0"

  storage = {
    name           = "${module.naming.storage_account.name_unique}2"
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
  }
}

module "app_configuration" {
  source = "../../"

  resource_group = module.rg.groups.demo.name
  location       = module.rg.groups.demo.location

  configs = {
    dev = {
      name                  = module.naming.app_configuration.name_unique
      sku                   = "standard"
      public_network_access = "Enabled"

      keys = {
        blob_container_id = {
          key   = "Storage:BlobContainer:Id"
          value = "function-deployments"
        },

        primary_storage_connection = {
          key                 = "Storage:PrimaryAccount:ConnectionString"
          vault_key_reference = module.kv.secrets.connection-string1.id
        },

        backup_storage_connection = {
          key                 = "Storage:BackupAccount:ConnectionString"
          vault_key_reference = module.kv.secrets.connection-string2.id
        }
      }
    }
  }
}
