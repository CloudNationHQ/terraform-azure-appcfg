variable "app_configuration_keys" {
  description = "Configuration for Azure App Configuration keys"
  type = object({
    keys = optional(map(object({
      key                 = string
      label               = optional(string)
      value               = optional(string)
      vault_key_reference = optional(string)
      content_type        = optional(string)
      etag                = optional(string)
      locked              = optional(bool, false)
      tags                = optional(map(string), {})
    })), {})
  })
}

variable "configuration_store_id" {
  description = "id of the app configuration"
  type        = string
}
