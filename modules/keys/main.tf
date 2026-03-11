# keys
resource "azurerm_app_configuration_key" "keys" {
  for_each = {
    for key_name, key in lookup(var.configs, "keys", {}) : key_name => {
      key                 = key.key
      label               = lookup(key, "label", null)
      value               = lookup(key, "value", null)
      vault_key_reference = lookup(key, "vault_key_reference", null)
      content_type        = lookup(key, "content_type", null)
      locked              = lookup(key, "locked", false)
      tags                = lookup(key, "tags", {})
    }
  }

  configuration_store_id = var.configuration_store_id
  key                    = each.value.key
  label                  = each.value.label
  type                   = each.value.vault_key_reference != null ? "vault" : "kv"
  content_type           = each.value.vault_key_reference == null ? each.value.content_type : null
  value                  = each.value.vault_key_reference == null ? each.value.value : null
  vault_key_reference    = each.value.vault_key_reference
  locked                 = each.value.locked
  tags                   = each.value.tags
}
