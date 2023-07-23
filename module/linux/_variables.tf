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

variable "os_offer" {
  type = string
}

variable "os_publisher" {
  type = string
}

variable "os_sku" {
  type = string
}

variable "os_version" {
  type = string
}

variable "source_image_id" { default = "" }

variable "os_disk_size_gb" {
  type = string
}

variable "data_disk_size_gb" {
  type = list(any)
}

variable "data_disk_caching" {
  type = list(any)
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "generate_password" {
  type = bool
}

variable "store_password_in_key_vault" {
  type = bool
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
  type    = string
  default = "Daily"
}

variable "backup_time" {
  type    = string
  default = "01:00"
}

variable "backup_retention_daily_count" {
  type    = string
  default = 32
}

variable "backup_retention_weekly_count" {
  type    = string
  default = 5
}

variable "backup_retention_monthly_count" {
  type    = string
  default = 13
}

variable "backup_retention_yearly_count" {
  type    = string
  default = 10
}

variable "backup_retention_weekly_day" {
  type    = string
  default = "Sunday"
}

variable "backup_retention_monthly_week" {
  type    = string
  default = "First"
}

variable "backup_retention_yearly_month" {
  type    = string
  default = "January"
}

variable "az" {
  type = string
}

variable "domain_join" {
    type = bool
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

variable "enable_ip_forwarding" {
  default = "false"
}

variable "plan" {
  default = null
}

variable "storage_account_type" {
  default = "Premium_LRS"
}

variable "vm_lock" {
  type    = bool
  default = true
}

variable "additional_nics" { default = 0 }
variable "additional_nic_names" { default = [] }
variable "additional_nic_subnetnames" { default = [] }
variable "additional_nic_ipforwarding" { default = [] }
variable "additional_nics_publicIpResourceIds" { default = [] }
variable "multiple_ips" {
  description = "Multiple IP Configuration on a Nic"
  type        = map(any)
  default     = null
}
variable "ipconfig_name" {
  type    = string
  default = null
}

variable "custom_os_disk_name" { default = "" }
variable "data_disk_names" { default = [] }

variable default_policy {
  default = null
}