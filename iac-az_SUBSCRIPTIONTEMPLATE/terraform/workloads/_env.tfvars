sub_config = {
    services_resource_group             = "rg-EEE-XXX-services-001"
    workloads_resource_group            = "rg-EEE-XXX-workloads-001"
    storage_account_name                = "stasahigXXXEEE"
    key_vault_name                      = "kvEEEXXXstd001"
    recovery_services_vault_name        = "rsv-EEE-XXX-std-001"
}

  private_endpoint_name_sa = "pep-prd-mgt-asa-001"
  private_endpoint_name_kv = "pep-prd-mgt-akv-001"
  private_endpoint_name_sa_ase     = "pep-prd-mgt-asa-002"
  private_endpoint_name_kv_ase     = "pep-prd-mgt-akv-002"

selfhosted_devops_agent_config = {
  agent_name_prefix      = "aci-XXX-EEE-devops"
  vnet_resource_group    = "rg-XXX-EEE-services-001"
  vnet                   = "vnet-XXX-EEE-std-001"
  subnet                 = "snet-XXX-EEE-aci-001"
  agent_pool_name        = "azureaustraliaeastselfhosted"
  network_profile_prefix = "np-XXX-EEE-aci"
  os_type                = "Linux"
  agent_config = [
    {
      index             = "1"
      docker_image_name = "ubuntuaci"
      docker_image_tag  = "latest"
      cpu               = "2"
      memory            = "4"
      port              = "80"
    },
    {
      index             = "2"
      docker_image_name = "ubuntuaci"
      docker_image_tag  = "latest"
      cpu               = "2"
      memory            = "4"
      port              = "81"
    }
  ]
