output "ai_search_service_id" {
  description = "The ID of the AI Search Service."
  value       = azurerm_search_service.ai_search_service.id
}

output "ai_search_primary_access_key" {
  description = "The primary access key for the AI Search Service."
  value       = azurerm_search_service.ai_search_service.primary_key
}
