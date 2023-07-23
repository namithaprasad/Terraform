locals {
  password = random_password.password.result
}

data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_subnet" "additional_nic_snets" {
  count                = length(var.additional_nic_subnetnames)
  name                 = var.additional_nic_subnetnames[count.index]
  virtual_network_name = var.vnet
  resource_group_name  = var.vnet_resource_group
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

resource "random_password" "password" {
  length  = 30
  special = false
  upper   = true
  numeric = true
}

data "azurerm_application_security_group" "asg" {
  count = var.asg_names != null ? length(var.asg_names) : 0

  name                = element(var.asg_names, count.index)
  resource_group_name = var.asg_resource_group_name
}
