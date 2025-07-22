# Create a resource group to contain all resources
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# This resource generates a random, 8-character lowercase alphanumeric string
resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  # The new name uses a fixed prefix + the random string to ensure it's unique
  name                     = "stspotifymoods${random_string.unique.result}"
  resource_group_name      = var.resource_group_name # This assumes you have a resource_group_name variable defined in the module
  location                 = var.location # This assumes you have a location variable defined in the module
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_static_website" "sa_static_website" {
  storage_account_id = azurerm_storage_account.sa.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

# Create a CDN profile
resource "azurerm_cdn_profile" "profile" {
  name                = "${var.resource_group_name}-cdn-profile"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard_Verizon"
}

# Create a CDN endpoint pointing to the storage account's static website host
resource "azurerm_cdn_endpoint" "endpoint" {
  name                = "${var.resource_group_name}-cdn-endpoint"
  profile_name        = azurerm_cdn_profile.profile.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  is_http_allowed     = true
  is_https_allowed    = true

  origin {
    name      = "storage-origin"
    host_name = azurerm_storage_account.sa.primary_web_host
  }

}
  
