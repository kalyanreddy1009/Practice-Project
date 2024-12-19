# variables.tf

variable "region" {
  description = "The GCP region to deploy resources in."
  type        = string
  default     = "us-west1"  # Default region
}

variable "zone" {
  description = "The GCP zone to deploy resources in."
  type        = string
  default     = "us-west1-a"  # Default zone
}

variable "bucket_name" {
  description = "The name of the GCS bucket to store state."
  type        = string
  default     = "maximal-cabinet-442109-b6-tf-state"  # Unique bucket name
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "terraform-cluster"  # Default cluster name
}
variable "project_id" {
  description = "The GCP project ID"
}
