locals {
  encryption_kv_uri    = data.azurerm_key_vault.kv.vault_uri
  encryption_kv_id     = data.azurerm_key_vault.kv.id
  encryption_kv_key_id = (var.kv_key_id == null || var.kv_key_id == "") && (var.enable_disk_encryption != false || var.enable_disk_encryption_ADE != false) ? azurerm_key_vault_key.des_key[0].id : var.kv_key_id
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
  count       = var.generate_password == true ? 1 : 0
  length      = 30
  special     = false
  upper       = true
  numeric     = true
  min_lower   = 1
  min_numeric = 1
  min_special = 0
  min_upper   = 1
  lifecycle {
    ignore_changes = [min_lower, min_numeric, min_special, min_upper]
  }
}

data "azurerm_application_security_group" "asg" {
  count = var.asg_names != null ? length(var.asg_names) : 0

  name                = element(var.asg_names, count.index)
  resource_group_name = var.asg_resource_group_name
}
