# Virtual machine admin login username
resource "azurerm_key_vault_secret" "username" {
  count        = var.store_password_in_key_vault != false ? 1 : 0
  name         = "${var.name}-Username"
  value        = var.admin_username
  key_vault_id = data.azurerm_key_vault.kv.id
  lifecycle {
    ignore_changes = [key_vault_id]
  }
}

# Virtual machine admin login password
resource "azurerm_key_vault_secret" "password" {
  count        = var.store_password_in_key_vault != false ? 1 : 0
  name         = "${var.name}-Password"
  value        = var.generate_password == false ? var.admin_password : random_password.password[0].result
  key_vault_id = data.azurerm_key_vault.kv.id
  lifecycle {
    ignore_changes = [key_vault_id, content_type, value]
  }
}

resource "azurerm_key_vault_key" "des_key" {
  count        = var.enable_disk_encryption != false || var.enable_disk_encryption_ADE != false ? 1 : 0
  name         = "${var.name}-EncryptKey"
  key_vault_id = data.azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  lifecycle {
    ignore_changes = [key_vault_id]
  }
}


# Generate SQL Server admin login password
resource "random_password" "sql_password" {
  count       = var.deployassql && var.sql_generate_admin_password ? 1 : 0
  length      = 30
  special     = false
  upper       = true
  numeric     = true
  min_lower   = 1
  min_numeric = 1
  min_special = 0
  min_upper   = 1
  lifecycle {
    ignore_changes = [min_lower, min_numeric, min_special, min_upper]
  }
}
# SQL Server admin login username
resource "azurerm_key_vault_secret" "sql_admin_username" {
  count        = var.deployassql && var.sql_store_password_in_key_vault ? 1 : 0
  name         = "${var.name}-SQL-Username"
  value        = var.sql_connectivity_update_username
  key_vault_id = data.azurerm_key_vault.kv.id
  lifecycle {
    ignore_changes = [key_vault_id, content_type, value]
  }
}

# SQL Server admin login password

resource "azurerm_key_vault_secret" "sql_admin_password" {
  count        = var.deployassql && var.sql_store_password_in_key_vault && (var.sql_generate_admin_password || var.sql_admin_password != null) ? 1 : 0
  name         = "${var.name}-SQL-Password"
  value        = var.sql_generate_admin_password ? random_password.sql_password[0].result : var.sql_admin_password
  key_vault_id = data.azurerm_key_vault.kv.id
  lifecycle {
    ignore_changes = [key_vault_id, value, content_type]
  }
}

