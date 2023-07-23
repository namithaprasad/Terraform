output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.vm[0].id
}

output "network_interface_id" {
  value = azurerm_network_interface.nic.id
}

output "password" {
  value = var.generate_password ? azurerm_key_vault_secret.password[0].value : ""
}

output "ipconfig_name" {
  value = azurerm_network_interface.nic.ip_configuration[0].name
}

output "all_network_interface_ids" {
  value = var.additional_nics == 0 ? [azurerm_network_interface.nic.id] : concat([azurerm_network_interface.nic.id], azurerm_network_interface.additional_nics.*.id)
}

output "all_ipconfigs" {
  value = var.additional_nics == 0 ? [azurerm_network_interface.nic.ip_configuration] : concat([azurerm_network_interface.nic.ip_configuration], azurerm_network_interface.additional_nics.*.ip_configuration)
}
