provider "azurerm" {
  #subscription_id = "52d3f978-ecf3-4aa5-8344-f29971d0d149"
  features {}
}

provider "azurerm" {
  subscription_id = "515a6d0a-79e1-461c-bf0e-201ba59e5963"
  alias = "infra"
  features {}
}