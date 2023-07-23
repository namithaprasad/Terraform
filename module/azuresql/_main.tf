resource "azurerm_mssql_server" "sqlserver" {
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login          = var.sql_administrator_login
  administrator_login_password = random_password.password[0].result
  connection_policy            = var.sql_connection_policy
  version                      = var.sql_version

  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled

  tags = merge(var.tags, {})
  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"],
      administrator_login_password,
    azuread_administrator]
  }
}

resource "azurerm_sql_database" "sqldb" {
  for_each            = var.sqldbs
  name                = each.value.sqldb_name
  resource_group_name = var.resource_group_name
  location            = var.location

  collation   = each.value.sql_collation
  edition     = each.value.sql_edition
  max_size_gb = each.value.sql_max_size_gb
  read_scale  = each.value.sql_read_scale

  requested_service_objective_name = each.value.sql_requested_service_objective_name
  server_name                      = azurerm_mssql_server.sqlserver.name
  zone_redundant                   = each.value.sql_zone_redundant
  threat_detection_policy {
    disabled_alerts      = []
    email_account_admins = "Disabled"
    email_addresses      = []
    retention_days       = 0
    state                = "Disabled"
  }

  tags = merge(var.tags, each.value.tags)
  lifecycle {
    ignore_changes = [tags["CreatedTime"],
      tags["CreatedBy"],
      tags["CreatedByPipelineStage"],
    create_mode]
  }
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  count               = length(var.sql_vnet_rule_subnet_ids)
  name                = "sql-vnet-rule-${count.index + 1}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sqlserver.name
  subnet_id           = var.sql_vnet_rule_subnet_ids[count.index]
}
