resource "random_pet" "dns_name_label" {}

resource "random_pet" "container_group_name" {
  prefix = var.container_group_name_prefix
}

resource "random_pet" "container_name" {
  prefix = var.container_name_prefix
}

resource "azurerm_container_group" "ai_services_container" {
  count               = var.create_container_group ? 1 : 0
  name                = random_pet.container_group_name.id
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = var.container_ip_address_type
  dns_name_label      = random_pet.dns_name_label.id
  os_type             = var.container_os_type
  sku                 = var.container_group_sku
  restart_policy      = var.container_restart_policy

  container {
    name   = random_pet.container_name.id
    image  = var.container_image
    cpu    = var.number_of_cpus
    memory = var.size_of_ram

    ports {
      port     = var.container_port
      protocol = "TCP"
    }

    environment_variables = {
      "Eula" = "Accept"
    }

    secure_environment_variables = {
      "ApiKey"  = azurerm_cognitive_account.ai_service.primary_access_key
      "Billing" = azurerm_cognitive_account.ai_service.endpoint
    }
  }

}
