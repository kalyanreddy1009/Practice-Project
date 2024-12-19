# outputs.tf

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.cluster_ca_certificate
}

output "service_account_email" {
  value = google_service_account.terraform_sa.email
}

output "service_account_key" {
  value     = google_service_account_key.terraform_sa_key.private_key
  sensitive = true
}
