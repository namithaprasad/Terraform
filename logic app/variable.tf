variable "environment_name" {
  type = string
  default = "dev"
}

variable "eai_resource_group" {
  type = string
  default = "Platform_LogicApp_Standard"
}

variable "context_prefix" {
  type = string
  default = "ms"
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "eai_resource_group" {
  name     = var.eai_resource_group
}



