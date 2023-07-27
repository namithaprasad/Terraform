resource "azurerm_storage_account" "logicapp_std_storage" {
    name                     = "${var.context_prefix}strplatlasta${var.environment_name}"
    resource_group_name      = data.azurerm_resource_group.eai_resource_group.name
    location                 = data.azurerm_resource_group.eai_resource_group.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}