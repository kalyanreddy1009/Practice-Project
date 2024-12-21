provider "google" {
  credentials = file("/home/masanipavan/maximal-cabinet-442109-b6.json")
  project     = "maximal-cabinet-442109-b6"
  region      = "us-central1"
}

resource "google_container_cluster" "gke_cluster" {
  name               = "web-app-cluster"
  location           = "us-central1"
  initial_node_count = 1
  node_config {
    machine_type = "e2-medium"
  }
}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins-server"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  
  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_storage_bucket" "jenkins_artifacts" {
  name          = "jenkins-artifacts-${random_id.bucket_id.hex}"
  location      = "US"
  storage_class = "STANDARD"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}
