variable "project_id" {
  description = "The GCP project ID"
  default     = "maximal-cabinet-442109-b6"
}

variable "region" {
  description = "The GCP region"
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  default     = "us-central1-a"
}

variable "node_machine_type" {
  description = "The machine type for the Kubernetes node"
  default     = "e2-medium"
}
