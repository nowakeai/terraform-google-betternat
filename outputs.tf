output "gateway_id" {
  description = "BetterNAT GCP provider resource ID."
  value       = betternat_gcp_gateway.this.id
}

output "route_name" {
  description = "GCP route managed by BetterNAT."
  value       = betternat_gcp_gateway.this.route_name
}

output "route_target" {
  description = "Current route target reported by the provider."
  value       = betternat_gcp_gateway.this.route_target
}

output "egress_public_ips" {
  description = "Gateway public egress IPs by gateway instance."
  value       = betternat_gcp_gateway.this.egress_public_ips
}

output "gateway_statuses" {
  description = "Gateway instance statuses by gateway instance."
  value       = betternat_gcp_gateway.this.gateway_statuses
}

output "agent_config_hash" {
  description = "Rendered BetterNAT agent config hash."
  value       = betternat_gcp_gateway.this.agent_config_hash
}

output "runtime_iam_permissions" {
  description = "Permissions required by the BetterNAT GCP runtime service account."
  value       = betternat_gcp_gateway.this.runtime_iam_permissions
}
