# features
resource "azurerm_app_configuration_feature" "feat" {
  for_each = {
    for feat_name, feat in lookup(var.configs, "features", {}) : feat_name => feat
  }

  configuration_store_id  = var.configuration_store_id
  name                    = each.value.name
  description             = each.value.description
  enabled                 = each.value.enabled
  key                     = each.value.key
  label                   = each.value.label
  locked                  = each.value.locked
  percentage_filter_value = each.value.percentage_filter_value
  tags                    = each.value.tags

  dynamic "targeting_filter" {
    for_each = lookup(each.value, "targeting_filter", null) != null ? [each.value.targeting_filter] : []

    content {
      default_rollout_percentage = targeting_filter.value.default_rollout_percentage
      users                      = targeting_filter.value.users

      dynamic "groups" {
        for_each = lookup(targeting_filter.value, "groups", {})

        content {
          name               = groups.value.name
          rollout_percentage = groups.value.rollout_percentage
        }
      }
    }
  }

  dynamic "timewindow_filter" {
    for_each = lookup(each.value, "timewindow_filter", null) != null ? [each.value.timewindow_filter] : []

    content {
      start = timewindow_filter.value.start
      end   = timewindow_filter.value.end
    }
  }
}
