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
