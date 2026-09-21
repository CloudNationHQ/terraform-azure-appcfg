output "configs" {
  description = "Contains configuration for app configurations."
  value       = azurerm_app_configuration.this
}

output "features" {
  description = "Contains app configuration features."
  value       = azurerm_app_configuration_feature.this
}

output "role_assignments" {
  description = "Contains all role assignments scoped to the app configurations."
  value       = azurerm_role_assignment.this
}
