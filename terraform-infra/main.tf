provider "google" {
  project = var.project_id                  # GCP Project ID from variables.tf
  region  = var.region                      # Region from variables.tf
  zone    = var.zone                        # Zone from variables.tf
}

# Use existing Service Account (terraform-sa@maximal-cabinet-442109-b6.iam.gserviceaccount.com)
data "google_service_account" "sa" {
  account_id = "terraform-sa"               # Service account ID (without the project ID and domain part)
  project    = var.project_id                # Specify the project for the service account lookup
}

# Create IAM roles for the service account
resource "google_project_iam_member" "sa_role_container_admin" {
  project = var.project_id
  role    = "roles/container.admin"      # Container Admin role
  member  = "serviceAccount:${data.google_service_account.sa.email}"
}

# Additional IAM roles for compute and storage
resource "google_project_iam_member" "sa_role_compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${data.google_service_account.sa.email}"
}

resource "google_project_iam_member" "sa_role_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_service_account.sa.email}"
}

# Create a GKE Cluster with minimal resources
resource "google_container_cluster" "primary" {
  name               = var.cluster_name  # Cluster name from variables.tf
  location           = var.region        # Region from variables.tf
  initial_node_count = 1                 # Initially set to 1 node for creating node pool manually

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
      cidr_block = var.trusted_ip_range  # Trusted IP range from variables.tf
      display_name = "My Trusted Network"
    }
  }

  # Disable public endpoint access
  remove_default_node_pool = true  # Optional: disables default node pool for more control
}

# Create a Node Pool with 3 instances
resource "google_container_node_pool" "primary_pool" {
  cluster = google_container_cluster.primary.name
  location = var.region

  name     = "primary-node-pool"
  initial_node_count = 3  # Create 3 nodes

  node_config {
    machine_type = "e2-micro"  # Minimum machine type
    disk_type    = "pd-standard" # Use standard persistent disks instead of SSD
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  depends_on = [google_container_cluster.primary]
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
  ip_cidr_range = var.subnet_cidr  # CIDR range from variables.tf
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
  source_ranges = var.http_source_ranges  # Restrict HTTP access using variables.tf
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
  source_ranges = var.ssh_source_ranges  # Restrict SSH access using variables.tf
  target_tags   = ["ssh-server"]
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "bucket_name" {
  value = google_storage_bucket.app_storage.name
}

output "service_account_email" {
  value = data.google_service_account.sa.email
}
