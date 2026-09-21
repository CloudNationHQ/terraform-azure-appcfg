moved {
  from = data.azurerm_client_config.current
  to   = data.azurerm_client_config.this
}

moved {
  from = azurerm_app_configuration.conf
  to   = azurerm_app_configuration.this
}
