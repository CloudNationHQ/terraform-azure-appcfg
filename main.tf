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

# features
resource "azurerm_app_configuration_feature" "this" {
  for_each = {
    for pair in flatten([
      for config_key, config in var.configs : [
        for feature_key, feature in config.features : {
          key         = "${config_key}:${feature_key}"
          config_key  = config_key
          feature     = feature
          feature_key = feature_key
        }
      ]
    ]) : pair.key => pair
  }

  configuration_store_id  = azurerm_app_configuration.conf[each.value.config_key].id
  name                    = coalesce(each.value.feature.name, each.value.feature_key)
  description             = each.value.feature.description
  enabled                 = each.value.feature.enabled
  key                     = each.value.feature.key
  label                   = each.value.feature.label
  locked                  = each.value.feature.locked
  percentage_filter_value = each.value.feature.percentage_filter_value
  tags                    = coalesce(each.value.feature.tags, var.tags)

  dynamic "targeting_filter" {
    for_each = each.value.feature.targeting_filter != null ? { "this" = each.value.feature.targeting_filter } : {}

    content {
      default_rollout_percentage = targeting_filter.value.default_rollout_percentage
      users                      = targeting_filter.value.users

      dynamic "groups" {
        for_each = targeting_filter.value.groups

        content {
          name               = groups.value.name
          rollout_percentage = groups.value.rollout_percentage
        }
      }
    }
  }

  dynamic "timewindow_filter" {
    for_each = each.value.feature.timewindow_filter != null ? { "this" = each.value.feature.timewindow_filter } : {}

    content {
      start = timewindow_filter.value.start
      end   = timewindow_filter.value.end
    }
  }

  dynamic "custom_filter" {
    for_each = each.value.feature.custom_filter

    content {
      name       = custom_filter.value.name
      parameters = custom_filter.value.parameters
    }
  }

  # role assignment must exist before features can be written via the data plane
  depends_on = [
    azurerm_role_assignment.role
  ]
}

# roles
resource "azurerm_role_assignment" "role" {
  for_each = var.configs

  scope                = azurerm_app_configuration.conf[each.key].id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
