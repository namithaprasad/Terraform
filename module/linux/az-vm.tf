locals {
  source_image_reference = {
    image_details = {
      os_publisher = var.os_publisher
      os_offer     = var.os_offer
      os_sku       = var.os_sku
      os_version   = var.os_version
    }
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  count               = 1
  name                = var.name
  tags                = var.tags
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  computer_name       = var.name
  admin_username      = var.admin_username
  admin_password      = var.generate_password == false ? var.admin_password : local.password
  network_interface_ids = var.additional_nics == 0 ? [azurerm_network_interface.nic.id] : concat([azurerm_network_interface.nic.id],
  azurerm_network_interface.additional_nics.*.id)
  zone = var.az
  # availability_set_id                     = var.availability_set_id
  proximity_placement_group_id    = var.ppg_id
  allow_extension_operations      = true
  disable_password_authentication = false
  source_image_id                 = var.source_image_id == "" ? null : var.source_image_id

  boot_diagnostics {
    storage_account_uri = var.storage_account
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_id == "" ? local.source_image_reference : {}

    content {
      publisher = source_image_reference.value.os_publisher
      offer     = source_image_reference.value.os_offer
      sku       = source_image_reference.value.os_sku
      version   = source_image_reference.value.os_version
    }
  }
  # source_image_reference {
  #   publisher = var.os_publisher
  #   offer     = var.os_offer
  #   sku       = var.os_sku
  #   version   = var.os_version
  # }


  dynamic "plan" {
    for_each = var.plan == null ? {} : var.plan
    content {
      name      = plan.value.name
      product   = plan.value.product
      publisher = plan.value.publisher
    }
  }

  os_disk {
    name                   = var.custom_os_disk_name == "" ? "${var.name}_osdisk" : var.custom_os_disk_name
    caching                = "ReadWrite"
    storage_account_type   = var.storage_account_type     # Added variable type to correct the code drift
    disk_size_gb           = var.os_disk_size_gb
    disk_encryption_set_id = var.enable_disk_encryption != false ? azurerm_disk_encryption_set.des[0].id : null
  }

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"], identity, admin_password]
  }
}

resource "azurerm_management_lock" "vm" {
  depends_on = [azurerm_linux_virtual_machine.vm]
  count      = var.vm_lock == true ? 1 : 0
  name       = "Virtual Machine Lock"
  scope      = azurerm_linux_virtual_machine.vm[0].id
  lock_level = "CanNotDelete"
  notes      = "This is a locked Resource"
}
