locals {
  key_vault_name = "kvEEEXXXstd001"
}

resource "azurerm_key_vault" "kv" {
  depends_on = [azurerm_resource_group.rg_services]
  tags = merge(local.default_tags, {
  })
  name                        = local.key_vault_name
  resource_group_name         = var.sub_config.services_resource_group
  location                    = var.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = "standard"
  enable_rbac_authorization   = true

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = module.commondata.ip_az_all_firewall_publicips
    virtual_network_subnet_ids = concat([data.azurerm_subnet.snet_aci_devops.id, data.azurerm_subnet.snet_mgt_web.id], module.vnet.subnets[*].id)
  }

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}

