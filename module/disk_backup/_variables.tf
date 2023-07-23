variable "name" { default = null }
variable "location" { default = null }
variable "disks_to_backup" { default = [] }
variable "backup_vault" { default = null }
variable "backup_vault_resource_group" { default = null }
variable "backup_vault_retention_days" { default = "P32D" }
variable "backup_vault_retention_weeks" { default = "P52W" }
variable "snapshot_resource_group" { default = null }
