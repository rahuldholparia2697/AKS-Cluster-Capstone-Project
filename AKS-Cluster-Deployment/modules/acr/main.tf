resource "azurerm_container_registry" "ACR" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku           = "Premium"
  admin_enabled = false

  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "PE" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "acr-priv-conn"
    private_connection_resource_id = azurerm_container_registry.ACR.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
}