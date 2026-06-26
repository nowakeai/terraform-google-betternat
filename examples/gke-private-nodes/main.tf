terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
    betternat = {
      source  = "nowakeai/betternat"
      version = ">= 0.2.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "betternat" {
  source = "../.."

  name       = var.name
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  network    = var.network
  subnetwork = var.node_subnetwork
  client_tag = var.node_network_tag

  private_cidrs = var.cluster_private_cidrs

  betternat_version = var.betternat_version

  manage_runtime_service_account = true
  manage_runtime_iam             = true
}

variable "name" {
  type    = string
  default = "gke-egress"
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-west2"
}

variable "zone" {
  type    = string
  default = "us-west2-a"
}

variable "network" {
  type        = string
  description = "VPC network used by the private GKE nodes."
}

variable "node_subnetwork" {
  type        = string
  description = "Regional subnetwork used by the private GKE nodes."
}

variable "node_network_tag" {
  type        = string
  description = "Network tag present on private GKE node VMs."
}

variable "cluster_private_cidrs" {
  type        = list(string)
  description = "Node and pod/service private CIDRs that should use BetterNAT SNAT."
}

variable "betternat_version" {
  type        = string
  description = "GCP-capable BetterNAT runtime release tag."
}
