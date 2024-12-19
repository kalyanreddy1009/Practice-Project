output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_kubeconfig" {
  value = google_container_cluster.primary.kube_config[0].raw_kube_config
}
# Output the service account key for future use or configuration (optional)
output "service_account_key" {
  value     = google_service_account_key.terraform_sa_key.private_key
  sensitive = true
}
