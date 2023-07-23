resource "azurerm_backup_policy_vm" "bkup_policy" {
  count = var.add_to_backup == true ? 1 : 0

  name                = "${var.name}_backuppolicy"
  resource_group_name = var.recovery_vault_resource_group
  recovery_vault_name = var.recovery_vault_name

  timezone = "British Summer Time"

  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }

  retention_daily {
    count = var.backup_retention_daily_count
  }

  retention_weekly {
    count    = var.backup_retention_weekly_count
    weekdays = [var.backup_retention_weekly_day]
  }

  retention_monthly {
    count    = var.backup_retention_monthly_count
    weekdays = [var.backup_retention_weekly_day]
    weeks    = [var.backup_retention_monthly_week]
  }

  retention_yearly {
    count    = var.backup_retention_yearly_count
    weekdays = [var.backup_retention_weekly_day]
    weeks    = [var.backup_retention_monthly_week]
    months   = [var.backup_retention_yearly_month]
  }
}

data "azurerm_backup_policy_vm" "default_bkup_policy" {
  count               = var.default_policy!=null ? 1 : 0
  name                = var.default_policy
  recovery_vault_name = var.recovery_vault_name
  resource_group_name = var.recovery_vault_resource_group
}

resource "azurerm_backup_protected_vm" "bpvm" {
  depends_on          = [azurerm_linux_virtual_machine.vm]
  count      = var.add_to_backup == true ? 1 : 0
  resource_group_name = var.recovery_vault_resource_group
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.vm[0].id
  backup_policy_id    = var.default_policy != null ? data.azurerm_backup_policy_vm.default_bkup_policy[0].id : azurerm_backup_policy_vm.bkup_policy[0].id
}