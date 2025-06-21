resource "random_string" "storage_account_name" {
  length  = 12
  upper   = false
  special = false
}

resource "azurerm_storage_account" "ai_foundry_storage_account" {
  name                     = random_string.storage_account_name.result
  location                 = var.parameters["resource_group_location"]
  resource_group_name      = var.parameters["resource_group_name"]
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azapi_resource" "ai_language_service" {
  type      = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  name      = "languageservice-${var.parameters["resource_group_name"]}"
  parent_id = var.parameters["resource_group_id"]
  location  = var.parameters["resource_group_location"]
  identity {
    type = "SystemAssigned"
  }
  body = {
    sku = {
      name = var.language_services_sku
    }
    kind = "TextAnalytics"
    properties = {
      allowProjectManagement = true
      customSubDomainName    = "languageservice-${var.parameters["resource_group_name"]}"
      networkAcls = {
        defaultAction       = "Allow"
        virtualNetworkRules = []
        ipRules             = []
      }
      apiProperties = {
        qnaAzureSearchEndpointId = var.parameters["ai_search_service_id"],
        qnaAzureSearchEndpointKey = var.parameters["ai_search_primary_access_key"]
      }
      publicNetworkAccess = "Enabled"
      disableLocalAuth    = false
      userOwnedStorage = [
        {
          resourceId = azurerm_storage_account.ai_foundry_storage_account.id
        }
      ]
    }
  }
}
