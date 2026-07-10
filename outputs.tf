output "configs" {
  description = "Contains configuration for app configurations."
  value       = azurerm_app_configuration.conf
}

output "features" {
  description = "Contains app configuration features."
  value       = azurerm_app_configuration_feature.this
}
