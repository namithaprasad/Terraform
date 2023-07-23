module "nsg_bst" {
  source = "./../../../_modules/nsg2"

  depends_on                  = [module.vnet]
  resource_group_name         = azurerm_resource_group.rg_services.name
  storage_account_id          = azurerm_storage_account.sa.id
  networkwatcher_name         = azurerm_network_watcher.nw.name
  networkwatcher_rg_name      = azurerm_resource_group.rg_services.name
  location                    = var.location
  vnet_name                   = module.vnet.name
  network_security_group_name = "nsg-EEE-XXX-bst-001"
  subnet_name                 = "AzureBastionSubnet"
  bastion                     = true
  rules_default               = false
  attach_nsg                  = true
  tags = merge(local.default_tags, {})
}
