variable "configs" {
  description = "Configuration for Azure App Configuration keys"
  type = object({
    keys = optional(map(object({
      key                 = string
      value               = optional(string, null)
      vault_key_reference = optional(string, null)
    })), {})
  })

  validation {
    condition = alltrue([
      for key_name, key in try(var.configs.keys, {}) :
      (key.value != null && key.vault_key_reference == null) ||
      (key.value == null && key.vault_key_reference != null)
    ])
    error_message = "Each App Configuration key must have either 'value' OR 'vault_key_reference' defined, but not both or neither."
  }
}

variable "configuration_store_id" {
  description = "id of the app configuration"
  type        = string
}
