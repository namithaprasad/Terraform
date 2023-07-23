variable "location" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "resource_group_name" {
  type = string
}

variable "storage_account" {
  type = string
}

variable "recovery_vault_name" {
  type = string
}

variable "recovery_vault_resource_group" {
  type = string
}

variable "name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "os_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "os_offer" {
  type    = string
  default = "WindowsServer"
}

variable "os_sku" {
  type = string
}

variable "os_version" {
  type = string
}

variable "os_disk_size_gb" {
  type = string
}

variable "data_disk_size_gb" {
  type = list(any)
}

variable "data_disk_caching" { default = ["None"] }

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "generate_password" {
  type    = bool
  default = false
}

variable "store_password_in_key_vault" {
  type    = bool
  default = false
}

variable "key_vault_name" {
  type = string
}

variable "key_vault_resource_group" {
  type = string
}

variable "enabled_accelerated_networking" {
  type = string
}

variable "vnet" {
  type = string
}

variable "vnet_resource_group" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "static_ip" {
  type = bool
}

variable "static_ip_addr" {
  type = string
}

variable "add_to_backup" {
  type    = bool
  default = true
}

variable "backup_frequency" {
  type = string
}

variable "backup_time" {
  type = string
}

variable "backup_retention_daily_count" {
  type = string
}

variable "backup_retention_weekly_count" {
  type = string
}

variable "backup_retention_monthly_count" {
  type = string
}

variable "backup_retention_yearly_count" {
  type = string
}

variable "backup_retention_weekly_day" {
  type = string
}

variable "backup_retention_monthly_week" {
  type = string
}

variable "backup_retention_yearly_month" {
  type = string
}

variable "az" {
  type = string
}

variable "domain_join" {
  type = bool
}

variable "domain" {
  type    = string
  default = "domain of company"
}

variable "ppg_id" {
  type = string
}

variable "asg_names" {
  type = list(any)
}

variable "asg_resource_group_name" {
  type    = string
  default = null
}

variable "domain_join_username" {
  type    = string
  default = null
}

variable "domain_join_password" {
  type    = string
  default = null
}

variable "enable_disk_encryption" {
  type    = bool
  default = false
}

variable "patch_mode" {
  type    = string
  default = "Manual"
}

variable "vm_lock" {
  type    = bool
  default = true
}

variable "os_disk_name" {
  type    = string
  default = null
}

variable "data_disk_names" {
  type    = list(string)
  default = []
}

variable "data_disk_create_options" {
  type    = list(string)
  default = []
}

variable "data_disk_luns" {
  type    = list(number)
  default = []
}

variable "nic_name" {
  type    = string
  default = null
}

variable "ipconfig_name" {
  type    = string
  default = null
}

variable "enable_legacy_vm_module" {
  type    = bool
  default = false
}

variable "enable_disk_encryption_ADE" {
  type    = bool
  default = false
}

variable "type_handler_version" {
  description = "VM Extension type handler version"
  type        = string
  default     = "2.2"
}

variable "encrypt_operation" {
  default = "EnableEncryption"
}

variable "kv_uri" {
  description = "KeyVault URI"
  type        = string
  default     = ""
}

variable "kv_id" {
  description = "KeyVault ID"
  type        = string
  default     = ""
}

variable "kv_key_id" {
  description = "URL to encrypt Key"
  default     = ""
}

variable "encryption_algorithm" {
  description = "Algo for encryption"
  default     = "RSA-OAEP"
}

variable "volume_type" {
  default = "All"
}

variable "multiple_ips" {
  description = "Multiple IP Configuration on a Nic"
  type        = map(any)
  default     = null
}

variable "enable_ip_forwarding" {
  default = "false"
}

variable "deployassql" { default = false }
variable "sql_license_type" { default = "Standard" }
variable "r_services_enabled" { default = false }
variable "sql_connectivity_port" { default = 1433 }
variable "sql_connectivity_type" { default = "PRIVATE" }
variable "sql_connectivity_update_username" { default = "sqladmin" }
variable "sql_generate_admin_password" { default = true }
variable "sql_store_password_in_key_vault" { default = true }
variable "sql_admin_password" { default = null }
variable "sql_storage_configuration_use" { default = false }
variable "sql_storage_disk_type" { default = "NEW" }
variable "sql_storage_workload_type" { default = "GENERAL" }
variable "sql_storage_disk_config_data_path" { default = "F:\\Data" }
variable "sql_storage_disk_config_data_drive_luns" { default = [1] }
variable "sql_storage_disk_config_log_path" { default = "G:\\Log" }
variable "sql_storage_disk_config_log_drive_luns" { default = [2] }
variable "sql_storage_disk_config_temp_db_path" { default = "G:\\TempDb" }
variable "sql_storage_disk_config_temp_db_drive_luns" { default = [4] }
variable "ignore_sql_extension" { default = false }

variable "enable_diskformat_changecdromdrive_extension" { default = false }
variable "additional_nics" { default = 0 }
variable "additional_nic_names" { default = [] }
variable "additional_nic_subnetnames" { default = [] }
variable "availability_set_id" { default = null }
variable "windowsfirewall_inbound_ports" { default = "" }
variable "customscriptextension_sastoken" { default = null }
variable "windowsfirewall_inbound_ports_udp" { default = "" }
variable "storage_account_type" {
  default = "Premium_LRS"
}

variable default_policy{
  default=null
}