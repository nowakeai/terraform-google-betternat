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
  subnetwork = var.subnetwork
  client_tag = var.client_tag

  private_cidrs = var.private_cidrs

  betternat_version = var.betternat_version

  manage_runtime_service_account = true
  manage_runtime_iam             = true
}

variable "name" {
  type    = string
  default = "betternat-gcp"
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
  type = string
}

variable "subnetwork" {
  type = string
}

variable "client_tag" {
  type    = string
  default = "private-egress-client"
}

variable "private_cidrs" {
  type = list(string)
}

variable "betternat_version" {
  type        = string
  description = "GCP-capable BetterNAT runtime release tag."
}

output "route_name" {
  value = module.betternat.route_name
}

output "egress_public_ips" {
  value = module.betternat.egress_public_ips
}
