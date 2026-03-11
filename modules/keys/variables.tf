variable "configs" {
  description = "Configuration for Azure App Configuration keys"
  type = object({
    keys = optional(map(object({
      key                 = string
      label               = optional(string)
      value               = optional(string)
      vault_key_reference = optional(string)
      content_type        = optional(string)
      locked              = optional(bool, false)
      tags                = optional(map(string), {})
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

  validation {
    condition = alltrue([
      for key_name, key in try(var.configs.keys, {}) :
      key.content_type == null || key.value != null
    ])
    error_message = "The 'content_type' property can only be set for App Configuration keys that define a regular 'value'."
  }
}

variable "configuration_store_id" {
  description = "id of the app configuration"
  type        = string
}
