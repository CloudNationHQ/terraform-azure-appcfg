# keys
resource "azurerm_app_configuration_key" "this" {
  for_each = var.app_configuration_keys.keys

  configuration_store_id = var.configuration_store_id
  key                    = each.value.key
  label                  = each.value.label
  type                   = each.value.vault_key_reference != null ? "vault" : "kv"
  content_type           = each.value.vault_key_reference == null ? each.value.content_type : null
  etag                   = each.value.etag
  value                  = each.value.vault_key_reference == null ? each.value.value : null
  vault_key_reference    = each.value.vault_key_reference
  locked                 = each.value.locked
  tags                   = each.value.tags
}
