terraform {
  #required_version = "~> 1.5.4"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.00"
    }
  }
  backend "azurerm" {}
}