locals {
#    asg_ad_id = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/applicationSecurityGroups/ActiveDirectoryMember" # data.azurerm_application_security_group.ActiveDirectoryMember.id
    asg_ad_id = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/applicationSecurityGroups/OutboundActiveDirectoryMember" # data.azurerm_application_security_group.ActiveDirectoryMember.id
    asg_ad_wvd_id = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/applicationSecurityGroups/OutboundActiveDirectoryMemberWVD" # data.azurerm_application_security_group.ActiveDirectoryMember.id
    ip_alias_ad_dcs = ["10.0.0.0"]
    ip_alias_ca = ["10.0.0.0"]
    ip_alias_cdp = ["10.0.0.0"]

    #name,access,protocol,src_port,dst_port,src_asgs,dst_addrs
    nsg_rules_ad = [
        ["AD-NTP","Allow","UDP","*","123",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-RPC1","Allow","UDP","*","135",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-RPC2","Allow","TCP","*","135",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-RPC3","Allow","TCP","*","49152-65535",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-LDAP1","Allow","TCP","*","389",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-LDAP2","Allow","TCP","*","636",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-LDAP3","Allow","TCP","*","3268-3269",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-LDAP4","Allow","UDP","*","389",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-LDAP5","Allow","UDP","*","636",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-LDAP6","Allow","UDP","*","3268-3269",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-DNS1","Allow","TCP","*","53",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-DNS2","Allow","UDP","*","53",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-KDC1","Allow","TCP","*","636",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-KDC2","Allow","TCP","*","88",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-KDC3","Allow","UDP","*","636",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-KDC4","Allow","UDP","*","88",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["AD-SMB","Allow","TCP","*","445",[local.asg_ad_id],local.ip_alias_ad_dcs],
        ["CA-RPC1","Allow","TCP","*","135",[local.asg_ad_id],local.ip_alias_ca],
        ["CA-RPC2","Allow","UDP","*","135",[local.asg_ad_id],local.ip_alias_ca],
        ["CA-RPC3","Allow","TCP","*","49152-65535",[local.asg_ad_id],local.ip_alias_ca],
        ["CA-HTTPS","Allow","TCP","*","443",[local.asg_ad_id],local.ip_alias_cdp],
        ["CA-HTTP","Allow","TCP","*","80",[local.asg_ad_id],local.ip_alias_cdp],

    ]


    nsg_rules_ad_wvd = [
        ["AD-NTP","Allow","UDP","*","123",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-RPC1","Allow","UDP","*","135",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-RPC2","Allow","TCP","*","135",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-RPC3","Allow","TCP","*","49152-65535",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-LDAP1","Allow","TCP","*","389",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-LDAP2","Allow","TCP","*","636",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-LDAP3","Allow","TCP","*","3268-3269",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-LDAP4","Allow","UDP","*","389",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-LDAP5","Allow","UDP","*","636",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-LDAP6","Allow","UDP","*","3268-3269",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-DNS1","Allow","TCP","*","53",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-DNS2","Allow","UDP","*","53",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-KDC1","Allow","TCP","*","636",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-KDC2","Allow","TCP","*","88",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-KDC3","Allow","UDP","*","636",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-KDC4","Allow","UDP","*","88",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["AD-SMB","Allow","TCP","*","445",[local.asg_ad_wvd_id],local.ip_alias_ad_dcs],
        ["CA-RPC1","Allow","TCP","*","135",[local.asg_ad_wvd_id],local.ip_alias_ca],
        ["CA-RPC2","Allow","UDP","*","135",[local.asg_ad_wvd_id],local.ip_alias_ca],
        ["CA-RPC3","Allow","TCP","*","49152-65535",[local.asg_ad_wvd_id],local.ip_alias_ca],
        ["CA-HTTPS","Allow","TCP","*","443",[local.asg_ad_wvd_id],local.ip_alias_cdp],
        ["CA-HTTP","Allow","TCP","*","80",[local.asg_ad_wvd_id],local.ip_alias_cdp],

    ]

    nsg_rules_addc = [
        ["ADDC-NTP","Allow","UDP","*","123","*",local.ip_alias_ad_dcs],
        ["ADDC-RPC1","Allow","UDP","*","135","*",local.ip_alias_ad_dcs],
        ["ADDC-RPC2","Allow","TCP","*","135","*",local.ip_alias_ad_dcs],
        ["ADDC-RPC3","Allow","TCP","*","49152-65535","*",local.ip_alias_ad_dcs],
        ["ADDC-LDAP1","Allow","TCP","*","389","*",local.ip_alias_ad_dcs],
        ["ADDC-LDAP2","Allow","TCP","*","636","*",local.ip_alias_ad_dcs],
        ["ADDC-LDAP3","Allow","TCP","*","3268-3269","*",local.ip_alias_ad_dcs],
        ["ADDC-LDAP4","Allow","UDP","*","389","*",local.ip_alias_ad_dcs],
        ["ADDC-LDAP5","Allow","UDP","*","636","*",local.ip_alias_ad_dcs],
        ["ADDC-LDAP6","Allow","UDP","*","3268-3269","*",local.ip_alias_ad_dcs],
        ["ADDC-DNS1","Allow","TCP","*","53","*",local.ip_alias_ad_dcs],
        ["ADDC-DNS2","Allow","UDP","*","53","*",local.ip_alias_ad_dcs],
        ["ADDC-KDC1","Allow","TCP","*","636","*",local.ip_alias_ad_dcs],
        ["ADDC-KDC2","Allow","TCP","*","88","*",local.ip_alias_ad_dcs],
        ["ADDC-KDC3","Allow","UDP","*","636","*",local.ip_alias_ad_dcs],
        ["ADDC-KDC4","Allow","UDP","*","88","*",local.ip_alias_ad_dcs],
        ["ADDC-SMB","Allow","TCP","*","445","*",local.ip_alias_ad_dcs],
        ["ADCA-RPC1","Allow","TCP","*","135","*",local.ip_alias_ca],
        ["ADCA-RPC2","Allow","UDP","*","135","*",local.ip_alias_ca],
        ["ADCA-RPC3","Allow","TCP","*","49152-65535","*",local.ip_alias_ca],
    ]
}

resource "azurerm_network_security_rule" "outbound_ad" {
    depends_on                            = [azurerm_network_security_rule.bst]
    count                                 = var.outbound_ad == true ? length(local.nsg_rules_ad) : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = local.nsg_rules_ad[count.index][0]
    priority                              = 100+count.index
    access                                = local.nsg_rules_ad[count.index][1]
    protocol                              = local.nsg_rules_ad[count.index][2]
    source_port_range                     = local.nsg_rules_ad[count.index][3]
    destination_port_range                = local.nsg_rules_ad[count.index][4]
    source_application_security_group_ids = local.nsg_rules_ad[count.index][5]
#    source_address_prefix                 = "*"
    destination_address_prefixes          = local.nsg_rules_ad[count.index][6]
    direction                             = "Outbound"
}

resource "azurerm_network_security_rule" "outbound_ad_wvd" {
    depends_on                            = [azurerm_network_security_rule.bst]
    count                                 = var.outbound_ad_wvd == true ? length(local.nsg_rules_ad_wvd) : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = local.nsg_rules_ad_wvd[count.index][0]
    priority                              = 100+count.index
    access                                = local.nsg_rules_ad_wvd[count.index][1]
    protocol                              = local.nsg_rules_ad_wvd[count.index][2]
    source_port_range                     = local.nsg_rules_ad_wvd[count.index][3]
    destination_port_range                = local.nsg_rules_ad_wvd[count.index][4]
    source_application_security_group_ids = local.nsg_rules_ad_wvd[count.index][5]
#    source_address_prefix                 = "*"
    destination_address_prefixes          = local.nsg_rules_ad_wvd[count.index][6]
    direction                             = "Outbound"
}

resource "azurerm_network_security_rule" "inbound_ad" {
    depends_on                            = [azurerm_network_security_rule.outbound_ad]
    count                                 = var.inbound_ad == true ? length(local.nsg_rules_addc) : 0
    resource_group_name                   = var.resource_group_name
    network_security_group_name           = azurerm_network_security_group.nsg.name
    name                                  = local.nsg_rules_addc[count.index][0]
    priority                              = 100+count.index
    access                                = local.nsg_rules_addc[count.index][1]
    protocol                              = local.nsg_rules_addc[count.index][2]
    source_port_range                     = local.nsg_rules_addc[count.index][3]
    destination_port_range                = local.nsg_rules_addc[count.index][4]
    source_address_prefix                 = local.nsg_rules_addc[count.index][5]
    destination_address_prefixes          = local.nsg_rules_addc[count.index][6]
    direction                             = "Inbound"
}
