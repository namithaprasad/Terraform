locals {
#    asg_vnetsmb_id = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/applicationSecurityGroups/VNetSMB"

    #name,access,protocol,src_port,dst_port,src_addr,dst_addr,direction
    nsg_rules_default1 = [
        ["AllowSubnetIn","Allow","*","*","*",data.azurerm_subnet.snet.address_prefixes,data.azurerm_subnet.snet.address_prefixes,"Inbound"],
        ["AllowSubnetOut","Allow","*","*","*",data.azurerm_subnet.snet.address_prefixes,data.azurerm_subnet.snet.address_prefixes,"Outbound"],
        ["AllowBastionSSHIn","Allow","TCP","*","22",[var.bastion_cidr],data.azurerm_subnet.snet.address_prefixes,"Inbound"],
        ["AllowBastionRDPIn","Allow","TCP","*","3389",[var.bastion_cidr],data.azurerm_subnet.snet.address_prefixes,"Inbound"],
        ["AllowToProxyOut","Allow","TCP","*","8080",data.azurerm_subnet.snet.address_prefixes,["10.0.0.0"],"Outbound"],
        ["AllowQualysOut","Allow","TCP","*","443",data.azurerm_subnet.snet.address_prefixes,["10.0.0.0","10.0.0.0"],"Outbound"],
    ]
    nsg_rules_default2 = [
        ["BlockVnetIn","Deny","*","*","*","VirtualNetwork","*","Inbound"],
        ["AllowAzureActiveDirectoryOut","Allow","*","*","*","VirtualNetwork","AzureActiveDirectory","Outbound"],
        ["AllowAzureBackupOut","Allow","*","*","*","VirtualNetwork","AzureBackup","Outbound"],
        ["AllowAzureKeyVaultOut","Allow","*","*","*","VirtualNetwork","AzureKeyVault","Outbound"],
        ["AllowAzureMonitorOut","Allow","*","*","*","VirtualNetwork","AzureMonitor","Outbound"],
        ["AllowStorageOut","Allow","*","*","*","VirtualNetwork","Storage","Outbound"],
        ["AllowAzureAdvancedThreatProtectionOut","Allow","*","*","*","VirtualNetwork","AzureAdvancedThreatProtection","Outbound"],
        ["AllowOutboundWindowsActivation","Allow","TCP","*","1688","VirtualNetwork","Internet","Outbound"],
#        ["AllowAzurePlatformLKMOut","Allow","*","*","*","VirtualNetwork","AzurePlatformLKM","Outbound"],
#        ["BlockVnetOut","Deny","*","*","*","VirtualNetwork","*","Outbound"],
    ]

}

resource "azurerm_network_security_rule" "default1" {
    depends_on                            = [azurerm_network_security_group.nsg]
    count                                 = var.rules_default == true ? length(local.nsg_rules_default1) : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = local.nsg_rules_default1[count.index][0]
    priority                              = 4000+count.index
    access                                = local.nsg_rules_default1[count.index][1]
    protocol                              = local.nsg_rules_default1[count.index][2]
    source_port_range                     = local.nsg_rules_default1[count.index][3]
    destination_port_range                = local.nsg_rules_default1[count.index][4]
    source_address_prefixes               = local.nsg_rules_default1[count.index][5]
    destination_address_prefixes          = local.nsg_rules_default1[count.index][6]
    direction                             = local.nsg_rules_default1[count.index][7]
}

resource "azurerm_network_security_rule" "default2" {
    depends_on                            = [azurerm_network_security_group.nsg,azurerm_network_security_rule.default1]
    count                                 = var.rules_default == true ? length(local.nsg_rules_default2) : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = local.nsg_rules_default2[count.index][0]
    priority                              = 4020+count.index
    access                                = local.nsg_rules_default2[count.index][1]
    protocol                              = local.nsg_rules_default2[count.index][2]
    source_port_range                     = local.nsg_rules_default2[count.index][3]
    destination_port_range                = local.nsg_rules_default2[count.index][4]
    source_address_prefix                 = local.nsg_rules_default2[count.index][5]
    destination_address_prefix            = local.nsg_rules_default2[count.index][6]
    direction                             = local.nsg_rules_default2[count.index][7]
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
