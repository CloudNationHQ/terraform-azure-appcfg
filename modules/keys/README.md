# App Configuration Keys

This submodule illustrates how to manage app configuration keys

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

- [azurerm_app_configuration_key.keys](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration_key) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_configs"></a> [configs](#input\_configs)

Description: Configuration for Azure App Configuration keys

Type:

```hcl
object({
    keys = optional(map(object({
      key                 = string
      value               = optional(string, null)
      vault_key_reference = optional(string, null)
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

### <a name="output_keys"></a> [keys](#output\_keys)

Description: contains app configuration keys
<!-- END_TF_DOCS -->
