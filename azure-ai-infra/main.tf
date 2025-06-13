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
