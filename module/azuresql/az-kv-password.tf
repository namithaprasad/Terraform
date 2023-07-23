resource "azurerm_key_vault_secret" "username" {
  count        = var.store_password_in_key_vault != false ? 1 : 0
  name         = "${var.sql_server_name}-Username"
  value        = var.sql_administrator_login
  key_vault_id = data.azurerm_key_vault.kv.id
  lifecycle {
    ignore_changes = [key_vault_id]
  }
}

resource "azurerm_key_vault_secret" "password" {
  count        = var.store_password_in_key_vault && var.generate_password ? 1 : 0
  name         = "${var.sql_server_name}-Password"
  value        = random_password.password[0].result
  key_vault_id = data.azurerm_key_vault.kv.id
  lifecycle {
    ignore_changes = [key_vault_id,content_type, value]
  }
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

resource "random_password" "password" {
  count       = var.generate_password == true ? 1 : 0
  length      = 30
  special     = false
  upper       = true
  numeric      = true
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  min_upper   = 1
  lifecycle {
    ignore_changes = [min_lower, min_numeric, min_special, min_upper]
  }
}
