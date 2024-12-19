output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "bucket_name" {
  value = google_storage_bucket.app_storage.name
}

output "service_account_email" {
  value = data.google_service_account.sa.email
}
