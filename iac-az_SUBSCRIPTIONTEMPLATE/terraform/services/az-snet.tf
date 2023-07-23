resource "azurerm_subnet" "snet" {
    depends_on                  = [azurerm_virtual_network.vnet]
    count                       = length(var.vnet_config.vnet1.subnet_names)
    name                        = element(var.vnet_config.vnet1.subnet_names, count.index)
    resource_group_name         = azurerm_resource_group.rg_services.name
    virtual_network_name        = var.vnet_config.vnet1.vnet_name
    address_prefixes            = [element(var.vnet_config.vnet1.subnet_cidrs, count.index)]
}

resource "azurerm_subnet" "snet_bst" {
    depends_on                  = [azurerm_virtual_network.vnet]
    name                        = "AzureBastionSubnet"
    resource_group_name         = azurerm_resource_group.rg_services.name
    virtual_network_name        = var.vnet_config.vnet1.vnet_name
    address_prefixes            = [var.vnet_config.vnet1.subnet_cidr_bastion]

}
