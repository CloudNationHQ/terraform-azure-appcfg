# App Configurations

This terraform module simplifies the process of creating and managing app configurations on azure with customizable keys and features, offering a flexible and powerful solution for managing configuration settings and feature flags through code.

## Features

Supports both standard key-value pairs and secure key vault references for sensitive configuration data.

Utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 5.0)

## Resources

The following resources are used by this module:

- [azurerm_app_configuration.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration) (resource)
- [azurerm_app_configuration_feature.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_configuration_feature) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_app_configurations"></a> [app\_configurations](#input\_app\_configurations)

Description: Contains configuration for app configurations.

Type:

```hcl
map(object({
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_configs"></a> [configs](#output\_configs)

Description: Contains configuration for app configurations.

### <a name="output_features"></a> [features](#output\_features)

Description: Contains app configuration features.

### <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments)

Description: Contains all role assignments scoped to the app configurations.
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-sa/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-app-configuration/)
- [Rest Api](https://learn.microsoft.com/en-us/azure/azure-app-configuration/rest-api)
