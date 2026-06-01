# features
resource "azurerm_app_configuration_feature" "this" {
  for_each = lookup(var.configs, "features", {})

  configuration_store_id  = var.configuration_store_id
  name                    = each.value.name
  description             = lookup(each.value, "description", null)
  enabled                 = lookup(each.value, "enabled", false)
  key                     = lookup(each.value, "key", null)
  label                   = lookup(each.value, "label", null)
  locked                  = lookup(each.value, "locked", null)
  percentage_filter_value = lookup(each.value, "percentage_filter_value", null)
  tags                    = lookup(each.value, "tags", {})

  dynamic "targeting_filter" {
    for_each = lookup(each.value, "targeting_filter", null) != null ? { "this" = each.value.targeting_filter } : {}

    content {
      default_rollout_percentage = targeting_filter.value.default_rollout_percentage
      users                      = lookup(targeting_filter.value, "users", [])

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
    for_each = lookup(each.value, "timewindow_filter", null) != null ? { "this" = each.value.timewindow_filter } : {}

    content {
      start = lookup(timewindow_filter.value, "start", null)
      end   = lookup(timewindow_filter.value, "end", null)
    }
  }

  dynamic "custom_filter" {
    for_each = lookup(each.value, "custom_filter", {})

    content {
      name       = custom_filter.value.name
      parameters = lookup(custom_filter.value, "parameters", {})
    }
  }
}
