output "gke_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.gke_cluster.endpoint
}

output "jenkins_external_ip" {
  description = "External IP of the Jenkins server"
  value       = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}

output "jenkins_bucket_name" {
  description = "Name of the Jenkins artifacts bucket"
  value       = google_storage_bucket.jenkins_artifacts.name
}

output "gke_cluster_name" {
  description = "The name of the GKE Cluster"
  value       = google_container_cluster.gke_cluster.name
}
