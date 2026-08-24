# Reads back the AKS cluster created by the infra stage. Unlike referencing
# azurerm_kubernetes_cluster.aks.kube_config from a resource in the same
# apply, a data source is read live during plan - it requires the cluster to
# already exist, which it does by the time this stage is ever applied.
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = var.resource_group_name
}

resource "kubernetes_namespace_v1" "envs" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
  }
}
