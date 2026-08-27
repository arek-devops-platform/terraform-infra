resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku

  # RBAC-only access - no admin username/password.
  admin_enabled = false

  tags = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  dns_prefix          = var.aks_cluster_name

  # Free control-plane tier - no cost/SLA add-on, fine for a lab.
  sku_tier = "Free"

  default_node_pool {
    name       = "default"
    node_count = var.aks_node_count
    vm_size    = var.aks_vm_size
  }

  # Manual mode keeps node provisioning limited to the fixed-size node pool
  # above - avoids AKS auto-provisioning extra nodes (and extra cost).
  node_provisioning_profile {
    mode = "Manual"
  }

  # System-assigned managed identity - Azure creates and rotates the
  # credentials automatically, nothing for us to store or leak.
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Lets the AKS cluster's own kubelet identity pull images from the ACR,
# using Azure RBAC instead of the registry's admin username/password.
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
