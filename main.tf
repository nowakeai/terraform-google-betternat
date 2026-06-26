locals {
  route_name = coalesce(var.route_name, "${var.name}-default-via-gateway")
}

resource "betternat_gcp_gateway" "this" {
  name       = var.name
  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  network    = var.network
  subnetwork = var.subnetwork
  client_tag = var.client_tag

  route_name             = local.route_name
  route_priority         = var.route_priority
  route_destination_cidr = var.route_destination_cidr

  machine_type         = var.machine_type
  image_project        = var.image_project
  image_family         = var.image_family
  gateway_count        = var.gateway_count
  capacity_repair_mode = var.capacity_repair_mode
  private_cidrs        = var.private_cidrs

  enable_agent_ha                     = var.enable_agent_ha
  betternat_version                   = var.betternat_version
  firestore_database_id               = var.firestore_database_id
  firestore_location_id               = var.firestore_location_id
  manage_firestore_database           = var.manage_firestore_database
  service_account_email               = var.service_account_email
  runtime_service_account_id          = var.runtime_service_account_id
  manage_runtime_service_account      = var.manage_runtime_service_account
  runtime_iam_role_id                 = var.runtime_iam_role_id
  manage_runtime_iam                  = var.manage_runtime_iam
  stable_public_identity_address_name = var.stable_public_identity_address_name

  agent_binary_url      = var.agent_binary_url
  agent_binary_sha256   = var.agent_binary_sha256
  cli_binary_url        = var.cli_binary_url
  cli_binary_sha256     = var.cli_binary_sha256
  loxicmd_binary_url    = var.loxicmd_binary_url
  loxicmd_binary_sha256 = var.loxicmd_binary_sha256
}
