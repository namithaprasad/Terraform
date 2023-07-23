resource "azurerm_application_security_group" "array" {
    count                       = length(local.asg_names)
    tags                        = merge(local.default_tags,{
                                })
    name                        = local.asg_names[count.index]
    location                    = var.location
    resource_group_name         = azurerm_resource_group.rg_services.name
    lifecycle {
        ignore_changes          = [tags["CreatedTime"],tags["CreatedBy"],tags["CreatedByPipelineStage"]]
    } 
}
