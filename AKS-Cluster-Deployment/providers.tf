terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "DevOps-RG"
    storage_account_name = "terraformremotebackend26"
    container_name       = "remotebackend"
    key                  = "terraform.tfstate"

    # Tells the backend to also use the Managed Identity
    use_msi = true
  }
}

provider "azurerm" {
  features {}
}