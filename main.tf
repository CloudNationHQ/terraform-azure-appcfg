data "azurerm_client_config" "current" {}

# app configurations
resource "azurerm_app_configuration" "conf" {
  for_each = var.configs

  resource_group_name = coalesce(
    lookup(
      each.value, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(each.value, "location", null
    ), var.location
  )

  name                                             = each.value.name
  sku                                              = each.value.sku
  local_auth_enabled                               = each.value.local_auth_enabled
  public_network_access                            = each.value.public_network_access
  purge_protection_enabled                         = each.value.purge_protection_enabled
  soft_delete_retention_days                       = each.value.soft_delete_retention_days
  data_plane_proxy_private_link_delegation_enabled = each.value.data_plane_proxy_private_link_delegation_enabled
  data_plane_proxy_authentication_mode             = each.value.data_plane_proxy_authentication_mode

  dynamic "encryption" {
    for_each = lookup(each.value, "encryption", null) != null ? [each.value.encryption] : []

    content {
      identity_client_id       = encryption.value.identity_client_id
      key_vault_key_identifier = encryption.value.key_vault_key_identifier
    }
  }

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) != null ? [each.value.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "replica" {
    for_each = lookup(each.value, "replica", {})

    content {
      name     = replica.value.name
      location = replica.value.location
    }
  }

  tags = coalesce(
    each.value.tags, var.tags
  )
}

# roles
resource "azurerm_role_assignment" "role" {
  for_each = var.configs

  scope                = azurerm_app_configuration.conf[each.key].id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
