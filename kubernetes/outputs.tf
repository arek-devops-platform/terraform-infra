output "kubernetes_namespaces" {
  description = "Kubernetes namespaces created inside the cluster."
  value       = [for ns in kubernetes_namespace_v1.envs : ns.metadata[0].name]
}
