sub_config = {
    services_resource_group             = "rg-EEE-XXX-services-001"
    la_config = {
        name                                = "log-XXX-EEE-shd-001"
        resource_group_name                 = "rg-XXX-EEE-services-001"
        sub_platform_management_id          = "subscription id"
        workspace_provider                  = "providers/microsoft.operationalinsights/workspaces"
    }
}
