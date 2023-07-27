resource "azurerm_app_service_plan" "platform_logicapp_plan" {
    name                    = "${var.context_prefix}-asp-platform-logicapps-${var.environment_name}"
    location                = data.azurerm_resource_group.eai_resource_group.location
    resource_group_name     = data.azurerm_resource_group.eai_resource_group.name
    kind                    = "elastic"
    is_xenon                = "false"
    per_site_scaling        = "false"
    reserved                = "false"
    tags                    = {}
    zone_redundant          = "false"
    sku {
        tier = "WorkflowStandard"
        size = "WS1"
    }
}


resource "azurerm_application_insights" "platform_logicapp_appinsights" {
    name                = "${var.context_prefix}-ai-platform-logicapps-${var.environment_name}"
    location            = data.azurerm_resource_group.eai_resource_group.location
    resource_group_name = data.azurerm_resource_group.eai_resource_group.name
    application_type    = "web"
    workspace_id        = azurerm_log_analytics_workspace.platform_logicapp_logs.id
}

resource "azurerm_logic_app_standard" "helloworld" {
    name                        = "${var.context_prefix}-la-hello-world-${var.environment_name}"
    location                    = data.azurerm_resource_group.eai_resource_group.location
    resource_group_name         = data.azurerm_resource_group.eai_resource_group.name
    app_service_plan_id         = azurerm_app_service_plan.platform_logicapp_plan.id
    storage_account_name        = azurerm_storage_account.logicapp_std_storage.name
    storage_account_access_key  = azurerm_storage_account.logicapp_std_storage.primary_access_key
    storage_account_share_name  = "${var.context_prefix}-la-hello-world-${var.environment_name}"
    
    https_only                  = true
    version                     = "~3"

    site_config {
        always_on                   = false
        dotnet_framework_version    = "v4.0"
        ftps_state                  = "Disabled"
        pre_warmed_instance_count   = "0"
        app_scale_limit             = "1"
    }

    identity  {
        type                        = "SystemAssigned"
    }
}