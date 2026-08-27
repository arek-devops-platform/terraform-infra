terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
}

# Only used here to read the already-existing AKS cluster via a data source
# (see main.tf) - this stage does not create or modify any Azure resources.
provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}

# Configured from a data source (main.tf), not from a resource being created
# in this same apply. The cluster already exists by the time this stage
# runs, so these values are known at plan time - no first-apply fragility.
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}
