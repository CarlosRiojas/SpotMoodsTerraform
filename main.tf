terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
     random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9a2a6572-571b-46f4-97ce-701da5542e96"
}

module "static_website" {
  source              = "./modules/static_website"
  resource_group_name = var.resource_group_name
  location            = var.location
}