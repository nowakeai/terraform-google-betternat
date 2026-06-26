variable "name" {
  type        = string
  description = "Base name for BetterNAT GCP gateway resources."
}

variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "region" {
  type        = string
  description = "GCP region for regional resources."
}

variable "zone" {
  type        = string
  description = "GCP zone for the gateway group."
}

variable "network" {
  type        = string
  description = "Existing VPC network name."
}

variable "subnetwork" {
  type        = string
  description = "Existing regional subnetwork name for gateway NICs."
}

variable "client_tag" {
  type        = string
  description = "Network tag on private clients that should use the BetterNAT route."
}

variable "private_cidrs" {
  type        = list(string)
  description = "Private CIDR ranges allowed to use BetterNAT for SNAT."
}

variable "route_name" {
  type        = string
  description = "Existing or provider-owned route name. Defaults to <name>-default-via-gateway."
  default     = null
}

variable "route_priority" {
  type        = number
  description = "GCP route priority for private-client egress."
  default     = 800
}

variable "route_destination_cidr" {
  type        = string
  description = "Destination CIDR for the BetterNAT egress route."
  default     = "0.0.0.0/0"
}

variable "machine_type" {
  type        = string
  description = "Gateway VM machine type."
  default     = "e2-small"
}

variable "image_project" {
  type        = string
  description = "Gateway VM image project."
  default     = "debian-cloud"
}

variable "image_family" {
  type        = string
  description = "Gateway VM image family."
  default     = "debian-12"
}

variable "gateway_count" {
  type        = number
  description = "Gateway capacity in the zonal gateway group."
  default     = 2
}

variable "capacity_repair_mode" {
  type        = string
  description = "GCP capacity repair mode. Use mig for the GA path; unmanaged remains an alpha escape hatch."
  default     = "mig"

  validation {
    condition     = contains(["mig", "unmanaged"], var.capacity_repair_mode)
    error_message = "capacity_repair_mode must be mig or unmanaged."
  }
}

variable "enable_agent_ha" {
  type        = bool
  description = "Enable Firestore-backed BetterNAT agent HA."
  default     = true
}

variable "betternat_version" {
  type        = string
  description = "BetterNAT runtime release tag used for gateway bootstrap artifacts. Required unless explicit binary URLs and checksums are supplied."
  default     = null
}

variable "firestore_database_id" {
  type        = string
  description = "Firestore Native database ID for HA coordination."
  default     = "(default)"
}

variable "firestore_location_id" {
  type        = string
  description = "Firestore Native database location when manage_firestore_database is true. Defaults in the provider to region."
  default     = null
}

variable "manage_firestore_database" {
  type        = bool
  description = "Create and delete the Firestore Native database for disposable or greenfield stacks."
  default     = false
}

variable "service_account_email" {
  type        = string
  description = "Runtime service account email attached to gateway VMs. Required unless manage_runtime_service_account creates it."
  default     = null
}

variable "runtime_service_account_id" {
  type        = string
  description = "Project-local service account ID used when manage_runtime_service_account is true."
  default     = null
}

variable "manage_runtime_service_account" {
  type        = bool
  description = "Create and delete the runtime service account for gateway VMs."
  default     = false
}

variable "runtime_iam_role_id" {
  type        = string
  description = "Project-local custom IAM role ID used when manage_runtime_iam is true."
  default     = null
}

variable "manage_runtime_iam" {
  type        = bool
  description = "Create or update the BetterNAT runtime custom role and bind service_account_email."
  default     = false
}

variable "stable_public_identity_address_name" {
  type        = string
  description = "Existing regional static external IPv4 address name used for stable egress identity handover."
  default     = null
}

variable "agent_binary_url" {
  type        = string
  description = "Advanced test-only override for the betternat-agent binary URL."
  default     = null
  sensitive   = true
}

variable "agent_binary_sha256" {
  type        = string
  description = "Advanced test-only override for the betternat-agent binary SHA256."
  default     = null
}

variable "cli_binary_url" {
  type        = string
  description = "Advanced test-only override for the betternat CLI binary URL."
  default     = null
  sensitive   = true
}

variable "cli_binary_sha256" {
  type        = string
  description = "Advanced test-only override for the betternat CLI binary SHA256."
  default     = null
}

variable "loxicmd_binary_url" {
  type        = string
  description = "Advanced override for a host loxicmd binary URL."
  default     = null
  sensitive   = true
}

variable "loxicmd_binary_sha256" {
  type        = string
  description = "Advanced override for loxicmd_binary_url SHA256."
  default     = null
}
