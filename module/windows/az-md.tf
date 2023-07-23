# Immedialy after keyvault access policies are added, it takes a few seconds for it 
# to become applicable for consumption by other resources.
# Eg. Data Disk creation (with encryption) will fail without waiting few seconds for the kv access  policies
# to become 'effective'. 
resource "time_sleep" "wait_5_seconds" {
  depends_on = [
    azurerm_disk_encryption_set.des,
    azurerm_key_vault_key.des_key,
    azurerm_key_vault_access_policy.des,
    azurerm_role_assignment.des_kv_reader,
    azurerm_role_assignment.des_kv_crypto_service_encryption
  ]

  create_duration = "5s"
}

resource "azurerm_managed_disk" "datadisk" {
  depends_on = [
    time_sleep.wait_5_seconds
  ]
  count                = length(var.data_disk_size_gb)
  name                 = length(var.data_disk_names) == 0 ? "${var.name}_data00${count.index + 1}" : var.data_disk_names[count.index]
  location             = var.location
  tags                 = var.tags
  resource_group_name  = var.resource_group_name
  zone                 = var.az == null ? null : var.az # changed from zones to zone due to version upgrade
  disk_size_gb         = element(var.data_disk_size_gb, count.index)
  create_option        = length(var.data_disk_create_options) == 0 ? "Empty" : var.data_disk_create_options[count.index]
  storage_account_type = var.storage_account_type   # Added variable to correct the code drift

  disk_encryption_set_id = var.enable_disk_encryption != false ? azurerm_disk_encryption_set.des[0].id : null

  # Template example
  # dynamic "encryption_settings" {
  # for_each = var.encryption_settings
  #     content {
  #         enabled = encryption_settings.value["enabled"]
  #         dynamic "disk_encryption_key" {
  #             for_each = encryption_settings.value.disk_encryption_key
  #             content {
  #                 secret_url      = disk_encryption_key.value["secret_url"]
  #                 source_vault_id = disk_encryption_key.value["source_vault_id"]
  #             }
  #         }
  #         dynamic "key_encryption_key" {
  #             for_each = encryption_settings.value.key_encryption_key
  #             content {
  #                 key_url         = key_encryption_key.value["key_url"]
  #                 source_vault_id = key_encryption_key.value["source_vault_id"]
  #             }
  #         }
  #     }
  # }

  lifecycle {
    ignore_changes = [encryption_settings, create_option, tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachdisk" {
  depends_on         = [azurerm_managed_disk.datadisk]
  count              = length(var.data_disk_size_gb)
  managed_disk_id    = azurerm_managed_disk.datadisk.*.id[count.index]
  virtual_machine_id = var.enable_legacy_vm_module == false ? azurerm_windows_virtual_machine.vm[0].id : azurerm_virtual_machine.vm[0].id
  lun                = length(var.data_disk_luns) > 0 ? var.data_disk_luns[count.index] : count.index + 1
  caching            = element(var.data_disk_caching, count.index)
}
