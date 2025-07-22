output "cdn_endpoint_hostname" {
  description = "The default hostname of the Azure CDN endpoint."
  value       = azurerm_cdn_endpoint.endpoint.host_name
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account."
  value       = azurerm_storage_account.sa.name
}

output "primary_web_host" {
  description = "The primary web endpoint of the storage account."
  value       = azurerm_storage_account.sa.primary_web_host
}