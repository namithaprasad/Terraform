locals {
    #name,access,protocol,src_port,dst_port,src_addr,dst_addr,direction
    nsg_rules_bst = [
        ["HTTPS","Allow","TCP","*","443","Internet","*","Inbound"],
        ["GatewayManager","Allow","TCP","*","443","GatewayManager","*","Inbound"],
        ["SSH","Allow","TCP","*","22","*","VirtualNetwork","Outbound"],
        ["RDP","Allow","TCP","*","3389","*","VirtualNetwork","Outbound"],
        ["AzureCloudHTTPS","Allow","TCP","*","443","*","AzureCloud","Outbound"],
    ]
}

resource "azurerm_network_security_rule" "bst" {
    depends_on                            = [azurerm_network_security_rule.outbound_internet_deny]
    count                                 = var.bastion == true ? length(local.nsg_rules_bst) : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = local.nsg_rules_bst[count.index][0]
    priority                              = 100+count.index
    access                                = local.nsg_rules_bst[count.index][1]
    protocol                              = local.nsg_rules_bst[count.index][2]
    source_port_range                     = local.nsg_rules_bst[count.index][3]
    destination_port_range                = local.nsg_rules_bst[count.index][4]
    source_address_prefix                 = local.nsg_rules_bst[count.index][5]
    destination_address_prefix            = local.nsg_rules_bst[count.index][6]
    direction                             = local.nsg_rules_bst[count.index][7]
}

# resource "time_sleep" "bst" {
#     count                                 = var.bastion == true ? length(local.nsg_rules_bst) : 0
#     create_duration                       = "30s"

#     triggers = {
#         bst_id = azurerm_network_security_rule.bst[length(local.nsg_rules_bst)-1].id
#     }
# }
