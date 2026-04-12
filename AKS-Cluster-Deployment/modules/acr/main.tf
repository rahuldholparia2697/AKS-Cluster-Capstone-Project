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

resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
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

  private_dns_zone_group {
    name = "acr-dns-zone-group"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.acr.id
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  name                  = "${var.name}-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = var.vnet_id

  registration_enabled = false
}