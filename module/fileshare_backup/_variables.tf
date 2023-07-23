variable "resource_group_name_recovery_services_vault" {}
variable "resource_group_name_backup_policy" {}
variable "resource_group_name_backup_protected_fs" {}
variable "storage_account_id" {}
variable "storage_account_name" {}
variable "recovery_services_vault_name" {}
variable "backup_frequency" { default = "Daily" }
variable "backup_time" { default = "01:00" }
variable "backup_retention_daily_count" { default = 32 }
variable "backup_retention_weekly_count" { default = 5 }
variable "backup_retention_monthly_count" { default = 13 }
variable "backup_retention_yearly_count" { default = 10 }
variable "backup_retention_weekly_day" { default = "Sunday" }
variable "backup_retention_monthly_week" { default = "First" }
variable "backup_retention_yearly_month" { default = "January" }
variable "fileshares_to_protect" { default = {} }
