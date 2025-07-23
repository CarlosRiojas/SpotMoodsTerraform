output "cdn_endpoint_hostname" {
  description = "The hostname of the Azure Front Door CDN endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.sa.name
}