resource "azurerm_virtual_network" "vnet" {
    tags                = var.tags
    name                = var.name
    location            = var.location
    resource_group_name = var.resource_group_name
    address_space       = var.address_space
    dns_servers         = var.dns_servers
    lifecycle {
        ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
    }
}
