resource "azurerm_network_interface_application_security_group_association" "asg" {
  count = var.asg_names != null ? length(var.asg_names) : 0

  network_interface_id          = azurerm_network_interface.nic.id
  application_security_group_id = data.azurerm_application_security_group.asg.*.id[count.index]
  
  lifecycle {
    ignore_changes = [
      application_security_group_id
    ] # testing
  }
}

resource "azurerm_network_interface_application_security_group_association" "additional_nics_asg" {
  count                         = var.additional_nics > 0 && var.asg_names != null ? var.additional_nics * length(var.asg_names) : 0
  network_interface_id          = azurerm_network_interface.additional_nics[floor(count.index / length(var.asg_names))].id
  application_security_group_id = data.azurerm_application_security_group.asg.*.id[count.index % length(var.asg_names)]
}