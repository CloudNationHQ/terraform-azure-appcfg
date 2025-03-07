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
