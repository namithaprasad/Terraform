resource "azurerm_private_endpoint" "sa" {
  name                = var.sub_config.private_endpoint_name_sa
  location            = azurerm_resource_group.rg_services.location
  resource_group_name = azurerm_resource_group.rg_services.name
  subnet_id           = module.vnet.subnets[3].id

  private_service_connection {
    name                           = "${var.sub_config.private_endpoint_name_sa}_connection"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

# resource "azurerm_private_endpoint" "sa_ase" {
#     name                = var.sub_config.private_endpoint_name_sa_ase
#     location            = azurerm_resource_group.rg_services_ase.location
#     resource_group_name = azurerm_resource_group.rg_services_ase.name
#     subnet_id           = module.vnet2.subnets[3].id

#     private_service_connection {
#         name                           = "${var.sub_config.private_endpoint_name_sa_ase}_connection"
#         private_connection_resource_id = azurerm_storage_account.sa.id
#         subresource_names              = ["blob"]
#         is_manual_connection           = false
#     }
# }

resource "azurerm_private_endpoint" "kv" {
  name                          = var.sub_config.private_endpoint_name_kv
  location                      = azurerm_resource_group.rg_services.location
  resource_group_name           = azurerm_resource_group.rg_services.name
  subnet_id                     = module.vnet.subnets[3].id
  custom_network_interface_name = "pep-XXX-EEE-akv-001-nic"
  tags                          = {}
  


  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/XXXXXXX-EEEE-FDDDDD-DDFDFFDDDD-DSDSDSDDDDD/resourceGroups/rg-XXX-EEE-services-001/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }

  private_service_connection {
    is_manual_connection           = true
    name                           = "pep-XXX-EEE-akv-001"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
   private_ip_address             = "10.0.0.0"         
  }
}

resource "azurerm_private_endpoint" "kv_ase" {
  name                = var.sub_config.private_endpoint_name_kv_ase
  location            = azurerm_resource_group.rg_services_ase.location
  resource_group_name = azurerm_resource_group.rg_services_ase.name
  subnet_id           = module.vnet2.subnets[3].id

  private_service_connection {
    name                           = "${var.sub_config.private_endpoint_name_kv_ase}_connection"
    private_connection_resource_id = data.azurerm_key_vault.kv_ase.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
