output "azurerm_cognitive_account_name" {
  value = azurerm_cognitive_account.cognitive_service.name
}

output "cognitive_service_id" {
  value = azurerm_cognitive_account.cognitive_service.id
}

output "primary_access_key" {
  value = azurerm_cognitive_account.cognitive_service.primary_access_key
}

output "cognitive_service_endpoint" {
  value = azurerm_cognitive_account.cognitive_service.endpoint
}
