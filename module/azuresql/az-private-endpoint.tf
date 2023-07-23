resource "azurerm_private_endpoint" "private_endpoint" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.private_endpoint_subnet.id

  private_service_connection {
    name                           = "${var.sql_server_name}-privateserviceconnection"
    private_connection_resource_id = azurerm_mssql_server.sqlserver.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}


data "azurerm_subnet" "private_endpoint_subnet" {
  name                 = var.private_endpoint_subnet_name
  virtual_network_name = var.private_endpoint_vnet_name
  resource_group_name  = var.private_endpoint_vnet_resource_group_name
}
