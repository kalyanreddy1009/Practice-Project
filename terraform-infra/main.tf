# Default provider configuration
provider "google" {
  credentials = file("./maximal-cabinet-442109-b6-38a77e8b7647.json")
  project     = "maximal-cabinet-442109-b6"
  region      = "us-central1"
}

# Alternative provider configuration with alias
provider "google" {
  alias       = "secondary"  # Use an alias to distinguish this provider configuration
  project     = var.project_id
  region      = var.region
}

# Fetch existing VPC network
data "google_compute_network" "existing_vpc" {
  name = "webapp-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  provider      = google  # This uses the default provider configuration
  name          = "webapp-subnet"
  ip_cidr_range = "10.0.0.0/16"
  network       = data.google_compute_network.existing_vpc.id
  region        = var.region
}

resource "google_container_cluster" "gke_cluster" {
  provider = google  # This uses the default provider configuration
  name     = "webapp-gke-cluster"
  location = var.region

  # Enable private cluster (no external IPs for GKE nodes)
  private_cluster_config {
    enable_private_nodes    = true  # Disable external IPs for nodes
    enable_private_endpoint = false  # External access to control plane is disabled
    master_ipv4_cidr_block  = "172.16.0.0/28"  # Define a private CIDR block for the master
  }

  node_config {
    machine_type = "e2-small"  # Reduced machine type for lower resource usage
    disk_size_gb = 30          # Reduced disk size
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  initial_node_count = 2  # Reduced initial node count
  node_locations      = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

resource "google_compute_instance" "jenkins" {
  provider = google  # This uses the default provider configuration
  name         = "jenkins-server"
  machine_type = "e2-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
      size  = 20
    }
  }

  network_interface {
    network    = data.google_compute_network.existing_vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
  }

  tags = ["http-server"]
}
