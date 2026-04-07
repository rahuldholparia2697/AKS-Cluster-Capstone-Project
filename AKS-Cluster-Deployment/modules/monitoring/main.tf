resource "azurerm_log_analytics_workspace" "LAW" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_data_collection_rule" "aks-dcr" {
  name                = "dcr-aks-container-insights"
  location            = var.location
  resource_group_name = var.resource_group_name

  data_sources {
    extension {
      name           = "ContainerInsightsExtension"
      extension_name = "AzureMonitorLinuxAgent"
      streams = ["Microsoft-ContainerInsights-Group-Default"]
    }
  }

  destinations {
    log_analytics {
      name                  = "law"
      workspace_resource_id = azurerm_log_analytics_workspace.LAW.id
    }
  }

  data_flow {
    streams      = ["Microsoft-ContainerInsights-Group-Default"]
    destinations = ["law"]
  }
}

resource "azurerm_monitor_data_collection_rule_association" "aks" {
  name                    = "dcr-aks-association"
  target_resource_id      = var.aks_cluster_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.aks-dcr.id
}

resource "azurerm_role_assignment" "aks_monitoring" {
  scope                = azurerm_log_analytics_workspace.LAW.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = var.aks_identity_principal_id
}