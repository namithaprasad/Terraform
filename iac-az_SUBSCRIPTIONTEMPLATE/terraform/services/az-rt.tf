resource "azurerm_route_table" "rt" {
    count                          = length(var.vnet_config.vnet1.subnet_names)
    tags                           = merge(local.default_tags,{
                                   })
    name                           = element(var.vnet_config.vnet1.subnet_route_tables, count.index).route_table_name
    location                       = var.location
    resource_group_name            = azurerm_resource_group.rg_services.name
    disable_bgp_route_propagation  = false

    dynamic "route" {
        for_each                   = element(var.vnet_config.vnet1.subnet_route_tables, count.index).routes
        content {
            name                   = route.value["route_name"]
            address_prefix         = route.value["address_prefix"]
            next_hop_type          = route.value["next_hop_type"]
            next_hop_in_ip_address = route.value["next_hop_type"] == "VirtualAppliance" ? route.value["next_hop_in_ip_address"] : null 
        }
    }

    lifecycle {
        ignore_changes             = [tags["CreatedTime"],tags["CreatedBy"],tags["CreatedByPipelineStage"]]
    }
}

resource "azurerm_subnet_route_table_association" "rta" {
    count                          = length(var.vnet_config.vnet1.subnet_names)
    subnet_id                      = azurerm_subnet.snet[count.index].id
    route_table_id                 = azurerm_route_table.rt[count.index].id
}
