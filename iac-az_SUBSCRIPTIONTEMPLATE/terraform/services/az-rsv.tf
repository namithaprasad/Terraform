locals {
    recovery_services_vault_name        = "rsv-EEE-XXX-std-001"
}
resource "azurerm_recovery_services_vault" "rsv" {
    depends_on                  = [azurerm_resource_group.rg_services]
    tags                        = merge(local.default_tags,{
                                })
    name                        = local.recovery_services_vault_name
    location                    = var.location
    resource_group_name         = var.sub_config.services_resource_group    
    sku                         = "Standard"
    soft_delete_enabled         = true 

    lifecycle {
        ignore_changes          = [tags["CreatedTime"],tags["CreatedBy"],tags["CreatedByPipelineStage"]]
    } 
}
