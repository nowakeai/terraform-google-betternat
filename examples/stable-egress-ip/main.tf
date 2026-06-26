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

resource "google_compute_address" "egress" {
  project      = var.project_id
  region       = var.region
  name         = "${var.name}-egress"
  address_type = "EXTERNAL"
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

  stable_public_identity_address_name = google_compute_address.egress.name
}

variable "name" {
  type    = string
  default = "betternat-stable"
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
  type = string
}

variable "private_cidrs" {
  type = list(string)
}

variable "betternat_version" {
  type        = string
  description = "GCP-capable BetterNAT runtime release tag."
}

output "stable_egress_ip" {
  value = google_compute_address.egress.address
}
