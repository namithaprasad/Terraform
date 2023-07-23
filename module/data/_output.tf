locals {
  ip_range_onprem = [
    "10.0.0.0/16"
  ]

  ip_ranges_onprem_userendpoint = [ # User endpoint routes - APAC
    "10.0.0.0/16"
  ]

  ip_range_azure = ["10.0.0.0/16"]

  ips_azure_jumpboxes = ["10.0.0.0/16"]

  ip_appgateway = "10.0.0.0/16"

  ip_az_firewall = ["10.0.0.0/16"]

  ip_az_all_firewall_publicips = concat(local.ip_az_firewall, local.ip_az_palo_alto_internel_publicip)


  ip_azure_ad_dcs  = ["10.0.0.0/16"]
  ip_onprem_ad_dcs = ["10.0.0.0/16"]
  ip_all_ad_dcs    = concat(local.ip_azure_ad_dcs, local.ip_onprem_ad_dcs)

  ip_az_firewall_internal = "10.0.0.0/16"

}


output "OnPrem_Ranges" {
  value = concat(local.ip_range_onprem, local.ip_ranges_onprem_userendpoint)
}

output "Azure_Ranges" {
  value = local.ip_range_azure
}


output "ip_subnet_appgateway" {
  value = local.ip_appgateway
}

output "ip_range_prisma" {
  value = local.ip_range_prisma
}

output "ip_az_firewall" {
  value = local.ip_az_firewall
}


output "ip_azure_ad_dcs" {
  value = local.ip_azure_ad_dcs
}

output "ip_onprem_ad_dcs" {
  value = local.ip_onprem_ad_dcs
}

output "ip_all_ad_dcs" {
  value = local.ip_all_ad_dcs
}

output "ip_az_firewall_internal" {
  value = local.ip_az_firewall_internal
}


output "ip_az_all_firewall_publicips" {
  value = local.ip_az_all_firewall_publicips
}