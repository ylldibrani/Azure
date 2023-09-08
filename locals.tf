locals {
    tags = merge(var.tags, 
    {
        Region          = var.location
        Env             = var.environment
        DeployedBy      = var.deployedby
    })
}

data "terraform_remote_state" "hub-vnet" {
  backend = "azurerm"

  config = {
    key                  = var.hub_vnet_remote_state.key
    resource_group_name  = var.hub_vnet_remote_state.resource_group_name
    storage_account_name = var.hub_vnet_remote_state.storage_account_name
    container_name       = var.hub_vnet_remote_state.container_name
    }
}