locals {
    asg_outboundinternet_id = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/applicationSecurityGroups/OutboundInternet"
}

resource "azurerm_network_security_rule" "outbound_internet_allow" {
    depends_on                            = [azurerm_network_security_group.nsg]
    count                                 = var.outbound_internet == true ? 1 : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = "AllowOutboundInternet"
    priority                              = 4090
    access                                = "Allow"
    protocol                              = "*"
    source_port_range                     = "*"
    destination_port_range                = "*"
    source_application_security_group_ids = [local.asg_outboundinternet_id]
#    source_address_prefix = "*"
    destination_address_prefix            = "Internet"
    direction                             = "Outbound"
}
# resource "azurerm_network_security_rule" "outbound_internet_allow_activation" {
#     depends_on                            = [azurerm_network_security_group.nsg]
#     #count                                 = var.outbound_internet == true ? 1 : 0
#     resource_group_name                   = var.resource_group_name
#     network_security_group_name           = azurerm_network_security_group.nsg.name
#     name                                  = "AllowOutboundWindowsActivation"
#     priority                              = 4091
#     access                                = "Allow"
#     protocol                              = "TCP"
#     source_port_range                     = "*"
#     destination_port_range                = "1688"
#     source_address_prefix                 = "*"
#     destination_address_prefix            = "Internet"
#     direction                             = "Outbound"
# }
# resource "azurerm_network_security_rule" "outbound_internet_allow_qualys" {
#     depends_on                            = [azurerm_network_security_group.nsg]
#     #count                                 = var.outbound_internet == true ? 1 : 0
#     resource_group_name                   = var.resource_group_name
#     network_security_group_name           = azurerm_network_security_group.nsg.name
#     name                                  = "AllowOutboundQualys"
#     priority                              = 4092
#     access                                = "Allow"
#     protocol                              = "TCP"
#     source_port_range                     = "*"
#     destination_port_range                = "443"
#     source_address_prefixes                 = data.azurerm_subnet.snet.address_prefixes
#     destination_address_prefixes          = ["10.0.0.0"]
#     direction                             = "Outbound"
# }


resource "azurerm_network_security_rule" "outbound_internet_deny" {
    depends_on                            = [azurerm_network_security_group.nsg] #[azurerm_network_security_rule.outbound_internet_allow]
    #count                                 = var.outbound_internet == false ? 1 : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = "DenyOutboundInternet"
    priority                              = 4096
    access                                = "Deny"
    protocol                              = "*"
    source_port_range                     = "*"
    destination_port_range                = "*"
    source_address_prefix                 = "*"
    destination_address_prefix            = "Internet"
    direction                             = "Outbound"
}
