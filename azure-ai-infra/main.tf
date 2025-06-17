module "resource_group" {
  source = "./modules/resource_group"
  parameters = {
    resource_group_location = var.resource_group_location
  }
}

module "ai_foundry" {
  source = "./modules/ai_foundry"
  parameters = {
    resource_group_name     = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
  }
  depends_on = [module.resource_group]
}

module "ai_service" {
  source = "./modules/ai_service"
  parameters = {
    resource_group_name     = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
  }
  depends_on = [module.resource_group]
}

module "ai_search_service" {
  count  = var.ai_search_required ? 1 : 0
  source = "./modules/ai_search_service"
  parameters = {
    resource_group_name     = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
  }
  depends_on = [module.resource_group]
}

resource "azapi_resource" "openai_connection" {
  type     = "Microsoft.MachineLearningServices/workspaces/connections@2025-01-01-preview"
  name     = "openai-model-connection"
  parent_id = module.ai_foundry.ai_foundry_project_id
  body = {
    properties = {
      category     = "AzureOpenAI"
      target       = module.ai_service.ai_service_endpoint
      authType     = "ApiKey"
      isSharedToAll = false

      metadata = {
        ApiType    = "Azure"
        ResourceId = module.ai_service.ai_service_id
      }

      credentials = {
        key = module.ai_service.primary_access_key
      }
    }
  }
}
