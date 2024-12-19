provider "google" {
  credentials = google_service_account_key.terraform_sa_key.private_key
  project     = "maximal-cabinet-442109-b6"
  region      = "us-central1"
}

# Create the service account for Terraform to use
resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
}

# Create a key for the service account
resource "google_service_account_key" "terraform_sa_key" {
  service_account_id = google_service_account.terraform_sa.name
}

# Create the GKE cluster
resource "google_container_cluster" "primary" {
  name     = "my-cluster"
  location = "us-central1-a"

  initial_node_count = 1

  node_config {
    machine_type = "e2-medium" # A cost-efficient instance for your use case
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# Create a Google Storage Bucket for Jenkins
resource "google_storage_bucket" "jenkins_bucket" {
  name          = "maximal-cabinet-jenkins-bucket"
  location      = "US"
  force_destroy = true
}

# Enable required APIs
resource "google_project_service" "container_api" {
  project = "maximal-cabinet-442109-b6"
  service = "container.googleapis.com"
}

resource "google_project_service" "compute_api" {
  project = "maximal-cabinet-442109-b6"
  service = "compute.googleapis.com"
}

resource "google_project_service" "storage_api" {
  project = "maximal-cabinet-442109-b6"
  service = "storage.googleapis.com"
}

