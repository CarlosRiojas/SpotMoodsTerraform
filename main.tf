terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "static_website" {
  source              = "./modules/static_website"
  resource_group_name = var.resource_group_name
  location            = var.location
}