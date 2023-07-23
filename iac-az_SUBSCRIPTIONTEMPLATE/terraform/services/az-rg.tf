resource "azurerm_resource_group" "rg_services" {
    tags                        = merge(local.default_tags,{
                                })
    name                        = var.sub_config.services_resource_group
    location                    = var.location

    lifecycle {
        ignore_changes          = [tags["CreatedTime"],tags["CreatedBy"],tags["CreatedByPipelineStage"]]
    } 
}
