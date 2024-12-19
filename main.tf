# Provider configuration
provider "google" {
  project = "maximal-cabinet-442109-b6"
  region  = "us-central1"
}

# Create a service account
resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
  description  = "Service account used for Terraform operations"
}

# Assign roles to the service account
resource "google_project_iam_member" "terraform_sa_role" {
  project = "maximal-cabinet-442109-b6"
  role    = "roles/editor"  # You can modify this role based on your needs
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

# Create a service account key
resource "google_service_account_key" "terraform_sa_key" {
  service_account_id = google_service_account.terraform_sa.name
}

# Output the service account details
output "service_account_email" {
  value = google_service_account.terraform_sa.email
}

output "service_account_key" {
  value     = google_service_account_key.terraform_sa_key.private_key
  sensitive = true
}
