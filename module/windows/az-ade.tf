resource "azurerm_virtual_machine_extension" "diskencryption" {
  count                      = var.enable_disk_encryption_ADE ? 1 : 0
  name                       = "${var.name}-diskencryption-ade"
  virtual_machine_id         = azurerm_virtual_machine.vm[0].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = true

  settings   = <<SETTINGS
        {
                "EncryptionOperation":  "${var.encrypt_operation}",
                "KeyEncryptionAlgorithm":  "${var.encryption_algorithm}",
                "KeyVaultURL":  "${local.encryption_kv_uri}",
                "KekVaultResourceId":  "${local.encryption_kv_id}",					
                "KeyEncryptionKeyURL":  "${local.encryption_kv_key_id}",	
                "KeyVaultResourceId":  "${local.encryption_kv_id}",				
                "VolumeType":  "${var.volume_type}"
        }
SETTINGS
  tags       = var.tags
  depends_on = [azurerm_virtual_machine.vm]

    lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }

}
