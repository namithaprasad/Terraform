locals {
  source_asg_prefix = "${data.azurerm_resource_group.rg.id}/providers/Microsoft.Network/applicationSecurityGroups"
}

resource "azurerm_network_security_rule" "nsg_rule_asg" {
  depends_on = [azurerm_network_security_group.nsg]

  count = length(var.custom_rules_with_asg)

  name                                       = element(var.custom_rules_with_asg[count.index], 0)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = element(var.custom_rules_with_asg[count.index], 8)
  access                                     = element(var.custom_rules_with_asg[count.index], 1)
  protocol                                   = element(var.custom_rules_with_asg[count.index], 2)
  source_port_range                          = element(var.custom_rules_with_asg[count.index], 3)
  destination_port_range                     = element(var.custom_rules_with_asg[count.index], 4)
  source_application_security_group_ids      = formatlist("%s/%s", local.source_asg_prefix, element(var.custom_rules_with_asg[count.index], 5))
  destination_application_security_group_ids = formatlist("%s/%s", local.source_asg_prefix, element(var.custom_rules_with_asg[count.index], 6))
  direction                                  = element(var.custom_rules_with_asg[count.index], 7)
}

resource "azurerm_network_security_rule" "nsg_rule_ip" {
  depends_on = [azurerm_network_security_group.nsg]

  count = length(var.custom_rules_with_ip)

  name                         = element(var.custom_rules_with_ip[count.index], 0)
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.nsg.name
  priority                     = element(var.custom_rules_with_ip[count.index], 8)
  access                       = element(var.custom_rules_with_ip[count.index], 1)
  protocol                     = element(var.custom_rules_with_ip[count.index], 2)
  source_port_range            = element(var.custom_rules_with_ip[count.index], 3)
  destination_port_range       = try(trim(element(var.custom_rules_with_ip[count.index], 4), "") == element(var.custom_rules_with_ip[count.index], 4) ? element(var.custom_rules_with_ip[count.index], 4) : null, null)
  destination_port_ranges      = try(element(element(var.custom_rules_with_ip[count.index], 4), 0) != null ? element(var.custom_rules_with_ip[count.index], 4) : null, null)
  source_address_prefixes      = element(var.custom_rules_with_ip[count.index], 5)
  destination_address_prefixes = element(var.custom_rules_with_ip[count.index], 6)
  direction                    = element(var.custom_rules_with_ip[count.index], 7)
}

resource "azurerm_network_security_rule" "nsg_rule_servicetags_outbound" {
  depends_on = [azurerm_network_security_group.nsg]

  count = length(var.custom_rules_with_servicetags_outbound)

  name                        = element(var.custom_rules_with_servicetags_outbound[count.index], 0)
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = element(var.custom_rules_with_servicetags_outbound[count.index], 8)
  access                      = element(var.custom_rules_with_servicetags_outbound[count.index], 1)
  protocol                    = element(var.custom_rules_with_servicetags_outbound[count.index], 2)
  source_port_range           = element(var.custom_rules_with_servicetags_outbound[count.index], 3)
  destination_port_range      = element(var.custom_rules_with_servicetags_outbound[count.index], 4)
  source_address_prefixes     = element(var.custom_rules_with_servicetags_outbound[count.index], 5)
  destination_address_prefix  = element(var.custom_rules_with_servicetags_outbound[count.index], 6)
  direction                   = element(var.custom_rules_with_servicetags_outbound[count.index], 7)
}

resource "azurerm_network_security_rule" "nsg_rule_src_ips_dest_asgs" {
  depends_on = [azurerm_network_security_group.nsg]

  count = length(var.custom_rules_with_src_ip_dest_asgs)

  name                                       = element(var.custom_rules_with_src_ip_dest_asgs[count.index], 0)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = element(var.custom_rules_with_src_ip_dest_asgs[count.index], 8)
  access                                     = element(var.custom_rules_with_src_ip_dest_asgs[count.index], 1)
  protocol                                   = element(var.custom_rules_with_src_ip_dest_asgs[count.index], 2)
  source_port_range                          = element(var.custom_rules_with_src_ip_dest_asgs[count.index], 3)
  destination_port_range                     = try(trim(element(var.custom_rules_with_src_ip_dest_asgs[count.index], 4), "") == element(var.custom_rules_with_src_ip_dest_asgs[count.index], 4) ? element(var.custom_rules_with_src_ip_dest_asgs[count.index], 4) : null, null)
  destination_port_ranges                    = try(element(element(var.custom_rules_with_src_ip_dest_asgs[count.index], 4), 0) != null ? element(var.custom_rules_with_src_ip_dest_asgs[count.index], 4) : null, null)
  source_address_prefixes                    = element(var.custom_rules_with_src_ip_dest_asgs[count.index], 5)
  destination_application_security_group_ids = formatlist("%s/%s", local.source_asg_prefix, element(var.custom_rules_with_src_ip_dest_asgs[count.index], 6))
  direction                                  = element(var.custom_rules_with_src_ip_dest_asgs[count.index], 7)
}

resource "azurerm_network_security_rule" "nsg_rule_src_servicetags_dest_asgs" {
  depends_on = [azurerm_network_security_group.nsg]

  count = length(var.custom_rules_with_src_servicetags_dest_asgs)

  name                                       = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 0)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 8)
  access                                     = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 1)
  protocol                                   = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 2)
  source_port_range                          = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 3)
  destination_port_range                     = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 4)
  source_address_prefix                      = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 5) # ServiceTag
  destination_application_security_group_ids = formatlist("%s/%s", local.source_asg_prefix, element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 6))
  direction                                  = element(var.custom_rules_with_src_servicetags_dest_asgs[count.index], 7)
}

resource "azurerm_network_security_rule" "nsg_rule_src_asg_dest_servicetags" {
  depends_on = [azurerm_network_security_group.nsg]

  count = length(var.custom_rules_with_src_asg_dest_servicetags)

  name                                  = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 0)
  resource_group_name                   = var.resource_group_name
  network_security_group_name           = azurerm_network_security_group.nsg.name
  priority                              = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 8)
  access                                = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 1)
  protocol                              = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 2)
  source_port_range                     = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 3)
  destination_port_range                = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 4)
  source_application_security_group_ids = formatlist("%s/%s", local.source_asg_prefix, element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 5))
  destination_address_prefix            = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 6)
  direction                             = element(var.custom_rules_with_src_asg_dest_servicetags[count.index], 7)
}
