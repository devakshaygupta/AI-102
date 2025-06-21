module "resource_group" {
  source = "./modules/resource_group"
  parameters = {
    resource_group_location = var.resource_group_location
  }
}

module "ai_foundry" {
  count = var.ai_foundry_required ? 1 : 0
  source = "./modules/ai_foundry"
  parameters = {
    resource_group_name     = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
    ai_service_endpoint = module.ai_service[0].ai_service_endpoint
    ai_service_id = module.ai_service[0].ai_service_id
    ai_service_primary_access_key = module.ai_service[0].primary_access_key
  }
  depends_on = [module.resource_group]
}

module "ai_service" {
  count = var.ai_service_required ? 1 : 0
  source = "./modules/ai_service"
  parameters = {
    resource_group_id     = module.resource_group.resource_group_id
    resource_group_name   = module.resource_group.resource_group_name
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

module "ai_agent_service" {
  count = var.ai_agent_required ? 1 : 0
  source = "./modules/ai_agent_service"
  parameters = {
    resource_group_id     = module.resource_group.resource_group_id
    resource_group_name   = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
  }
  depends_on = [module.resource_group]
}

module "ai_language_service" {
  source = "./modules/ai_language_service"
  parameters = {
    resource_group_id     = module.resource_group.resource_group_id
    resource_group_name   = module.resource_group.resource_group_name
    resource_group_location = var.resource_group_location
    ai_search_service_id = var.ai_search_required ? module.ai_search_service[0].ai_search_service_id : null
    ai_search_primary_access_key = var.ai_search_required ? module.ai_search_service[0].ai_search_primary_access_key : null
  }
  depends_on = [module.resource_group]
}
