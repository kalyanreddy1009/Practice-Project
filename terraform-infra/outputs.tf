output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_kubeconfig" {
  value = google_container_cluster.primary.kube_config[0].raw_kube_config
}
