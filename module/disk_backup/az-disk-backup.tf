resource "azurerm_data_protection_backup_policy_disk" "disk_backup_policy" {
  name     = "${var.name}-disk-backuppolicy"
  vault_id = var.backup_vault.id

  backup_repeating_time_intervals = ["R/2021-08-18T01:00:00+10:00/P1D"]
  default_retention_duration      = "P32D"
  retention_rule {
    name     = "Weekly"
    duration = var.backup_vault_retention_weeks
    priority = 25
    criteria {
      absolute_criteria = "FirstOfWeek"
    }
  }
}

resource "azurerm_data_protection_backup_instance_disk" "disk_backup_protection" {
  count                        = length(var.disks_to_backup) > 0 ? length(var.disks_to_backup) : 0
  name                         = "${var.disks_to_backup[count.index].name}_disk_backup_protection"
  location                     = var.location
  vault_id                     = var.backup_vault.id
  disk_id                      = var.disks_to_backup[count.index].id
  snapshot_resource_group_name = var.snapshot_resource_group.name
  backup_policy_id             = azurerm_data_protection_backup_policy_disk.disk_backup_policy.id
}

resource "azurerm_role_assignment" "Role_Disk_Snapshot_Contributor" {
  count                = length(var.disks_to_backup) > 0 ? 1 : 0
  scope                = var.snapshot_resource_group.id
  role_definition_name = "Disk Snapshot Contributor"
  principal_id         = var.backup_vault.identity[0].principal_id
}

resource "azurerm_role_assignment" "Role_Disk_Backup_Reader" {
  count                = length(var.disks_to_backup) > 0 ? length(var.disks_to_backup) : 0
  scope                = var.disks_to_backup[count.index].id
  role_definition_name = "Disk Backup Reader"
  principal_id         = var.backup_vault.identity[0].principal_id
}
