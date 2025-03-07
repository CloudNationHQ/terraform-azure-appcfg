data "azurerm_client_config" "current" {}

# keys
resource "azurerm_app_configuration_key" "keys" {
  for_each = {
    for key_name, key in lookup(var.configs, "keys", {}) : key_name => {
      key                 = key.key
      value               = lookup(key, "value", null)
      vault_key_reference = lookup(key, "vault_key_reference", null)
    }
  }

  configuration_store_id = var.configuration_store_id
  key                    = each.value.key
  type                   = each.value.vault_key_reference != null ? "vault" : "kv"
  value                  = each.value.vault_key_reference == null ? each.value.value : null
  vault_key_reference    = each.value.vault_key_reference

  depends_on = [azurerm_role_assignment.role]
}

# role
resource "azurerm_role_assignment" "role" {
  for_each = {
    for k, v in {
      enabled = (
        length(lookup(var.configs, "keys", {})) > 0 ||
        length(lookup(var.configs, "features", {})) > 0
      ) ? true : false
    } : k => v if v == true
  }

  scope                = var.configuration_store_id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}
