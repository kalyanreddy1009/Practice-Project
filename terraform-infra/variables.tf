# variables.tf

# Google Cloud Configuration
variable "gcp_credentials_file" {
  description = "The path to the Google Cloud service account credentials JSON file"
  type        = string
  default     = "/home/masanipavan/Practice-Project/terraform-infra/maximal-cabinet-442109-b6-1352222c3e5e.json"
}

variable "gcp_project" {
  description = "The Google Cloud project ID"
  type        = string
  default     = "maximal-cabinet-442109-b6"
}

variable "gcp_region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

# GKE Cluster Configuration
variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "my-cluster"
}

variable "cluster_location" {
  description = "The location for the GKE cluster"
  type        = string
  default     = "us-central1-a"
}

variable "node_count" {
  description = "The initial node count for the GKE cluster"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "The machine type for the GKE nodes"
  type        = string
  default     = "e2-medium"
}

# Google Cloud Storage Bucket for Jenkins
variable "jenkins_bucket_name" {
  description = "The name of the Jenkins storage bucket"
  type        = string
  default     = "maximal-cabinet-jenkins-bucket"
}

variable "jenkins_bucket_location" {
  description = "The location for the Jenkins storage bucket"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "Whether to force delete the bucket even if it contains objects"
  type        = bool
  default     = true
}
