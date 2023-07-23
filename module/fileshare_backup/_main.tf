resource "azurerm_backup_container_storage_account" "protection-container" {
  resource_group_name = var.resource_group_name_recovery_services_vault
  recovery_vault_name = var.recovery_services_vault_name
  storage_account_id  = var.storage_account_id
}

resource "azurerm_backup_policy_file_share" "fs_backup_policy" {
  name                = "${var.storage_account_name}_fs_backup_policy"
  resource_group_name = var.resource_group_name_backup_policy
  recovery_vault_name = var.recovery_services_vault_name

  timezone = "AUS Eastern Standard Time"

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.backup_retention_daily_count
  }


  #   retention_weekly {
  #     count    = var.backup_retention_weekly_count
  #     weekdays = [var.backup_retention_weekly_day]
  #   }

  #   retention_monthly {
  #     count    = var.backup_retention_monthly_count
  #     weekdays = [var.backup_retention_weekly_day]
  #     weeks    = [var.backup_retention_monthly_week]
  #   }

  #   retention_yearly {
  #     count    = var.backup_retention_yearly_count
  #     weekdays = [var.backup_retention_weekly_day]
  #     weeks    = [var.backup_retention_monthly_week]
  #     months   = [var.backup_retention_yearly_month]
  #   }
}

resource "azurerm_backup_protected_file_share" "fs_protected" {
  for_each                  = var.fileshares_to_protect
  resource_group_name       = var.resource_group_name_backup_protected_fs
  recovery_vault_name       = var.recovery_services_vault_name
  source_storage_account_id = azurerm_backup_container_storage_account.protection-container.storage_account_id
  source_file_share_name    = each.value.fs_name
  backup_policy_id          = azurerm_backup_policy_file_share.fs_backup_policy.id
}
