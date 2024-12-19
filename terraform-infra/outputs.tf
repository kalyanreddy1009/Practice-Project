# Output the cluster name
output "cluster_name" {
  value = google_container_cluster.primary.name
}

# Output the cluster endpoint
output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

# Output the cluster CA certificate
output "cluster_ca_certificate" {
  value = google_container_cluster.primary.cluster_ca_certificate
}

# Output the service account email
output "service_account_email" {
  value = "terraform-sa@maximal-cabinet-442109-b6.iam.gserviceaccount.com"
}
