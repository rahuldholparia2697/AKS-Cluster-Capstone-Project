output "id" {
  value = azurerm_kubernetes_cluster.AKS.id
}

output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.AKS.kubelet_identity[0].object_id
}

output "aks_identity_principal_id" {
  value = azurerm_kubernetes_cluster.AKS.identity[0].principal_id
}

output "agic_identity_id" {
  description = "The Object ID of the AGIC Managed Identity"
  # Use [0] if your provider version treats this block as a list
  value = azurerm_kubernetes_cluster.AKS.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}