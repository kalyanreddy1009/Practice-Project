output "jenkins_vm_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}

output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "storage_bucket_name" {
  value = google_storage_bucket.jenkins_artifacts.name
}
