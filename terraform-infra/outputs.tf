output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

# Output the kubeconfig for the cluster
output "cluster_kubeconfig" {
  value = google_container_cluster.primary.kube_config_raw
}

# If you still need to output the service account key, you can adjust it here
# Example output if using an existing service account:
output "service_account_email" {
  value = "terraform-sa@maximal-cabinet-442109-b6.iam.gserviceaccount.com"
}
