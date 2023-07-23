resource "azurerm_disk_encryption_set" "des" {
  count               = var.enable_disk_encryption != false ? 1 : 0
  tags                = var.tags
  name                = "${var.name}_EncryptionSet"
  location            = var.location
  resource_group_name = var.resource_group_name
  key_vault_key_id    = azurerm_key_vault_key.des_key[0].id

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}

# output "identity" {
#     value = azurerm_disk_encryption_set.des.*.identity.0.principal_id
# }

resource "azurerm_role_assignment" "des_kv_crypto_service_encryption" {
  depends_on           = [azurerm_disk_encryption_set.des]
  count                = var.enable_disk_encryption != false ? 1 : 0
  scope                = data.azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des[0].identity.0.principal_id
}

resource "azurerm_role_assignment" "des_kv_reader" {
  depends_on           = [azurerm_disk_encryption_set.des]
  count                = var.enable_disk_encryption != false ? 1 : 0
  scope                = data.azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_disk_encryption_set.des[0].identity.0.principal_id
}

resource "azurerm_key_vault_access_policy" "des" {
  depends_on   = [azurerm_disk_encryption_set.des]
  count        = var.enable_disk_encryption != false ? 1 : 0
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = azurerm_disk_encryption_set.des[0].identity.0.tenant_id
  object_id    = azurerm_disk_encryption_set.des[0].identity.0.principal_id

  key_permissions = [ # camel case in version 3.32.0
    "Decrypt",
    "Encrypt",
    "Sign",
    "UnwrapKey",
    "Verify",
    "WrapKey",
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}
