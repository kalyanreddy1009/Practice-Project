variable "gcp_project" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "gcp_region" {
  description = "The Google Cloud region"
  type        = string
}

variable "gcp_credentials_file" {
  description = "Path to the service account key file"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "cluster_location" {
  description = "The location of the GKE cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
}

variable "machine_type" {
  description = "Machine type for the nodes"
  type        = string
}

variable "jenkins_bucket_name" {
  description = "The name of the Jenkins Google Storage Bucket"
  type        = string
}

variable "jenkins_bucket_location" {
  description = "The location of the Jenkins Google Storage Bucket"
  type        = string
}

variable "force_destroy" {
  description = "Whether to forcefully destroy the storage bucket"
  type        = bool
  default     = true
}
