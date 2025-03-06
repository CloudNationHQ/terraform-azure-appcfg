# Default

This example illustrates the default setup, in its simplest form.

## Types

```hcl
configs = map(object({
  name           = string
  resource_group = optional(string)
  location       = optional(string)
}))
```
