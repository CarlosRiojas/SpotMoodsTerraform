resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sa" {
  name                     = "stspotifymoods${random_string.unique.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_static_website" "sa_static_website" {
  storage_account_id = azurerm_storage_account.sa.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

resource "azurerm_cdn_frontdoor_profile" "profile" {
  name                = "${var.resource_group_name}-afd-profile"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "afd-ep-${var.resource_group_name}-${random_string.unique.result}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
}


resource "azurerm_cdn_frontdoor_origin" "origin" {
  name                          = "origin-storage-account"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
  enabled                       = true
  host_name                     = azurerm_storage_account.sa.primary_web_host
  http_port                     = 80
  https_port                    = 443
  origin_host_header            = azurerm_storage_account.sa.primary_web_host
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "route-to-storage"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                     = "og-static-website"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.profile.id
  session_affinity_enabled = true

  # Add this required block
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 2
  }
}