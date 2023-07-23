resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.enable_legacy_vm_module == false ? 1 : 0
  name                = var.name
  tags                = var.tags
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  computer_name       = var.name
  admin_username      = var.admin_username
  admin_password      = var.generate_password == false ? var.admin_password : random_password.password[0].result
  network_interface_ids = var.additional_nics == 0 ? [azurerm_network_interface.nic.id] : concat([azurerm_network_interface.nic.id],
  azurerm_network_interface.additional_nics.*.id)
  zone                         = var.az
  provision_vm_agent           = true
  availability_set_id          = var.availability_set_id
  timezone                     = "British Summer Time"
  proximity_placement_group_id = var.ppg_id
  license_type                 = "Windows_Server"
  enable_automatic_updates     = false #var.patch_mode == "AutomaticByOS" ? true : false
  allow_extension_operations   = true
  patch_mode                   = var.patch_mode

  boot_diagnostics {
    storage_account_uri = var.storage_account
  }

  source_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  os_disk {
    name                   = var.os_disk_name == null ? "${var.name}_osdisk" : var.os_disk_name
    caching                = "ReadWrite"
    storage_account_type   = var.storage_account_type   #Added variable to correct the code drift
    disk_size_gb           = var.os_disk_size_gb
    disk_encryption_set_id = var.enable_disk_encryption != false ? azurerm_disk_encryption_set.des[0].id : null
  }

  #additional_capabilities
  #additional_unattend_content
  #custom_data
  #virtual_machine_scale_set_id

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"], identity, admin_password]
  }
  depends_on = [
    time_sleep.wait_5_seconds,
    azurerm_key_vault_access_policy.des
  ]
}

resource "azurerm_management_lock" "vm" {
  depends_on = [azurerm_windows_virtual_machine.vm]
  count      = var.vm_lock == true && var.enable_legacy_vm_module == false ? 1 : 0
  name       = "Virtual Machine Lock"
  scope      = azurerm_windows_virtual_machine.vm[0].id
  lock_level = "CanNotDelete"
  notes      = "This is a locked Resource"
}
