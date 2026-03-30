<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_app_configuration_feature.feat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration_feature) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_configs"></a> [configs](#input\_configs)

Description: Configuration for Azure App Configuration features

Type:

```hcl
object({
    features = optional(map(object({
      name                    = string
      description             = optional(string)
      enabled                 = optional(bool, false)
      key                     = optional(string)
      label                   = optional(string)
      locked                  = optional(bool, false)
      percentage_filter_value = optional(number)
      tags                    = optional(map(string), {})
      targeting_filter = optional(object({
        default_rollout_percentage = number
        users                      = optional(list(string))
        groups = optional(map(object({
          name               = string
          rollout_percentage = number
        })), {})
      }))
      timewindow_filter = optional(object({
        start = optional(string)
        end   = optional(string)
      }))
    })), {})
  })
```

### <a name="input_configuration_store_id"></a> [configuration\_store\_id](#input\_configuration\_store\_id)

Description: id of the app configuration

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_features"></a> [features](#output\_features)

Description: contains app configuration features
<!-- END_TF_DOCS -->