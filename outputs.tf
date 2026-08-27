output "resource_group_name" {
  description = "Name of the resource group containing all resources."
  value       = azurerm_resource_group.main.name
}

output "acr_login_server" {
  description = "Login server URL for the Container Registry (used in image tags, e.g. <login_server>/app-demo:latest)."
  value       = azurerm_container_registry.acr.login_server
}

output "acr_name" {
  description = "Name of the Container Registry."
  value       = azurerm_container_registry.acr.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_get_credentials_command" {
  description = "Azure CLI command to fetch kubeconfig credentials for this cluster."
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}
