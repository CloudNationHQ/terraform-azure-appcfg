variable "app_configurations" {
  description = "Contains configuration for app configurations."
  type = map(object({
    name                                             = string
    resource_group_name                              = optional(string)
    location                                         = optional(string)
    sku                                              = optional(string)
    local_auth_enabled                               = optional(bool)
    public_network_access                            = optional(string, "Enabled")
    purge_protection_enabled                         = optional(bool)
    soft_delete_retention_days                       = optional(number)
    data_plane_proxy_private_link_delegation_enabled = optional(bool)
    data_plane_proxy_authentication_mode             = optional(string)
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
    role_assignments = optional(map(object({
      name                                   = optional(string)
      scope                                  = optional(string)
      role_definition_name                   = optional(string)
      role_definition_id                     = optional(string)
      principal_id                           = optional(string)
      principal_type                         = optional(string)
      condition                              = optional(string)
      condition_version                      = optional(string)
      delegated_managed_identity_resource_id = optional(string)
      skip_service_principal_aad_check       = optional(bool)
      description                            = optional(string)
    })), {})
    features = optional(map(object({
      name                    = optional(string)
      description             = optional(string)
      enabled                 = optional(bool)
      key                     = optional(string)
      label                   = optional(string)
      locked                  = optional(bool)
      percentage_filter_value = optional(number)
      etag                    = optional(string)
      tags                    = optional(map(string))
      targeting_filter = optional(map(object({
        default_rollout_percentage = number
        groups = optional(map(object({
          name               = string
          rollout_percentage = number
        })), {})
        users = optional(list(string), [])
      })), {})
      timewindow_filter = optional(map(object({
        start = optional(string)
        end   = optional(string)
      })), {})
      custom_filter = optional(map(object({
        name       = string
        parameters = optional(map(string), {})
      })), {})
    })), {})
  }))

  validation {
    condition = alltrue([
      for key, config in var.app_configurations :
      config.location != null || var.location != null
    ])
    error_message = "location must be provided either in each config object or as a separate variable."
  }

  validation {
    condition = alltrue([
      for key, config in var.app_configurations :
      config.resource_group_name != null || var.resource_group_name != null
    ])
    error_message = "resource group name must be provided either in each config object or as a separate variable."
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
