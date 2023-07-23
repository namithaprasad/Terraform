resource "azurerm_resource_group" "rg_workloads" {
    tags                        = merge(local.default_tags,{
                                })
    name                        = var.sub_config.workloads_resource_group
    location                    = var.location

    lifecycle {
        ignore_changes          = [tags["CreatedTime"],tags["CreatedBy"],tags["CreatedByPipelineStage"]]
    } 
}
