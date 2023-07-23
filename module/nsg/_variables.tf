
variable "resource_group_name" {}
variable "network_security_group_name" {}
variable "storage_account_id" {}
variable "networkwatcher_name" { default = null }
variable "location" {}
variable "subnet_name" {}
variable "vnet_name" {}
variable "inbound_ad" { default = false }
variable "outbound_ad" { default = false }
variable "outbound_ad_wvd" { default = false }
variable "outbound_internet" { default = false }
variable "bastion" { default = false }
variable "bastion_cidr" { default = "128.0.0.1" }
variable "attach_nsg" { default = true }
variable "tags" { default = null }
variable "rules_default" { default = true }
variable "flowlog_la_workspace_id" { default = "workspace id" } 
variable "flowlog_la_workspace_resource_id" { default = "resource id from properties" }
######
variable "custom_rules_with_asg" { default = [] }
variable "custom_rules_with_ip" { default = [] }
variable "custom_rules_with_servicetags_outbound" { default = [] }
variable "custom_rules_with_src_ip_dest_asgs" { default = [] }
variable "custom_rules_with_src_servicetags_dest_asgs" { default = [] }
variable "custom_rules_with_src_asg_dest_servicetags" { default = [] }
variable "networkwatcher_workspace_region" { default = "" }
