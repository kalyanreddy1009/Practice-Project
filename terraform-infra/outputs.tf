# Output the cluster name
output "cluster_name" {
  value = google_container_cluster.primary.name
}

# Output the cluster endpoint
output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

# Output the kubeconfig for the cluster
output "cluster_kubeconfig" {
  value = google_container_cluster.primary.kube_config.0.raw_kube_config
}

# Output the service account email
output "service_account_email" {
  value = "terraform-sa@maximal-cabinet-442109-b6.iam.gserviceaccount.com"
}
