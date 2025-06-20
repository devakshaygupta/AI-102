resource "azapi_resource" "cognitive_account" {
  type      = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  name      = "cognitiveaccount-${var.parameters["resource_group_name"]}"
  parent_id = var.parameters["resource_group_id"]
  location  = var.location
  identity {
    type = "SystemAssigned"
  }
  body = {
    sku = {
      name = var.ai_services_sku
      tier = var.deployment_sku_name
    }
    kind = "AIServices"
    properties = {
      allowProjectManagement = true
      customSubDomainName    = "cognitiveaccount-${var.parameters["resource_group_name"]}"
      networkAcls = {
        defaultAction       = "Allow"
        virtualNetworkRules = []
        ipRules             = []
      }
      publicNetworkAccess = "Enabled"
      disableLocalAuth    = true
    }
  }
}

resource "azapi_resource" "ai_agent_project" {
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview"
  name      = "aiproject-${var.parameters["resource_group_name"]}"
  location  = var.location
  parent_id = azapi_resource.cognitive_account.id
  identity {
    type = "SystemAssigned"
  }
  body = {
    properties = {
      description = "AI Foundry Project for AI Agent Service"
      displayName = "AI Foundry Project"
    }
  }
  depends_on = [azapi_resource.cognitive_account]
}

resource "azurerm_cognitive_deployment" "agent_model_deployment" {
  name                 = "agent-model-deployment-${var.deployment_model_name}"
  cognitive_account_id = azapi_resource.cognitive_account.id

  model {
    format  = var.deployment_format
    name    = var.deployment_model_name
    version = "2024-08-06"
  }

  sku {
    name     = var.deployment_sku_name
    capacity = 10
  }

  depends_on = [azapi_resource.cognitive_account]
}
