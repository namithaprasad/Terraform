resource "azurerm_key_vault_secret" "username" {
    count                                   = var.store_password_in_key_vault != false ? 1 : 0 

    name                                    = "${var.name}-Username"
    value                                   = var.admin_username
    key_vault_id                            = data.azurerm_key_vault.kv.id

    lifecycle {
        ignore_changes                      = [key_vault_id]
    } 
}

resource "azurerm_key_vault_secret" "password" {
    count                                   = var.store_password_in_key_vault != false ? 1 : 0 
    
    name                                    = "${var.name}-Password"
    value                                   = var.generate_password == false ? var.admin_password : local.password
    key_vault_id                            = data.azurerm_key_vault.kv.id

    lifecycle {
        ignore_changes                      = [key_vault_id, content_type, value]
    } 
}

resource "azurerm_key_vault_key" "des_key" {
    count                                   = var.enable_disk_encryption != false ? 1 : 0 

    name                                    = "${var.name}-EncryptKey"
    key_vault_id                            = data.azurerm_key_vault.kv.id
    key_type                                = "RSA"
    key_size                                = 4096

    key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey",
    ]

    lifecycle {
        ignore_changes                      = [key_vault_id]
    } 
}