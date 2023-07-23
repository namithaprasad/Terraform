module "wsEEExxxxxxNN" {
  source = "./../../../_modules/windows"

  tags = merge(local.default_tags, {
  })
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_workloads.name
  storage_account     = data.azurerm_storage_account.sa.primary_blob_endpoint

  name                        = "wsEEExxxxxxNN"
  vm_size                     = "Standard_D2s_v3"
  os_sku                      = "2019-Datacenter"
  os_version                  = "17763.1457.2009030514"
  os_disk_size_gb             = 128
  data_disk_size_gb           = []
  data_disk_caching           = []
  admin_username              = "asahiadmin"
  generate_password           = true
  admin_password              = ""
  store_password_in_key_vault = true
  key_vault_name              = var.sub_config.key_vault_name
  key_vault_resource_group    = var.sub_config.services_resource_group
  az                          = "1"
  domain_join                 = true
  domain_join_username        = var.ad_domainjoin_un
  domain_join_password        = var.ad_domainjoin_pw
  ppg_id                      = null
  asg_names                   = ["OutboundActiveDirectoryMember", "OutboundInternet"]
  asg_resource_group_name     = var.sub_config.services_resource_group

  enabled_accelerated_networking = false
  vnet_resource_group            = var.sub_config.services_resource_group
  vnet                           = "vnet-xxx-xxx-wls-001"
  subnet_name                    = "snet-xxx-xxx-xxx-001"
  static_ip                      = false
  static_ip_addr                 = ""

  recovery_vault_name                          = data.azurerm_recovery_services_vault.rsv.name
  recovery_vault_resource_group                = data.azurerm_recovery_services_vault.rsv.resource_group_name
  backup_frequency                             = "Daily"
  backup_time                                  = "01:00"
  backup_retention_daily_count                 = 32
  backup_retention_weekly_count                = 5
  backup_retention_monthly_count               = 13
  backup_retention_yearly_count                = 10
  backup_retention_weekly_day                  = "Sunday"
  backup_retention_monthly_week                = "First"
  backup_retention_yearly_month                = "January"
  add_to_backup                                = true
  enable_disk_encryption                       = true
  patch_mode                                   = "AutomaticByOS"
  windowsfirewall_inbound_ports                = "445,3389" # Optional - Needed only if Windows Firewall ports are needed.
  enable_diskformat_changecdromdrive_extension = true       # Optional - Needed only if Additional Data disks are there which needs formatting, mounting or cd rom drive letter needs re-arranging.
  customscriptextension_sastoken               = data.azurerm_key_vault_secret.sas-token-customscriptextension.value
}
