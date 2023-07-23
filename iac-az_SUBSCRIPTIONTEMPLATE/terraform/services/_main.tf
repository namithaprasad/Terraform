locals {
  default_tags = {
    BusinessUnit           = "Company Name"
    CreatedTime            = formatdate("YYYY-MM-DD hh:mm:ss +1:00", timeadd(timestamp(), "1h"))
    CreatedBy              = var.pipeline_executor
    CreatedByPipelineStage = var.pipeline_stage
    CostCentre             = "DTBS"
    Environment            = "EEE"
    Owner                  = "John"
    Region                 = var.location
    ServiceLevel           = "Unspecified"
    ServiceName            = ""
    SupportTeam            = "Unspecified"
  }

  devops_vnet_name                = "vnet-XXX-EEE-std-001"
  devops_subnet_name              = "snet-XXX-EEE-aci-001"
  devops_vnet_resource_group_name = "rg-XXX-EEE-services-001"

  webproxy_vnet_name                = "vnet-XXX-EEE-std-001"
  webproxy_subnet_name              = "snet-XXX-EEE-web-001"
  webproxy_vnet_resource_group_name = "rg-XXX-EEE-services-001"
}

module "commondata" {
  source = "./../../../_modules/data"
}

data "azurerm_subscription" "primary" {

}

data "azurerm_client_config" "current" {

}

data "azurerm_subnet" "snet_aci_devops" {
  provider             = azurerm.mgtsub
  name                 = local.devops_subnet_name
  virtual_network_name = local.devops_vnet_name
  resource_group_name  = local.devops_vnet_resource_group_name
}

data "azurerm_subnet" "snet_mgt_web" { # Needed for proxy access to Key Vault and Storage Account
  provider             = azurerm.mgtsub
  name                 = local.webproxy_subnet_name
  virtual_network_name = local.webproxy_vnet_name
  resource_group_name  = local.webproxy_vnet_resource_group_name
}
