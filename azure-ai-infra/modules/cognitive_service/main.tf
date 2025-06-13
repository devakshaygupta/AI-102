resource "random_string" "azurerm_cognitive_account_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_cognitive_account" "cognitive_service" {
  name                = "CognitiveService-${random_string.azurerm_cognitive_account_name.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.ai_services_sku
  kind                = var.ai_services_kind
}
