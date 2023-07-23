resource "azurerm_security_center_workspace" "std" {
  scope        = data.azurerm_subscription.primary.id
  workspace_id = "/subscriptions/${var.sub_config.la_config.sub_platform_management_id}/resourceGroups/${var.sub_config.la_config.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${var.sub_config.la_config.name}"
}

resource "azurerm_security_center_auto_provisioning" "std" {
  auto_provision = "On"
}

resource "azurerm_security_center_contact" "std" {
  email = "abc@outlook.com"
  phone = null

  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_security_center_setting" "mcas" {
  setting_name = "MCAS"
  enabled      = true
}

resource "azurerm_security_center_setting" "wdatp" {
  setting_name = "WDATP"
  enabled      = true
}

resource "azurerm_security_center_subscription_pricing" "vm" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "ase" {
  tier          = "Standard"
  resource_type = "AppServices"
}

resource "azurerm_security_center_subscription_pricing" "sql" {
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_security_center_subscription_pricing" "sqlvm" {
  tier          = "Standard"
  resource_type = "SqlServerVirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "sa" {
  tier          = "Standard"
  resource_type = "StorageAccounts"
}

resource "azurerm_security_center_subscription_pricing" "aks" {
  tier          = "Standard"
  resource_type = "KubernetesService"
}

resource "azurerm_security_center_subscription_pricing" "acr" {
  tier          = "Standard"
  resource_type = "ContainerRegistry"
}

resource "azurerm_security_center_subscription_pricing" "kv" {
  tier          = "Standard"
  resource_type = "KeyVaults"
}

resource "azurerm_security_center_subscription_pricing" "arm" {
  tier          = "Standard"
  resource_type = "Arm"
}

resource "azurerm_security_center_subscription_pricing" "dns" {
  tier          = "Standard"
  resource_type = "Dns"
}

resource "azurerm_security_center_subscription_pricing" "container app" {
  tier          = "Standard"
  resource_type = "capp"
}

resource "azurerm_security_center_subscription_pricing" "function app" {
  tier          = "Standard"
  resource_type = "function app"
}

resource "azurerm_security_center_subscription_pricing" "logic app" {
  tier          = "Standard"
  resource_type = "logic app"
}
