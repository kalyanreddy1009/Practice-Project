# variables.tf

variable "region" {
  description = "The GCP region to deploy resources in."
  type        = string
  default     = "us-central1"  # Default region
}

variable "zone" {
  description = "The GCP zone to deploy resources in."
  type        = string
  default     = "us-central1-a"  # Default zone
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
