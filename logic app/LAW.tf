resource "azurerm_log_analytics_workspace" "platform_logicapp_logs" {
    name                = "${var.context_prefix}-log-platform-logicapps-${var.environment_name}"
    location            = data.azurerm_resource_group.eai_resource_group.location
    resource_group_name = data.azurerm_resource_group.eai_resource_group.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
}