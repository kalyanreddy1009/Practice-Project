provider "google" {
  credentials = file("/home/masanipavan/maximal-cabinet-442109-b6.json")
  project     = "maximal-cabinet-442109-b6"
  region      = "us-central1"
}

# Create a GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name               = "web-app-cluster"
  location           = "us-central1"
  initial_node_count = 1
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.gke_cluster.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50  # Ensuring sufficient disk space
    
  }
}

# Create a Jenkins VM with more memory
resource "google_compute_disk" "jenkins_disk" {
  name  = "jenkins-disk"
  type  = "pd-standard"
  zone  = "us-central1-a"
  size  = 50  # in GB for Jenkins' persistence
}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins-server"
  machine_type = "e2-medium"  # Adjusted to reflect the increased memory
  zone         = "us-central1-a"
allow_stopping_for_update = true  
  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  attached_disk {
    source = google_compute_disk.jenkins_disk.id
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    ssh-keys = "Pavan:${file("~/.ssh/id_rsa.pub")}"  # Ensure proper SSH key for access
  }
}

# Create a GCS Bucket for Jenkins Artifacts
resource "google_storage_bucket" "jenkins_artifacts" {
  name          = "jenkins-artifacts-${random_id.bucket_id.hex}"
  location      = "US"
  storage_class = "STANDARD"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

# Firewall Rules
resource "google_compute_firewall" "jenkins_http" {
  name    = "allow-jenkins-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]  # Allow HTTP access to Jenkins
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.185.177.132/32"]  # Cloud Shell IP or your personal public IP
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]  # Public HTTPS access
}
