data "azurerm_client_config" "current" {}

resource "random_pet" "key_vault_name" {
  prefix = var.key_vault_name_prefix
}

resource "random_string" "storage_account_name" {
  length  = 12
  upper   = false
  special = false
}

resource "random_pet" "ai_service_name" {}

resource "azurerm_key_vault" "ai_foundry_key_vault" {
  name                = random_pet.key_vault_name.id
  location            = var.parameters["resource_group_location"]
  resource_group_name = var.parameters["resource_group_name"]
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                 = "standard"
  purge_protection_enabled = true
}

resource "azurerm_key_vault_access_policy" "ai_foundry_key_vault_policy" {
  key_vault_id = azurerm_key_vault.ai_foundry_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Get",
    "Delete",
    "Purge",
    "GetRotationPolicy",
  ]
}

resource "azurerm_storage_account" "ai_foundry_storage_account" {
  name                     = random_string.storage_account_name.result
  location                 = var.parameters["resource_group_location"]
  resource_group_name      = var.parameters["resource_group_name"]
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_ai_foundry" "ai_foundry_hub" {
  name                = "${random_pet.ai_service_name.id}-hub"
  location            = var.parameters["resource_group_location"]
  resource_group_name = var.parameters["resource_group_name"]
  storage_account_id  = azurerm_storage_account.ai_foundry_storage_account.id
  key_vault_id        = azurerm_key_vault.ai_foundry_key_vault.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_ai_foundry_project" "ai_foundry_project" {
  name               = "${random_pet.ai_service_name.id}-project"
  location           = azurerm_ai_foundry.ai_foundry_hub.location
  ai_services_hub_id = azurerm_ai_foundry.ai_foundry_hub.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "ai_foundry_blob_reader" {
  scope                = azurerm_storage_account.ai_foundry_storage_account.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_ai_foundry.ai_foundry_hub.identity[0].principal_id

  depends_on = [azurerm_ai_foundry.ai_foundry_hub, azurerm_storage_account.ai_foundry_storage_account]
}
