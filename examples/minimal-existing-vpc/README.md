# Minimal Existing VPC Example

This is a runnable example for the GCP BetterNAT module. It is not a reusable
Terraform submodule.

Use this example when you already have:

- one VPC network,
- one regional subnetwork for gateway NICs,
- private clients with a common network tag,
- private CIDR ranges that should use BetterNAT SNAT.

Set the required variables, then run:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
