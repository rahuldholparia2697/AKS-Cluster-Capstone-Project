resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.kubelet_object_id
}

resource "azurerm_role_assignment" "agic_network_contributor" {
  scope                = var.agic_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = var.agic_principal_id
}