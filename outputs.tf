output "configs" {
  description = "contains app configurations"
  value       = azurerm_app_configuration.conf
}

output "keys" {
  description = "contains app configuration keys"
  value       = azurerm_app_configuration_key.keys
}
