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

# Create a firewall rule to allow HTTP access to Jenkins (Port 8080)
resource "google_compute_firewall" "jenkins_http" {
  name    = "allow-jenkins-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"] # Public access, change if you need more restricted access
}

# Optional: Add a firewall rule to allow SSH access to Jenkins and GKE instances from Cloud Shell IP (or your IP)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.185.177.132/32"] # Cloud Shell IP or your personal public IP (replace it if needed)
}

# Optional: You can add another rule for HTTPS access if Jenkins or other services are running on HTTPS (port 443)
resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"] # Public access, change if more restricted access is needed
}
