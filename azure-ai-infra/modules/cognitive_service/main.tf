resource "random_string" "azurerm_cognitive_account_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "azurerm_cognitive_account" "cognitive_service" {
  name                = "CognitiveService-${random_string.azurerm_cognitive_account_name.result}"
  location            = var.parameters["resource_group_location"]
  resource_group_name = var.parameters["resource_group_name"]
  sku_name            = var.ai_services_sku
  kind                = var.ai_services_kind
}

resource "azurerm_cognitive_deployment" "embedding_deployment" {
  name = "embedding-deployment-${random_string.azurerm_cognitive_account_name.result}"
  cognitive_account_id = azurerm_cognitive_account.cognitive_service.id

  model {
    format = var.model_deployment_format
    name = "text-embedding-ada-002"
  }

  sku {
    name     = var.model_deployment_sku_name
    capacity = 5
  }
}

resource "azurerm_cognitive_deployment" "model_deployment" {
  name = "model-deployment-${random_string.azurerm_cognitive_account_name.result}"
  cognitive_account_id = azurerm_cognitive_account.cognitive_service.id

  model {
    format = var.model_deployment_format
    name = "gpt-4o"
  }

  sku {
    name     = var.model_deployment_sku_name
    capacity = 5
  }
}
