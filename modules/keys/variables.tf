variable "configs" {
  description = "Configuration for Azure App Configuration keys"
  type = object({
    keys = optional(map(object({
      key                 = string
      value               = optional(string, null)
      vault_key_reference = optional(string, null)
      etag                = optional(string, null)
      label               = optional(string, null)
      locked              = optional(bool, false)
      content_type        = optional(string, null)
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

variable "ignore_value_changes_keys" {
  description = "List of keys to ignore value changes"
  type        = list(string)
  default     = []
}

variable "configuration_store_id" {
  description = "id of the app configuration"
  type        = string
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
