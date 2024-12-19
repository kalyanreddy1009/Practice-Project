provider "google" {
  credentials = file("/home/masanipavan/Practice-Project/terraform-infra/maximal-cabinet-442109-b6-1352222c3e5e.json") # Path to your key file
  project     = "maximal-cabinet-442109-b6"
  region      = "us-central1"
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
provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.primary.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}
