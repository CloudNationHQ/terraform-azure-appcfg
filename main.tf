data "azurerm_client_config" "this" {}

# app configurations
resource "azurerm_app_configuration" "this" {
  for_each = var.app_configurations

  resource_group_name = coalesce(
    each.value.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    each.value.location, var.location
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
    for_each = each.value.encryption != null ? { "this" = each.value.encryption } : {}

    content {
      identity_client_id       = encryption.value.identity_client_id
      key_vault_key_identifier = encryption.value.key_vault_key_identifier
    }
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? { "this" = each.value.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "replica" {
    for_each = each.value.replica

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
      for config_key, config in var.app_configurations : [
        for feature_key, feature in config.features : {
          key         = "${config_key}:${feature_key}"
          config_key  = config_key
          feature     = feature
          feature_key = feature_key
        }
      ]
    ]) : pair.key => pair
  }

  name = coalesce(
    each.value.feature.name, each.value.feature_key
  )

  configuration_store_id  = azurerm_app_configuration.this[each.value.config_key].id
  description             = each.value.feature.description
  enabled                 = each.value.feature.enabled
  key                     = each.value.feature.key
  label                   = each.value.feature.label
  locked                  = each.value.feature.locked
  percentage_filter_value = each.value.feature.percentage_filter_value
  etag                    = each.value.feature.etag

  tags = coalesce(
    each.value.feature.tags, var.tags
  )

  dynamic "targeting_filter" {
    for_each = each.value.feature.targeting_filter

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
    for_each = each.value.feature.timewindow_filter

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
    azurerm_role_assignment.this
  ]
}

# role assignments
resource "azurerm_role_assignment" "this" {
  for_each = {
    for pair in flatten([
      for config_key, config in var.app_configurations : [
        for assignment_key, assignment in config.role_assignments : {
          key            = "${config_key}:${assignment_key}"
          config_key     = config_key
          assignment     = assignment
          assignment_key = assignment_key
        }
      ]
    ]) : pair.key => pair
  }

  scope = coalesce(
    each.value.assignment.scope, azurerm_app_configuration.this[each.value.config_key].id
  )

  principal_id = coalesce(
    each.value.assignment.principal_id, data.azurerm_client_config.this.object_id
  )

  name                                   = each.value.assignment.name
  role_definition_name                   = each.value.assignment.role_definition_name
  role_definition_id                     = each.value.assignment.role_definition_id
  principal_type                         = each.value.assignment.principal_type
  condition                              = each.value.assignment.condition
  condition_version                      = each.value.assignment.condition_version
  delegated_managed_identity_resource_id = each.value.assignment.delegated_managed_identity_resource_id
  skip_service_principal_aad_check       = each.value.assignment.skip_service_principal_aad_check
  description                            = each.value.assignment.description
}
