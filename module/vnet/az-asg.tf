locals {
    default_asg_names = ["OutboundActiveDirectoryMember","OutboundInternet",
                         "OutboundOnPrem","OutboundLocalWebSubnet","OutboundLocalAppSubnet","OutboundLocalDBSubnet",
                         "AccessToWebSubnet","AccessToAppSubnet","AccessToDBSubnet","Jumpboxes"
            ]
}

resource "azurerm_application_security_group" "default" {
    count               = var.add_default_asgs == true ? length(local.default_asg_names) : 0
    location            = var.location
    tags                = var.tags
    name                = local.default_asg_names[count.index]
    resource_group_name = var.resource_group_name

    lifecycle {
        ignore_changes          = [tags["CreatedTime"],tags["CreatedBy"],tags["CreatedByPipelineStage"]]
    } 
}

resource "azurerm_application_security_group" "array" {
    count               = length(var.asg_names)
    location            = var.location
    tags                = var.tags
    name                = var.asg_names[count.index]
    resource_group_name = var.resource_group_name

    lifecycle {
        ignore_changes          = [tags["CreatedTime"],tags["CreatedBy"],tags["CreatedByPipelineStage"]]
    } 
}
