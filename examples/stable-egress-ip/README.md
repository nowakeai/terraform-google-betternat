# Stable Egress IP Example

This is a runnable example for the GCP BetterNAT module. It is not a reusable
Terraform submodule.

The example creates a regional static external IPv4 address in the calling stack
and passes its name to BetterNAT for stable public identity handover.

Set the required variables, confirm the selected region and zone, then run:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
