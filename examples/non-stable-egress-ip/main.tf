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

  manage_runtime_service_account = true
  manage_runtime_iam             = true

  stable_public_identity_address_name = null
}

variable "name" {
  type    = string
  default = "betternat-nonstable"
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
