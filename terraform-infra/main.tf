# main.tf

provider "google" {
  project = "maximal-cabinet-442109-b6"  # Your GCP project ID
  region  = var.region                    # Region from variables.tf
  zone    = var.zone                      # Zone from variables.tf
}

# Use existing Service Account (terraform-sa@maximal-cabinet-442109-b6.iam.gserviceaccount.com)
resource "google_service_account" "sa" {
  account_id   = "terraform-sa"  # The account ID (does not need to be the full email)
  display_name = "Terraform Service Account"
  email        = "terraform-sa@maximal-cabinet-442109-b6.iam.gserviceaccount.com"  # Provided email
}

# Create IAM roles for the service account
resource "google_project_iam_member" "sa_role" {
  project = "maximal-cabinet-442109-b6"  # Your GCP project ID
  role    = "roles/container.admin"      # You can change the IAM role as per your requirements
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Create a GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name  # Cluster name from variables.tf
  location = var.region        # Region from variables.tf
  initial_node_count = 3

  node_config {
    machine_type = "e2-medium"  # Change machine type as needed
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Enable GKE features like the API
  enable_network_policy = true
}

# Create a GCS Bucket for Terraform state (optional but recommended)
resource "google_storage_bucket" "app_storage" {
  name          = var.bucket_name      # Bucket name from variables.tf
  location      = "US"                 # Location set as "US" for simplicity
  force_destroy = true                 # Allow deletion of non-empty buckets
}

