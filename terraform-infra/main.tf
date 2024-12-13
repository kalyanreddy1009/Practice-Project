# Default provider configuration
provider "google" {
  credentials = file("./maximal-cabinet-442109-b6-38a77e8b7647.json")
  project     = "maximal-cabinet-442109-b6"
  region      = "us-central1"
}


provider "google" {
  project = var.project_id
  region  = var.region

# Alternative provider configuration with alias
provider "google" {
  alias       = "secondary"  # Use an alias to distinguish this provider configuration
  project     = var.project_id
  region      = var.region

}

resource "google_compute_network" "vpc_network" {
  provider = google  # This uses the default provider configuration
  name     = "webapp-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  provider      = google  # This uses the default provider configuration
  name          = "webapp-subnet"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc_network.id
  region        = var.region
}

resource "google_container_cluster" "gke_cluster" {
  provider = google  # This uses the default provider configuration
  name     = "webapp-gke-clusterr"
  location = var.region

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
 initial_node_count = 3
}

resource "google_compute_instance" "jenkins" {
  provider = google  # This uses the default provider configuration
  name         = "jenkins-server"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
      size  = 20
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  tags = ["http-server"]
}
