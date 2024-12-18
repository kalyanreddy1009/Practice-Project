provider "google" {
  project = "maximal-cabinet-442109-b6"  # Your GCP project ID
  region  = var.region                    # Region from variables.tf
  zone    = var.zone                      # Zone from variables.tf
}

# Use existing Service Account (terraform-sa@maximal-cabinet-442109-b6.iam.gserviceaccount.com)
resource "google_service_account" "sa" {
  account_id   = "terraform-sa"  # The account ID (does not need to be the full email)
  display_name = "Terraform Service Account"
}

# Create IAM roles for the service account
resource "google_project_iam_member" "sa_role" {
  project = "maximal-cabinet-442109-b6"  # Your GCP project ID
  role    = "roles/container.admin"      # You can change the IAM role as per your requirements
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Create a GKE Cluster with minimal resources
resource "google_container_cluster" "primary" {
  name               = var.cluster_name  # Cluster name from variables.tf
  location           = var.region        # Region from variables.tf
  initial_node_count = 1                 # Reduced number of nodes for a minimal setup

  deletion_protection = false  # Prevent accidental deletion

  node_config {
    machine_type = "e2-micro"  # Minimum machine type
    disk_type    = "pd-standard" # Use standard persistent disks instead of SSD
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  private_cluster_config {
    enable_private_nodes = true  # Nodes will only have internal IPs
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "203.0.113.0/24"  # Replace with your trusted IP range for restricted access
      display_name = "My Trusted Network"
    }
  }

  # Disable public endpoint access
  remove_default_node_pool = true  # Optional: disables default node pool for more control
}

# Create a GCS Bucket for Terraform state (optional but recommended)
resource "google_storage_bucket" "app_storage" {
  name          = var.bucket_name      # Bucket name from variables.tf
  location      = "US"                 # Location set as "US" for simplicity
  force_destroy = true                 # Allow deletion of non-empty buckets
}

# Create a VPC network (minimal setup)
resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks  = false  # Set to false to create custom subnets
}

# Create a Subnet (minimal setup) in the desired region and zone
resource "google_compute_subnetwork" "subnet" {
  name          = "subnet"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"  # Adjust the CIDR range as necessary
}

# Add Jenkins Server Instance with minimal resources
resource "google_compute_instance" "jenkins" {
  name         = "jenkins-server"
  machine_type = "e2-micro"  # Very minimal machine type suitable for smaller setups
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
      size  = 10  # Reduced disk size to save on resources
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  tags = ["http-server", "ssh-server"]  # Added ssh-server for firewall targeting
}

# Allow HTTP traffic to Jenkins (port 80)
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Allow SSH traffic to Jenkins (port 22) - Optional: Restrict to specific IP ranges
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["203.0.113.0/24"]  # Restrict SSH access to a specific IP range
  target_tags   = ["ssh-server"]
}
