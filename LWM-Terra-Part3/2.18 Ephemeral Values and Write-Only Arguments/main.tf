# EPHEMERAL RESOURCE (Terraform 1.10+)
# Computed only for the duration of this run; its result is never written to the
# state file or the saved plan file, unlike a normal `resource`.
ephemeral "random_password" "demo" {
  length  = 16
  special = true
}

# EPHEMERAL OUTPUT
# Marking an output `ephemeral = true` tells Terraform to refuse to persist it.
# It can only be read from the immediate `terraform apply`/`-json` output, e.g. by a
# script that pipes the value straight into a secrets manager and never saves it to disk.
output "generated_password" {
  value     = ephemeral.random_password.demo.result
  ephemeral = true
}

# A normal (non-ephemeral) resource for contrast — creating this IAM user is unaffected;
# in a real pipeline this is the kind of resource you'd pair an ephemeral secret with.
resource "aws_iam_user" "demo" {
  name = "svc-ephemeral-demo"
}
