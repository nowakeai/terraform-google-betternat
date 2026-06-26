# terraform-google-betternat

GCP Terraform module for BetterNAT.

This module is the user-facing GCP alpha install surface. It wraps the
`nowakeai/betternat` provider's `betternat_gcp_gateway` resource for an
existing VPC, private-client network tag, Firestore-backed HA, and optional
stable public identity.

Use this module when private GCP workloads should egress through a BetterNAT
active/standby gateway group selected by a tagged static route. Run it in a
disposable VPC before replacing a real egress path.

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

GCP handover is connectivity-first: BetterNAT moves private workload routes
first, then converges the static public identity. During that transition,
successful new connections may temporarily use the target gateway's ordinary
public IP before the static IP returns.

`capacity_repair_mode` defaults to `mig`, which creates a zonal Managed
Instance Group from a provider-rendered instance template. `unmanaged` remains
available as an alpha escape hatch for narrow debugging or validation.

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

Before applying, confirm:

- the selected `betternat_version` is a GCP-capable BetterNAT runtime release,
- Firestore Native exists or `manage_firestore_database = true` is intentional,
- Terraform may create or use the runtime service account,
- Terraform may create or update the custom runtime IAM role when
  `manage_runtime_iam = true`,
- private client VMs have `client_tag`,
- no other Terraform resource owns the same `route_name`,
- stable public identity address lifecycle is owned outside this module unless
  the address is created in the calling stack.

User docs:

- GCP Quick Start: <https://github.com/nowakeai/betternat/blob/main/docs/user/getting-started/GCP_QUICK_START.md>
- Limitations: <https://github.com/nowakeai/betternat/blob/main/docs/user/reference/LIMITATIONS.md>
- IAM: <https://github.com/nowakeai/betternat/blob/main/docs/user/reference/IAM_POLICY.md>
- Operations: <https://github.com/nowakeai/betternat/blob/main/docs/user/operations/OPERATIONS_GUIDE.md>
- Rollback: <https://github.com/nowakeai/betternat/blob/main/docs/user/operations/ROLLBACK_GUIDE.md>

## Validation

```sh
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

Before the matching BetterNAT provider `0.2.0` is published, run `init` and
`validate` with a local provider filesystem mirror. CI runs formatting only
until the provider release exists.

GCP support remains alpha until the provider, module, examples, and release
contract complete Registry and disposable-environment validation.
