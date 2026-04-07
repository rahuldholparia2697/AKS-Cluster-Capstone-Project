resource "azurerm_virtual_network" "VNET" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = var.aks_subnet_cidr
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = var.private_endpoint_subnet_cidr
}

resource "azurerm_subnet" "agic" {
  name                 = "snet-agic"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = var.agic_subnet_cidr
}