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
  count = length(var.data_disk_size_gb)

  name = var.data_disk_names == [] ? "${var.name}_data00${count.index + 1}" : var.data_disk_names[count.index]

  location             = var.location
  tags                 = var.tags
  resource_group_name  = var.resource_group_name
  zone                = var.az == null ? null : var.az # changed from zones to zone due to version upgrade
  disk_size_gb         = element(var.data_disk_size_gb, count.index)
  create_option        = "Empty"
  storage_account_type = var.storage_account_type     # Added variable to correct the code drift

  disk_encryption_set_id = var.enable_disk_encryption != false ? azurerm_disk_encryption_set.des[0].id : null


  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "attachdisk" {
  depends_on = [azurerm_managed_disk.datadisk]
  count      = length(var.data_disk_size_gb)

  managed_disk_id    = azurerm_managed_disk.datadisk.*.id[count.index]
  virtual_machine_id = azurerm_linux_virtual_machine.vm[0].id
  lun                = count.index + 1
  caching            = element(var.data_disk_caching, count.index)
}
