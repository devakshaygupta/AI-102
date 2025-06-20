resource "azurerm_ai_services" "ai_service" {
  name                = "aiservice-${var.parameters["resource_group_name"]}"
  location            = var.location
  resource_group_name = var.parameters["resource_group_name"]
  sku_name            = var.ai_services_sku
}

resource "azurerm_cognitive_deployment" "model_deployment" {
  name                 = "model-deployment-${var.parameters["resource_group_name"]}"
  cognitive_account_id = azurerm_ai_services.ai_service.id

  model {
    format  = var.deployment_format
    name    = var.deployment_model_name
    version = "2024-08-06"
  }

  sku {
    name     = var.deployment_sku_name
    capacity = 1
  }

  depends_on = [azurerm_ai_services.ai_service]
}
