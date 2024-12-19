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
  default     = "maximal-cabinet-442109-b6"
}
variable "trusted_ip_range" {
  description = "Trusted IP range for accessing GKE master nodes"
  default     = "203.0.113.0/24"  # Replace with your IP range
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  default     = "10.0.0.0/24"  # Adjust as necessary
}

variable "http_source_ranges" {
  description = "Source IP ranges allowed to access HTTP services"
  default     = ["0.0.0.0/0"]  # Open to all; restrict if necessary
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed to access SSH services"
  default     = ["203.0.113.0/24"]  # Replace with your trusted IP range
}
