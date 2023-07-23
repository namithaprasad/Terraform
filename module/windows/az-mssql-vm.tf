locals {
  sql_storage_configuration = {
    default = {
      sql_storage_disk_type                   = var.sql_storage_disk_type
      sql_storage_workload_type               = var.sql_storage_workload_type
      sql_storage_disk_config_data_path       = var.sql_storage_disk_config_data_path
      sql_storage_disk_config_data_drive_luns = var.sql_storage_disk_config_data_drive_luns
      sql_storage_disk_config_log_path        = var.sql_storage_disk_config_log_path
      sql_storage_disk_config_log_drive_luns  = var.sql_storage_disk_config_log_drive_luns
      # sql_storage_disk_config_temp_db_path       = "D:\\TempDb"
      # sql_storage_disk_config_temp_db_drive_luns = [0]
    }
  }
}
resource "azurerm_mssql_virtual_machine" "mssql_vm" {
  count                            = var.deployassql && !var.ignore_sql_extension ? 1 : 0
  virtual_machine_id               = azurerm_windows_virtual_machine.vm[0].id
  sql_license_type                 = var.sql_license_type
  r_services_enabled               = var.r_services_enabled
  sql_connectivity_port            = var.sql_connectivity_port
  sql_connectivity_type            = var.sql_connectivity_type
  sql_connectivity_update_username = var.sql_connectivity_update_username
  sql_connectivity_update_password = var.sql_generate_admin_password ? random_password.sql_password[0].result : var.sql_admin_password
  tags                             = var.tags
  depends_on                       = [azurerm_windows_virtual_machine.vm]

  dynamic "storage_configuration" {
    for_each = var.sql_storage_configuration_use ? local.sql_storage_configuration : {}

    content {
      disk_type             = storage_configuration.value.sql_storage_disk_type
      storage_workload_type = storage_configuration.value.sql_storage_workload_type
      data_settings {
        default_file_path = storage_configuration.value.sql_storage_disk_config_data_path
        luns              = storage_configuration.value.sql_storage_disk_config_data_drive_luns
      }
      log_settings {
        default_file_path = storage_configuration.value.sql_storage_disk_config_log_path
        luns              = storage_configuration.value.sql_storage_disk_config_log_drive_luns
      }
    }
  }
  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"], sql_connectivity_update_password]
  }
}
