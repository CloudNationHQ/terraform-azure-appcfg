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
  etag                   = each.value.etag
  label                  = each.value.label
  locked                 = each.value.locked
  content_type           = each.value.content_type

  tags = try(
    each.value.tags, var.tags, null
  )
  lifecycle {
    ignore_changes = [
      # Dynamic ignore based on key name
      contains(var.ignore_value_changes_keys, each.key) ? value : "no_ignore"
    ]
  }
}
