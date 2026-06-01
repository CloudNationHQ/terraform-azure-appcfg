variable "configs" {
  description = "Configuration for Azure App Configuration features."
  type = object({
    features = optional(map(object({
      name                    = string
      description             = optional(string)
      enabled                 = optional(bool)
      key                     = optional(string)
      label                   = optional(string)
      locked                  = optional(bool)
      percentage_filter_value = optional(number)
      tags                    = optional(map(string), {})
      targeting_filter = optional(object({
        default_rollout_percentage = number
        groups = optional(map(object({
          name               = string
          rollout_percentage = number
        })), {})
        users = optional(list(string), [])
      }))
      timewindow_filter = optional(object({
        start = optional(string)
        end   = optional(string)
      }))
      custom_filter = optional(map(object({
        name       = string
        parameters = optional(map(string), {})
      })), {})
    })), {})
  })
}

variable "configuration_store_id" {
  description = "id of the app configuration."
  type        = string
}
