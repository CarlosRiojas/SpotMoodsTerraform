variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
  default     = "mood-player-rg"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "East US"
}
