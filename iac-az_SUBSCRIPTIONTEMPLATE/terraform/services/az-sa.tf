locals {
  sa_storage_account_name             = "stasahigXXXEEE"
  sa_storage_account_tier             = "Standard"
  sa_storage_account_replication_type = "RAGRS"
  sa_storage_container_name           = ["bootdiag"]
  sa_storage_container_access_type    = ["private"]
}

resource "azurerm_storage_account" "sa" {
  depends_on = [azurerm_resource_group.rg_services]
  tags = merge(local.default_tags, {
  })
  name                = local.sa_storage_account_name
  location            = var.location
  resource_group_name = var.sub_config.services_resource_group

  account_replication_type  = local.sa_storage_account_replication_type
  account_tier              = local.sa_storage_account_tier
  allow_blob_public_access  = "false"
  enable_https_traffic_only = "true"
  min_tls_version           = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = module.commondata.ip_az_all_firewall_publicips
    virtual_network_subnet_ids = concat([data.azurerm_subnet.snet_aci_devops.id, data.azurerm_subnet.snet_mgt_web.id], module.vnet.subnets[*].id)
  }

  blob_properties {
    delete_retention_policy { days = 7 }
  }

  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"]]
  }
}

resource "azurerm_storage_container" "sa_containers" {
  depends_on            = [azurerm_storage_account.sa]
  count                 = length(local.sa_storage_container_name)
  name                  = element(local.sa_storage_container_name, count.index)
  storage_account_name  = local.sa_storage_account_name
  container_access_type = "private"
}
