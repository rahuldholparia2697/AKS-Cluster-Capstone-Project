output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "agic_subnet_id" {
  value = azurerm_subnet.agic.id
}

output "vnet_id" {
  value = azurerm_virtual_network.VNET.id
}