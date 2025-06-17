output "azurerm_ai_services_name" {
  value = azurerm_ai_services.ai_service.name
}

output "ai_service_id" {
  value = azurerm_ai_services.ai_service.id
}

output "primary_access_key" {
  value = azurerm_ai_services.ai_service.primary_access_key
}

output "ai_service_endpoint" {
  value = azurerm_ai_services.ai_service.endpoint
}
