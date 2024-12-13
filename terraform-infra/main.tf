provider "google" {
  credentials = file("./maximal-cabinet-442109-b6-38a77e8b7647.json")
  project     = "maximal-cabinet-442109-b6"
  region      = "us-central1"
}
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "webapp-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "webapp-subnet"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc_network.id
  region        = var.region
}

resource "google_container_cluster" "gke_cluster" {
  name     = "webapp-gke-cluster"
  location = var.region

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_compute_instance" "jenkins" {
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
