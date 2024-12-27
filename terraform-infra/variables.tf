variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = "maximal-cabinet-442109-b6"
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
  default     = "us-central1-a"
}

variable "trusted_ips" {
  description = "List of trusted IPs for firewall rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "gke_node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "jenkins_machine_type" {
  description = "Machine type for Jenkins VM"
  type        = string
  default     = "e2-medium"
}
