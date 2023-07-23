variable "location" { default = "UK South" }
variable "tags" {}
variable "sql_server_name" {}
variable "resource_group_name" {}
variable "sql_connection_policy" { default = "Default" }
variable "sql_administrator_login" { default = "sqladmin" }
variable "sql_version" { default = "12.0" }
variable "store_password_in_key_vault" { default = true }
variable "generate_password" { default = true }
variable "key_vault_name" { default = "" }
variable "key_vault_resource_group" { default = "" }
variable "sqldbs" {}
variable "sql_vnet_rule_subnet_ids" { default = [] }
variable "minimum_tls_version" { default = "1.2" }
variable "public_network_access_enabled" { default = false }

# Private Endpoint Variables
variable "enable_private_endpoint" { default = false }
variable "private_endpoint_name" {}
variable "private_endpoint_subnet_name" {}
variable "private_endpoint_vnet_name" {}
variable "private_endpoint_vnet_resource_group_name" {}
