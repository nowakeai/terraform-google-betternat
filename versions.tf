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
