locals {
  # Add new route to\_modules\data\_output.tf
  onprem_routetables = [for x in module.commondata.OnPrem_Ranges : { name = "OnPrem-${index(module.commondata.OnPrem_Ranges, x) + 1}", address_prefix = x, next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.20.0.132" }]

  azure_routetables = [
    { name = "Default", address_prefix = "0.0.0.0/0", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = var.default_route_virtual_appliance_ip },
    { name = "Default_Azure", address_prefix = "10.0.0.0/18", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.0.0.0" },
    { name = "Default_Azure_ASE", address_prefix = "10.0.0.0/18", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.0.0.0" },
    { name = "VPNClientRange", address_prefix = "10.0.0.0/21", next_hop_type = "VirtualAppliance", next_hop_in_ip_address = "10.0.0.0" }
  ]
  standard_route_table = concat(local.azure_routetables, local.onprem_routetables)
}

module "commondata" {
  source = "./../data"
}

resource "azurerm_route_table" "rt" {
  count                         = length(var.subnet_custom_route_tables)
  location                      = var.location
  tags                          = var.tags
  name                          = element(var.subnet_custom_route_tables, count.index).route_table_name
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = element(var.subnet_custom_route_tables, count.index).routes
    content {
      name                   = route.value["name"]
      address_prefix         = route.value["address_prefix"]
      next_hop_type          = route.value["next_hop_type"]
      next_hop_in_ip_address = route.value["next_hop_type"] == "VirtualAppliance" ? route.value["next_hop_in_ip_address"] : null
    }
  }

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}

resource "azurerm_subnet_route_table_association" "rta" {
  count          = length(var.subnet_custom_route_tables)
  subnet_id      = azurerm_subnet.snet[count.index].id
  route_table_id = azurerm_route_table.rt[count.index].id
}

resource "azurerm_subnet_route_table_association" "rta_std" {
  count          = length(var.standard_routetable_names)
  subnet_id      = azurerm_subnet.snet[count.index].id
  route_table_id = azurerm_route_table.rt_std[count.index].id
}

resource "azurerm_route_table" "rt_std" {
  count                         = length(var.standard_routetable_names)
  location                      = var.location
  tags                          = var.tags
  name                          = var.standard_routetable_names[count.index]  # Changed from hardcoded to variable
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation != null ? var.disable_bgp_route_propagation[count.index] : false # added variable to correct the code drift
  route = var.extra_routes == null ? (var.append_to_standard_routetables == null ? (   #extra conditional statement added for extra_routes
    lookup(var.custom_azure_routetables, var.standard_routetable_names[count.index], null) != null ? concat(
    lookup(var.custom_azure_routetables, var.standard_routetable_names[count.index], null), local.onprem_routetables) : local.standard_route_table 
    ) : concat(
    local.standard_route_table, length([for x in var.append_to_standard_routetables : x.routes if x.route_table_name == var.standard_routetable_names[count.index]]) > 0 ?
  [for x in var.append_to_standard_routetables : x.routes if x.route_table_name == var.standard_routetable_names[count.index]][0] : [])
  ) : concat(var.append_to_standard_routetables == null ? (    #if extra_routes is not null
    lookup(var.custom_azure_routetables, var.standard_routetable_names[count.index], null) != null ? concat(
    lookup(var.custom_azure_routetables, var.standard_routetable_names[count.index], null), local.onprem_routetables) : local.standard_route_table 
    ) : concat(
    local.standard_route_table, length([for x in var.append_to_standard_routetables : x.routes if x.route_table_name == var.standard_routetable_names[count.index]]) > 0 ?
  [for x in var.append_to_standard_routetables : x.routes if x.route_table_name == var.standard_routetable_names[count.index]][0] : []), var.extra_routes[count.index]) # concatinated extra routes
  
  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}
