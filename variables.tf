variable "subscription_id" {
  description = "Azure subscription ID to deploy into. Optional here if the ARM_SUBSCRIPTION_ID environment variable is set instead."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure region to deploy all resources into."
  type        = string
  default     = "polandcentral"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group that will contain all resources."
  type        = string
  default     = "rg-app-demo-lab"
}

variable "acr_name" {
  description = "Globally unique name for the Azure Container Registry. 5-50 characters, letters and numbers only (no hyphens or symbols)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.acr_name))
    error_message = "acr_name must be 5-50 characters, letters and numbers only, with no hyphens or symbols, and must be globally unique across Azure."
  }
}

variable "acr_sku" {
  description = "Pricing tier for the Container Registry. Basic is the cheapest tier and is sufficient for a lab."
  type        = string
  default     = "Basic"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
  default     = "aks-app-demo-lab"
}

variable "aks_node_count" {
  description = "Number of nodes in the default AKS node pool. Kept at 1 to minimize cost for a homework/lab environment."
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes. Standard_B2s is a low-cost burstable size suitable for a lab, not for production workloads."
  type        = string
  default     = "Standard_B2s"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    project     = "app-demo"
    environment = "lab"
    managed_by  = "terraform"
  }
}
