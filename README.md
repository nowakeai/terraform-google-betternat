# terraform-google-betternat

GCP Terraform module for BetterNAT.

This module is the user-facing GCP alpha install surface. It wraps the
`nowakeai/betternat` provider's `betternat_gcp_gateway` resource for an
existing VPC, private-client network tag, Firestore-backed HA, and optional
stable public identity.

## Usage

```hcl
module "betternat" {
  source  = "nowakeai/betternat/google"
  version = "~> 0.2"

  name       = "prod-egress"
  project_id = var.project_id
  region     = "us-west2"
  zone       = "us-west2-a"

  network    = google_compute_network.main.name
  subnetwork = google_compute_subnetwork.private.name
  client_tag = "private-egress-client"

  private_cidrs = ["10.10.0.0/16"]

  betternat_version = "v0.2.0"

  manage_runtime_service_account = true
  manage_runtime_iam             = true
}
```

The module defaults to:

- Firestore-backed BetterNAT agent HA enabled,
- zonal MIG-backed gateway capacity repair,
- two gateway nodes,
- Debian 12 `e2-small` gateways,
- route priority `800`,
- no provider-created static external egress address.

Set `betternat_version` to a GCP-capable BetterNAT runtime release, or pass
explicit `agent_binary_url`, `agent_binary_sha256`, `cli_binary_url`, and
`cli_binary_sha256` values for pre-release validation. Do not use an older AWS
runtime release for GCP agent HA.

Pass `stable_public_identity_address_name` to use an existing regional static
external IPv4 address for stable egress identity handover. The module does not
create or delete that address.

## Route Ownership

BetterNAT owns the tagged private default route named by `route_name`. The route
applies to VMs with `client_tag`; do not manage another GCP route with the same
name while BetterNAT is active.

## Requirements

- A GCP project with Compute Engine and Firestore APIs enabled.
- An existing VPC network and regional subnetwork.
- Private clients tagged with `client_tag`.
- Private Google Access or an equivalent private path to Google APIs for
  gateway subnets when stable public identity is enabled.
- A runtime service account with the permissions exposed by
  `runtime_iam_permissions`, or `manage_runtime_service_account = true` and
  `manage_runtime_iam = true` for disposable validation stacks.

## Validation

```sh
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Before the matching BetterNAT provider `0.2.0` is published, run `init` and
`validate` with a local provider filesystem mirror. CI runs formatting only
until the provider release exists.

GCP support is alpha until the provider, module, examples, and release contract
complete their Registry and disposable-environment validation.
