module "nsg_app" {
  source = "./../../../_modules/nsg2"

  depends_on                  = [module.vnet]
  resource_group_name         = azurerm_resource_group.rg_services.name
  storage_account_id          = azurerm_storage_account.sa.id
  networkwatcher_name         = azurerm_network_watcher.nw.name
  networkwatcher_rg_name      = azurerm_resource_group.rg_services.name
  location                    = var.location
  vnet_name                   = module.vnet.name
  bastion_cidr                = module.vnet.subnet_cidr_bastion
  network_security_group_name = "nsg-EEE-XXX-app-001"
  subnet_name                 = "snet-EEE-XXX-app-001"
  inbound_ad                  = false
  outbound_ad                 = true
  outbound_internet           = true
  attach_nsg                  = true
  tags                        = merge(local.default_tags, {})
  subnetasg_name              = "AccessToAppSubnet"
  subnetasg_allowedports      = null

  custom_rules_with_asg = [
    # Outbound
    # ["Name", "Allow", "TCP", "*", "dport", ["asg"], ["asg"], "Outbound", "3001"],

    # Inbound
    # ["Name", "Allow", "TCP", "*", "dport", ["asg"], ["asg"], "Inbound", "3001"],
  ]
  custom_rules_with_ip = [
    # Outbound
    # ["Name", "Allow", "TCP", "*", ["dport""], ["sip"], ["dip"], "Outbound", "3501"],

    # Inbound
    ["AllowRDPandSMBfromJBXs", "Allow", "TCP", "*", ["445", "3389"], ["10.0.0.0"], module.vnet.address_space, "Inbound", "3501"],

    # Outbound
  ]
}
