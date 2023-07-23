# output "virtual_machine_id" {
#     value = var.az != null ? azurerm_windows_virtual_machine.vm[0].id : azurerm_windows_virtual_machine.vm_noaz[0].id
# }

output "virtual_machine_id" {
  value = var.enable_legacy_vm_module == false ? azurerm_windows_virtual_machine.vm[0].id : azurerm_virtual_machine.vm[0].id
}

output "network_interface_id" {
  value = azurerm_network_interface.nic.id
}

output "network_interface_name" {
  value = azurerm_network_interface.nic.name
}
output "ipaddress" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "ipconfig_name" {
  value = azurerm_network_interface.nic.ip_configuration[0].name
}


output "password" {
  value = var.generate_password == true && var.store_password_in_key_vault == true ? azurerm_key_vault_secret.password[0].value : null
}

output "virtual_machine" {
  value = azurerm_windows_virtual_machine.vm
}

output "diskencryptionset_id" {
  value = var.enable_disk_encryption != false ? azurerm_disk_encryption_set.des[0].id : null
}

output "subnet_id" {
  value = data.azurerm_subnet.snet.id
}
output "all_network_interface_ids" {
  value = var.additional_nics == 0 ? [azurerm_network_interface.nic.id] : concat([azurerm_network_interface.nic.id], azurerm_network_interface.additional_nics.*.id)
}

output "all_ipconfigs" {
  value = var.additional_nics == 0 ? [azurerm_network_interface.nic.ip_configuration] : concat([azurerm_network_interface.nic.ip_configuration], azurerm_network_interface.additional_nics.*.ip_configuration)
}


output "data_disks" {
  value = azurerm_managed_disk.datadisk
}
