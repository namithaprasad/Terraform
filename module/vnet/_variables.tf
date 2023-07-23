variable "resource_group_name" {}
variable "location" {}
variable "tags" { default = null }

variable "name" {}
variable "address_space" {}
variable "dns_servers" {}
variable "subnet_names" {}
variable "subnet_address_spaces" {}
variable "subnet_custom_route_tables" {}
variable "use_standard_routetables" { default = true }
variable "standard_routetable_names" {}
variable "append_to_standard_routetables" { default = null }
variable "subnet_cidr_bastion" {}
variable "add_bastion" { default = false }
variable "bastion_name" {}
variable "asg_names" {}
variable "service_endpoints" { default = ["Microsoft.Storage", "Microsoft.KeyVault"] }
variable "add_default_asgs" { default = false }
variable "existing_bst_pip_name" { default = null }
variable "subnets_with_private_endpoints" { default = null }
variable "subnet_delegation" { default = {} }
variable "default_route_virtual_appliance_ip" { default = "10.0.0.10" } # WP7 - Enable VDI subnet outbound internet traffic to route via the Palo Alto Firewalls (SCTASK0076154, REQ0049378, RITM0056221)
variable "custom_azure_routetables" { default = {} }
variable "extra_routes" { default = null }
variable "disable_bgp_route_propagation" { default = null } # Adding variable to correct the code drift
variable "private_link_service_enabled" {
  default = {}
}
