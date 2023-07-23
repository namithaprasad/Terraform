output "subnets" {
  value = azurerm_subnet.snet
}

output "name" {
  value = azurerm_virtual_network.vnet.name
}

output "id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_cidr_bastion" {
  value = var.subnet_cidr_bastion
}

output "address_space" {
  value = var.address_space
}
