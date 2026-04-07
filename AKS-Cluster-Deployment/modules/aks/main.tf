resource "azurerm_kubernetes_cluster" "AKS" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  private_cluster_enabled = false

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"  # or "calico" if preferred
    
    # Overlay uses a separate pod CIDR (not from VNet)
    # Must NOT overlap with your VNet (10.10.0.0/16)
    pod_cidr           = "100.64.0.0/16"  # Default recommended for overlay
    
    # Service CIDR - should not overlap with VNet or pod_cidr
    service_cidr       = "10.0.0.0/16"
    
    # DNS service IP - must be within service_cidr
    dns_service_ip     = "10.0.0.10"
  }

  ingress_application_gateway {
    gateway_name = "agic-appgw"
    subnet_id    = var.agic_subnet_id
  }

  default_node_pool {
    name       = "system"
    vm_size    = var.system_vm_size
    # node_count = var.system_node_count
    auto_scaling_enabled = true
    min_count           = var.system_min_count
    max_count           = var.system_max_count

    vnet_subnet_id = var.aks_subnet_id
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }
}