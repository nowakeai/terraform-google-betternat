# Non-Stable Egress IP Example

This is a runnable example for the GCP BetterNAT module. It is not a reusable
Terraform submodule.

The example leaves `stable_public_identity_address_name` unset. Use it when
preserving private workload connectivity is more important than keeping one
public egress IP.

Set the required variables, then run:

```sh
terraform init
terraform plan
terraform apply
```

Run `terraform destroy` when the validation stack is no longer needed.
