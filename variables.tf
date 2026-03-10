variable "configs" {
  description = "Contains configuration for app configurations."
  type = map(object({
    name                                             = string
    resource_group_name                              = optional(string)
    location                                         = optional(string)
    sku                                              = optional(string, "free")
    local_auth_enabled                               = optional(bool, true)
    public_network_access                            = optional(string, "Enabled")
    purge_protection_enabled                         = optional(bool, false)
    soft_delete_retention_days                       = optional(number)
    data_plane_proxy_private_link_delegation_enabled = optional(bool, false)
    data_plane_proxy_authentication_mode             = optional(string, "Local")
    encryption = optional(object({
      key_vault_key_identifier = optional(string)
      identity_client_id       = optional(string)
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    replica = optional(map(object({
      name     = string
      location = string
    })), {})
    tags = optional(map(string))
  }))

  validation {
    condition = alltrue([
      for key, config in var.configs :
      config.location != null || var.location != null
    ])
    error_message = "location must be provided either in each config object or as a separate variable."
  }

  validation {
    condition = alltrue([
      for key, config in var.configs :
      config.resource_group_name != null || var.resource_group_name != null
    ])
    error_message = "resource group name must be provided either in each config object or as a separate variable."
  }

  validation {
    condition = alltrue([
      for key, config in var.configs :
      config.identity == null || config.identity.type != "UserAssigned" || (
        config.identity.identity_ids != null && length(config.identity.identity_ids) > 0
      )
    ])
    error_message = "Identity IDs are required when using UserAssigned identity type."
  }
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
