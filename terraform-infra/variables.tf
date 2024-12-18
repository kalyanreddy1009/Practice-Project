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

variable "jenkins_master_url" {
  description = "The URL of the Jenkins master."
  type        = string
  default     = "http://your-jenkins-server:8080"  # Change to your Jenkins master URL
}

variable "jenkins_agent_name" {
  description = "The name of the Jenkins agent."
  type        = string
  default     = "my-agent"  # Jenkins agent name
}

variable "jenkins_agent_secret" {
  description = "The secret for the Jenkins agent."
  type        = string
  default     = "your-agent-secret"  # Replace with your Jenkins agent secret
}
