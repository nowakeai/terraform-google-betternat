# GKE Private Nodes Example

This is a runnable example for the GCP BetterNAT module. It is not a reusable
Terraform submodule.

Use this example as a shape reference for private GKE node pools that should
egress through BetterNAT. Pass the VPC network, node subnetwork, node network
tag, and cluster private CIDR ranges from your GKE stack.

Set the required variables, then run:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
