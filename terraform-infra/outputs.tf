output "jenkins_public_ip" {
  value = length(google_compute_instance.jenkins.network_interface[0].access_config) > 0 ? google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip : "No public IP assigned"
}

output "jenkins_internal_ip" {
  value = google_compute_instance.jenkins.network_interface[0].network_ip
}
