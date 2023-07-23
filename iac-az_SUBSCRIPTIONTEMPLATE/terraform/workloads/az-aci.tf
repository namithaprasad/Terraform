resource "azurerm_container_group" "ado_agent_container_group" {

  tags = merge(local.default_tags, {
  })
  lifecycle {
    ignore_changes = [tags["CreatedTime"], tags["CreatedBy"], tags["CreatedByPipelineStage"], dns_name_label, fqdn, container[0].secure_environment_variables, container[1].secure_environment_variables]
  }
  name                = "${var.selfhosted_devops_agent_config.agent_name_prefix}-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_workloads.name
  ip_address_type     = "Private"
  os_type             = var.selfhosted_devops_agent_config.os_type
  network_profile_id  = azurerm_network_profile.ado_agent_network_profile.id # depreciated argument
  exposed_port        = [{port=80,protocol="TCP"},{port=81,protocol="TCP"}]  
  subnet_ids          = [data.azurerm_subnet.devops_agent.id]  
  zones               = []  

  dynamic "container" {
    for_each = var.selfhosted_devops_agent_config.agent_config
    content {
      environment_variables = {} # added to remove code drift
      name                  = "${var.selfhosted_devops_agent_config.agent_name_prefix}-${format("%03d", container.value.index)}"
      image                 = "azuredevopsregistrytest.azurecr.io/${container.value.docker_image_name}:${container.value.docker_image_tag}" # "${container.value.docker_image_name}:${container.value.docker_image_tag}"
      cpu                   = container.value.cpu
      memory                = container.value.memory
      cpu_limit             = 0  
      memory_limit          = 0  

      ports {
        port     = container.value.port
        protocol = "TCP"
      }

      secure_environment_variables = {
        AZP_URL         = "https://dev.azure.com/${var.selfhosted_devops_agent_config.organization_name}"
        AZP_POOL        = var.selfhosted_devops_agent_config.agent_pool_name
        AZP_TOKEN       = data.azurerm_key_vault_secret.devops_pat_token.value
        AZP_AGENT_NAME  = "${var.selfhosted_devops_agent_config.agent_name_prefix}-${format("%03d", container.value.index)}"
        DEBIAN_FRONTEND = "noninteractive"
      }

      commands = ["/bin/bash", "-c", "apt-get clean && apt-get update && apt-get install -y --no-install-recommends ca-certificates curl jq git vim sudo wget curl netcat libssl1.0 unzip | bash -x"]
    }
  }

  image_registry_credential {
          server   = "azuredevopsregistrytest.azurecr.io"
          username = "azuredevopsregistrytest"
        }

}


data "azurerm_key_vault" "keyvault" {
  name                = var.sub_config.key_vault_name
  resource_group_name = var.sub_config.services_resource_group
}

data "azurerm_key_vault_secret" "devops_pat_token" {
  name         = "DevOpsAgent--Installer--PATToken"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
