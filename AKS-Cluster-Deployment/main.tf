module "rg" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  name                = var.network-name
  location            = module.rg.location
  resource_group_name = module.rg.name

  address_space                = ["10.10.0.0/16"]
  aks_subnet_cidr              = ["10.10.1.0/24"]
  private_endpoint_subnet_cidr = ["10.10.2.0/24"]
  agic_subnet_cidr             = ["10.10.3.0/24"]
}

module "acr" {
  source                     = "./modules/acr"
  name                       = var.acr-name
  location                   = module.rg.location
  resource_group_name        = module.rg.name
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
}

module "aks" {
  source              = "./modules/aks"
  name                = var.aks-name
  location            = module.rg.location
  resource_group_name = module.rg.name
  dns_prefix          = "akscluster"

  aks_subnet_id  = module.network.aks_subnet_id
  agic_subnet_id = module.network.agic_subnet_id
  # log_analytics_id = module.monitoring.id

  system_vm_size = "Standard_D2ps_v6"
  # system_node_count  = 2
  system_min_count = 1
  system_max_count = 2
}

module "identity" {
  source            = "./modules/identity"
  acr_id            = module.acr.id
  kubelet_object_id = module.aks.kubelet_object_id
  agic_subnet_id    = module.network.agic_subnet_id
  agic_principal_id = module.aks.agic_identity_id
  depends_on        = [module.aks]
}

module "monitoring" {
  source                    = "./modules/monitoring"
  name                      = var.law-name
  location                  = module.rg.location
  resource_group_name       = module.rg.name
  aks_cluster_id            = module.aks.id
  aks_identity_principal_id = module.aks.aks_identity_principal_id
}