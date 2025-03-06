# Keys

This deploys keys with values and key vault references.

## Types

```hcl
configs = map(object({
  name                  = string
  resource_group        = optional(string)
  location              = optional(string)
  sku                   = optional(string)
  public_network_access = optional(string)
  keys = optional(map(object({
    key                 = string
    value               = optional(string)
    vault_key_reference = optional(string)
  })))
}))
```
