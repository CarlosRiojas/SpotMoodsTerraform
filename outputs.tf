output "website_url" {
  description = "The URL of the deployed static website."
  value       = "https://${module.static_website.cdn_endpoint_hostname}"
}

output "cdn_endpoint_hostname" {
  description = "The default hostname of the Azure CDN endpoint."
  value       = module.static_website.cdn_endpoint_hostname
}

output "storage_account_name" {
  description = "The name of the Azure Storage Account."
  value       = module.static_website.storage_account_name
}