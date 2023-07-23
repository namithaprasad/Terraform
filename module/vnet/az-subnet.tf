resource "azurerm_subnet" "snet" {
  depends_on                                     = [azurerm_virtual_network.vnet]
  count                                          = length(var.subnet_names)
  name                                           = element(var.subnet_names, count.index)
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = var.name
  address_prefixes                               = element(var.subnet_address_spaces, count.index)
  service_endpoints                              = var.service_endpoints
  # enforce_private_link_endpoint_network_policies = try(element([for x in var.subnets_with_private_endpoints : true if(x == element(var.subnet_names, count.index))], 0), false)
  private_endpoint_network_policies_enabled = try(element([for x in var.subnets_with_private_endpoints : true if(x == element(var.subnet_names, count.index))], 0), false) == false ? true : false
  private_link_service_network_policies_enabled = lookup(var.private_link_service_enabled, element(var.subnet_names, count.index), null) == null ? true : lookup(var.private_link_service_enabled, element(var.subnet_names, count.index), null)
  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation,
     element(var.subnet_names, count.index), null) == null ? {} : { key1 = lookup(var.subnet_delegation, element(var.subnet_names, count.index), null) }
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}
## Example of the subnet delegation assignments. DO NOT DELETE
###################################################################################
# subnet_delegation = {
#       snet-prd-mgt-aci-001 = {
#         subnet_name = "snet-prd-mgt-aci-001"
#         name        = "snet-prd-mgt-aci-001_delegation"
#         service_delegation = {
#           name    = "Microsoft.ContainerInstance/containerGroups"
#           actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#         }
#       },
#     }
