module "vnet" {
  source              = "./../../../_modules/vnet"
  resource_group_name = azurerm_resource_group.rg_services.name
  location            = var.location
  tags                = merge(local.default_tags, {})

  name          = "vnet-EEE-XXX-std-001"
  address_space = ["10.20.CC.VN/VN"]
  dns_servers   = ["10.0.0.0", "10.0.0.1"]

  use_standard_routetables       = true
  standard_routetable_names      = ["rt-EEE-XXX-web-001", "rt-EEE-XXX-app-001", "rt-EEE-XXX-db-001", "rt-EEE-XXX-inf-001", "rt-EEE-XXX-svc-001"]
  subnet_names                   = ["snet-EEE-XXX-web-001", "snet-EEE-XXX-app-001", "snet-EEE-XXX-db-001", "snet-EEE-XXX-inf-001", "snet-EEE-XXX-svc-001"]
  subnet_address_spaces          = [["10.20.CC.0/26"], ["10.20.CC.64/26"], ["10.20.CC.128/26"], ["10.20.CC.192/28"], ["10.20.CC.208/28"]]
  subnet_cidr_bastion            = "10.20.CC.224/27"
  subnet_custom_route_tables     = []
  add_bastion                    = true
  bastion_name                   = "bst-EEE-XXX-std-001"
  add_default_asgs               = true
  asg_names                      = []
  subnets_with_private_endpoints = ["snet-EEE-XXX-svc-001"]
}
