output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "service_account_email" {
  value = google_service_account.sa.email
}

output "bucket_name" {
  value = google_storage_bucket.app_storage.name
}

output "jenkins_agent_ip" {
  description = "Public IP of the Jenkins agent"
  value       = google_compute_instance.jenkins_agent.network_interface[0].access_config[0].nat_ip
}
