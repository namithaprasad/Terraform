resource "azurerm_network_watcher" "nw" {
  name                = "${data.azurerm_subscription.primary.display_name}_${var.location}_netwatcher"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_services.name
}
