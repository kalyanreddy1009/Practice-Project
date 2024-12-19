provider "google" {
  credentials = google_service_account_key.terraform_sa_key.private_key # Use the private key of the created service account
  project     = var.gcp_project
  region      = var.gcp_region
}

# Create the GKE cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location

  initial_node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

# Create the service account for Terraform
resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
}

# Create a key for the service account
resource "google_service_account_key" "terraform_sa_key" {
  service_account_id = google_service_account.terraform_sa.name
}

# Create a Google Storage Bucket for Jenkins
resource "google_storage_bucket" "jenkins_bucket" {
  name          = var.jenkins_bucket_name
  location      = var.jenkins_bucket_location
  force_destroy = var.force_destroy
}

# Enable required APIs
resource "google_project_service" "container_api" {
  project = var.gcp_project
  service = "container.googleapis.com"
}

resource "google_project_service" "compute_api" {
  project = var.gcp_project
  service = "compute.googleapis.com"
}

resource "google_project_service" "storage_api" {
  project = var.gcp_project
  service = "storage.googleapis.com"
}

# Kubernetes provider configuration using the service account
provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

data "google_client_config" "default" {}
