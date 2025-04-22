variable "configs" {
  description = "Contains configuration for app configurations."
  type = map(object({
    name                                             = string
    resource_group                                   = optional(string, null)
    location                                         = optional(string, null)
    sku                                              = optional(string, "free")
    local_auth_enabled                               = optional(bool, true)
    public_network_access                            = optional(string, "Enabled")
    purge_protection_enabled                         = optional(bool, false)
    soft_delete_retention_days                       = optional(number, null)
    data_plane_proxy_private_link_delegation_enabled = optional(bool, false)
    data_plane_proxy_authentication_mode             = optional(string, "Local")
    tags                                             = optional(map(string))
  }))
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
