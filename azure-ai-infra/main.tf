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

module "cognitive_service" {
  source = "./modules/cognitive_service"
  ai_services_kind = var.ai_services_kind
  parameters = {
    resource_group_name     = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
  }
  depends_on = [module.resource_group]
}

module "ai_search_service" {
  source = "./modules/ai_search_service"
  parameters = {
    resource_group_name     = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
  }
  depends_on = [module.resource_group]
}

resource "azapi_resource" "openai_connection" {
  type     = "Microsoft.MachineLearningServices/workspaces/connections@2025-01-01-preview"
  name     = "openai-embedding-connection"
  parent_id = module.ai_foundry.ai_foundry_project_id
  body = {
    properties = {
      category     = "AzureOpenAI"
      target       = module.cognitive_service.cognitive_service_endpoint
      authType     = "ApiKey"
      isSharedToAll = false

      metadata = {
        ApiType    = "Azure"
        ResourceId = module.cognitive_service.cognitive_service_id
      }

      credentials = {
        key = module.cognitive_service.primary_access_key
      }
    }
  }
}
