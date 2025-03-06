data "azurerm_client_config" "current" {}

# app configurations
resource "azurerm_app_configuration" "conf" {
  for_each = var.configs

  name                                             = each.value.name
  resource_group_name                              = coalesce(lookup(each.value, "resource_group", null), var.resource_group)
  location                                         = coalesce(lookup(each.value, "location", null), var.location)
  sku                                              = try(each.value.sku, "free")
  local_auth_enabled                               = try(each.value.local_auth_enabled, true)
  public_network_access                            = try(each.value.public_network_access, "Enabled")
  purge_protection_enabled                         = try(each.value.purge_protection_enabled, false)
  soft_delete_retention_days                       = try(each.value.soft_delete_retention_days, null)
  data_plane_proxy_private_link_delegation_enabled = try(each.value.data_plane_proxy_private_link_delegation_enabled, false)
  data_plane_proxy_authentication_mode             = try(each.value.data_plane_proxy_authentication_mode, "Local")

  tags = try(
    each.value.tags, var.tags, null
  )
}

# keys
resource "azurerm_app_configuration_key" "keys" {
  for_each = {
    for idx, key_config in flatten([
      for config_name, config in var.configs : [
        for key_name, key in lookup(config, "keys", {}) : {
          id                  = "${config_name}-${key_name}"
          config_name         = config_name
          key                 = key.key
          value               = lookup(key, "value", null)
          vault_key_reference = lookup(key, "vault_key_reference", null)
        }
      ]
    ]) : key_config.id => key_config
  }

  configuration_store_id = azurerm_app_configuration.conf[each.value.config_name].id
  key                    = each.value.key

  type                = each.value.vault_key_reference != null ? "vault" : "kv"
  value               = each.value.vault_key_reference == null ? each.value.value : null
  vault_key_reference = each.value.vault_key_reference

  depends_on = [azurerm_role_assignment.role]
}

# role
resource "azurerm_role_assignment" "role" {
  for_each = {
    for name, config in azurerm_app_configuration.conf : name => config
    if lookup(var.configs[name], "keys", null) != null || lookup(var.configs[name], "features", null) != null
  }

  scope                = each.value.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
