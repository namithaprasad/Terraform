locals {
  default_tags = {
    BusinessUnit           = "AHH"
    CreatedTime            = formatdate("YYYY-MM-DD hh:mm:ss +10:00", timeadd(timestamp(), "10h"))
    CreatedBy              = var.pipeline_executor
    CreatedByPipelineStage = var.pipeline_stage
    CostCentre             = "UK"
    Environment            = "EEE"
    Owner                  = "John"
    Region                 = var.location
    ServiceLevel           = "Unspecified"
    ServiceName            = ""
    SupportTeam            = "Unspecified"
  }

  management_keyvault_name                = "kvXXXEEEstd001"
  management_services_rg_name             = "rg-XXX-EEE-services-001"
  management_keyvault_sastoken_secretname = "sas-token-customscriptextension-container"
}

module "commondata" {
  source = "./../../../_modules/data"
}

data "azurerm_subscription" "primary" {

}

data "azurerm_client_config" "current" {

}

data "azurerm_storage_account" "sa" {
  name                = var.sub_config.storage_account_name
  resource_group_name = var.sub_config.services_resource_group
}

data "azurerm_key_vault" "kv" {
  name                = var.sub_config.key_vault_name
  resource_group_name = var.sub_config.services_resource_group
}

data "azurerm_recovery_services_vault" "rsv" {
  name                = var.sub_config.recovery_services_vault_name
  resource_group_name = var.sub_config.services_resource_group
}

data "azurerm_key_vault" "mgt_kv" {
  provider            = azurerm.mgtsub
  name                = local.management_keyvault_name
  resource_group_name = local.management_services_rg_name
}
data "azurerm_key_vault_secret" "sas-token-customscriptextension" {
  provider     = azurerm.mgtsub
  name         = local.management_keyvault_sastoken_secretname
  key_vault_id = data.azurerm_key_vault.mgt_kv.id
}

data "azurerm_subnet" "devops_agent" {
  name                 = var.selfhosted_devops_agent_config.subnet
  virtual_network_name = var.selfhosted_devops_agent_config.vnet
  resource_group_name  = var.selfhosted_devops_agent_config.vnet_resource_group
}