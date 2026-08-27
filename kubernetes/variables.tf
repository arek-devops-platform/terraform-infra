variable "subscription_id" {
  description = "Azure subscription ID the AKS cluster lives in. Optional here if the ARM_SUBSCRIPTION_ID environment variable is set instead."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "Name of the resource group containing the AKS cluster. Must match the infra stage's resource_group_name."
  type        = string
  default     = "rg-app-demo-lab"
}

variable "aks_cluster_name" {
  description = "Name of the existing AKS cluster to read. Must match the infra stage's aks_cluster_name."
  type        = string
  default     = "aks-app-demo-lab"
}

variable "namespaces" {
  description = "Kubernetes namespaces to create inside the AKS cluster."
  type        = list(string)
  default     = ["dev", "prod"]
}
