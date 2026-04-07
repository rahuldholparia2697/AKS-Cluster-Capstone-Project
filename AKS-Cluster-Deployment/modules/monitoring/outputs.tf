output "id" {
  value = azurerm_log_analytics_workspace.LAW.id
}

output "dcr_id" {
  value = azurerm_monitor_data_collection_rule.aks-dcr.id
}
