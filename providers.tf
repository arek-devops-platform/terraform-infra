terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}

# No "kubernetes" provider here on purpose - see kubernetes/providers.tf.
# Configuring it from this stack's own azurerm_kubernetes_cluster resource
# would tie its connection details to a resource that doesn't exist yet on
# the first apply. Namespace management lives in its own Terraform stage
# instead, which reads the already-created cluster back via a data source.
