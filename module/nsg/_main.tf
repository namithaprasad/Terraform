# data "azurerm_application_security_group" "ActiveDirectoryMember" {
#     name                        = "ActiveDirectoryMember"
#     resource_group_name         = var.resource_group_name
# }
# data "azurerm_application_security_group" "OutboundInternet" {
#     name                        = "OutboundInternet"
#     resource_group_name         = var.resource_group_name
# }

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}

resource "azurerm_subnet_network_security_group_association" "snet" {
  count                     = var.attach_nsg == true ? 1 : 0
  depends_on                = [azurerm_network_security_group.nsg]
  subnet_id                 = data.azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_watcher_flow_log" "flowlog" {
  count                = var.networkwatcher_name != null ? 1 : 0
  network_watcher_name = var.networkwatcher_name
  resource_group_name  = var.resource_group_name

  network_security_group_id = azurerm_network_security_group.nsg.id
  storage_account_id        = var.storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.flowlog_la_workspace_id #"1306c153-3ad8-4d8a-96b1-062c82bb76f8"
    workspace_region      = var.networkwatcher_workspace_region == "" ? var.location : var.networkwatcher_workspace_region
    workspace_resource_id = var.flowlog_la_workspace_resource_id #"/subscriptions/c17fbe3e-440e-4b6a-a9c5-8659189e2c45/resourcegroups/rg-prd-mgt-services-001/providers/Microsoft.OperationalInsights/workspaces/log-prd-mgt-shd-001"
    interval_in_minutes   = 10
  }
}
