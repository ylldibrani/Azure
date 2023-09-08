data "azurerm_key_vault" "shared_key_vault" {
  provider            = azurerm.infra
  name                = "keyvault-infra-001"
  resource_group_name = "rg-shared-infra-001"
}

data "azurerm_key_vault_secret" "shared_key_secret_iad1" {
  provider     = azurerm.infra
  name         = "hub-germanywestcentral-vpn-sharedkey-iad1"
  key_vault_id = data.azurerm_key_vault.shared_key_vault.id
}

data "azurerm_key_vault_secret" "shared_key_secret_fra1" {
  provider     = azurerm.infra
  name         = "hub-germanywestcentral-vpn-sharedkey-fra1"
  key_vault_id = data.azurerm_key_vault.shared_key_vault.id
}

data "azurerm_key_vault_secret" "shared_key_secret_cem" {
  provider     = azurerm.infra
  name         = "hub-germanywestcentral-vpn-sharedkey-cem"
  key_vault_id = data.azurerm_key_vault.shared_key_vault.id
}

data "azurerm_key_vault_secret" "shared_key_secret_dus" {
  provider     = azurerm.infra
  name         = "hub-germanywestcentral-vpn-sharedkey-dus"
  key_vault_id = data.azurerm_key_vault.shared_key_vault.id
}