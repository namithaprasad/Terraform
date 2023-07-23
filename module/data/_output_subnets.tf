locals {
  #Platform-Management-Web
  mgt_vnet_name                = "vnet-prd-mgt-std-001"
  mgt_web_subnet_name          = "snet-prd-mgt-web-001"
  mgt_vnet_resource_group_name = "rg-prd-mgt-services-001"
}

output "mgt_vnet_name" {
  value = local.mgt_vnet_name
}


output "mgt_web_subnet_name" {
  value = local.mgt_web_subnet_name
}

output "mgt_vnet_resource_group_name" {
  value = local.mgt_vnet_resource_group_name
}

