locals {
  defaultIpConfig = {
    default = {
      ipconfig_name  = var.ipconfig_name
      static_ip      = var.static_ip
      static_ip_addr = var.static_ip_addr
      primary        = true
    }
  }
}
resource "azurerm_network_interface" "nic" {
  name                = "${var.name}_nic"
  location            = var.location
  tags                = var.tags
  resource_group_name = var.resource_group_name

  enable_accelerated_networking = var.enabled_accelerated_networking
  enable_ip_forwarding          = var.enable_ip_forwarding

  ip_configuration {
    name                          = "${var.name}_ipconfig"
    subnet_id                     = data.azurerm_subnet.snet.id
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = var.static_ip == true ? "Static" : "Dynamic"
    private_ip_address            = var.static_ip == true ? var.static_ip_addr : 0
    primary                       = true
  }

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"], ip_configuration[0].private_ip_address]
  }
}



resource "azurerm_network_interface" "additional_nics" {
  count                         = var.additional_nics
  name                          = length(var.additional_nic_names) == 0 ? "${var.name}_nic_${count.index + 2}" : var.additional_nic_names[count.index]
  location                      = var.location
  tags                          = var.tags
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.enabled_accelerated_networking
  enable_ip_forwarding          = length(var.additional_nic_ipforwarding) == 0 ? var.enable_ip_forwarding : var.additional_nic_ipforwarding[count.index]

  dynamic "ip_configuration" {
    for_each = var.multiple_ips != null ? var.multiple_ips : local.defaultIpConfig
    content {
      name                          = ip_configuration.value.ipconfig_name == null ? "${var.name}_nic_${count.index + 2}_ipconfig" : ip_configuration.value.ipconfig_name
      subnet_id                     = data.azurerm_subnet.additional_nic_snets[count.index].id
      private_ip_address_version    = "IPv4"
      private_ip_address_allocation = ip_configuration.value.static_ip == true ? "Static" : "Dynamic"
      private_ip_address            = ip_configuration.value.static_ip == true ? ip_configuration.value.static_ip_addr : null
      primary                       = ip_configuration.value.primary
      public_ip_address_id          = length(var.additional_nics_publicIpResourceIds) == 0 ? null : var.additional_nics_publicIpResourceIds[count.index]
    }
  }

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"], ip_configuration[0].private_ip_address]
  }
}
