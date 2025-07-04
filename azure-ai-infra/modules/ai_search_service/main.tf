resource "random_pet" "ai_search_service_name" {}

resource "azurerm_search_service" "ai_search_service" {
  name                = random_pet.ai_search_service_name.id
  resource_group_name = var.parameters["resource_group_name"]
  location            = var.parameters["resource_group_location"]
  sku                 = "free"
}
