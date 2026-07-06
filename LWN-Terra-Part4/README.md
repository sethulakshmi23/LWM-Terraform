# Day 3 — State Management & Maintaining Infrastructure
### (plus Day 2 functions, and provisioners)

Lab material for **Day 3** of the Terraform Associate (004) course, in `LWN-Terra-Part4/`.
Maps to exam **Domain 6** (Terraform state management) and **Domain 7** (Maintain infrastructure).

> Note: this folder is named `LWN-Terra-Part4` (missing the "M" that `LWM-Terra-Part1/2/3` have) —
> almost certainly a typo from when it was created. Left as-is here to avoid breaking any
> existing links/scripts; rename it to `LWM-Terra-Part4` if you want consistency across the repo.

For install steps and core-workflow commands, see [Part1's README](../LWM-Terra-Part1/README.md).

---

## 1. What's in this folder

| Folder | Files | Feature taught | Day / Domain |
|---|---|---|---|
| [`3.1 State`](3.1%20State) | `main.tf`, `provider.tf` | Remote state: **S3 backend + DynamoDB locking** | Day 3 / Domain 6 |
| [`3.2 State Commands`](3.2%20State%20Commands) | `main.tf`, `README.md` | `state list`, `state show`, `show`, `refresh`, `taint`/`untaint`, `force-unlock`, `apply -target`, `import` (named only — see `3.5`) | Day 3 / Domain 6-7 |
| [`3.3 Workspaces`](3.3%20Workspaces) | `main.tf`, `provider.tf`, `README.md` | CLI `terraform workspace` commands; `terraform.workspace` expression | Day 3 / Domain 6 |
| [`3.4 functions`](3.4%20functions) | 7 `.tf` files + `hello.txt` | Built-in functions: collection, date/time, encoding, filesystem, number, string, type conversion | Day 2 / Domain 4 |
| [`3.5 Import Existing Resources`](3.5%20Import%20Existing%20Resources) *(new)* | `main.tf`, `variables.tf`, `provider.tf`, `README.md` | A full worked `terraform import` + modern `import {}` block example | Day 3 / Domain 7 |
| [`3.6 Drift Detection`](3.6%20Drift%20Detection) *(new)* | `main.tf`, `variables.tf`, `provider.tf`, `README.md` | Manually causing drift, detecting it with `plan`, reconciling with `apply`/`apply -refresh-only` | Day 3 / Domain 7 |
| [`4.1 File Provisioner`](4.1%20File%20Provisioner) | `terraform-manifests/*`, `README.md` | `file` provisioner, connection blocks, `self`, `on_failure` | Day 2/3 / Domain 4 |
| [`4.2 Remote Provisioner`](4.2%20Remote%20Provisioner) | `terraform-manifests/*`, `README.md` | `remote-exec` provisioner (`inline` commands) | Day 2/3 / Domain 4 |
| [`4.3 Local Provisioner`](4.3%20Local%20Provisioner) | `terraform-manifests/*`, `README.md` | `local-exec` provisioner, creation-time vs. destroy-time (`when = destroy`) | Day 2/3 / Domain 4 |
| [`4.4 Provider`](4.4%20Provider) | `terraform-manifests/*`, `README.md` | `null_resource` + `time_sleep` — "provisioner without a resource," triggers via `timestamp()` | Day 2/3 / Domain 4 |

**Total: 10 labs.** The `4.x` labs use `aws_instance` (EC2) because provisioners need a real
compute target to connect to over SSH — this folder is the one place in the course where EC2 is
necessary rather than optional.

---

## 2. Known issue fixed

`3.4 functions/filesystemfunctions.tf` calls `file("${path.module}/hello.txt")` and
`filebase64("${path.module}/hello.txt")`, but `hello.txt` didn't actually exist in the folder —
`terraform plan` would fail with "no such file or directory." **Fixed**: added
`3.4 functions/hello.txt` containing `Hello World`, matching the comment in the `.tf` file.

---

## 3. Commands to run

### 3.1–3.3 (state & workspaces) — standard workflow

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

Extras:
- **`3.1 State`**: after `apply`, go look at the S3 bucket named in `provider.tf`'s `backend "s3"`
  block — the state file lives there, not locally. Also inspect the DynamoDB table during an
  `apply` to see the lock item appear and disappear.
- **`3.2 State Commands`**: run each command from its README against the resources this lab
  creates — `terraform state list`, `terraform state show aws_vpc.vpc1`, `terraform taint
  aws_vpc.vpc1` then `terraform plan` (shows a forced replacement), `terraform untaint aws_vpc.vpc1`.
- **`3.3 Workspaces`**: `terraform workspace new dev`, `terraform workspace new qa`,
  `terraform workspace list`, `terraform workspace select dev`, then `apply` in each and compare
  `terraform.workspace`-derived resource names/counts.

### 3.4 functions — no AWS account needed

```bash
terraform init
terraform apply -auto-approve
terraform output          # see every function's result at once
```

This is the only lab in the entire course with **zero cloud dependency** — no `provider` block,
no billable resources. Safe to run anywhere, including for students without AWS access yet.

### 3.5 / 3.6 (new) — see each folder's own README

Both need a bucket name changed to something globally unique before running; full step-by-step
walkthroughs live in their own `README.md` files.

### 4.1–4.4 (provisioners) — need an EC2 key pair first

Every `4.x` lab's README starts with the same prerequisite: create an EC2 key pair named
`terraform-key` in the AWS Console (EC2 → Key Pairs), download the `.pem`, and place it at
`terraform-manifests/private-key/terraform-key.pem` inside that lab's folder. Then:

```bash
terraform init
terraform validate
terraform fmt
terraform apply -auto-approve
chmod 400 private-key/terraform-key.pem
ssh -i private-key/terraform-key.pem ec2-user@<PUBLIC-IP>
terraform destroy -auto-approve
```

Each lab's own README has the exact verification steps (what to `ls`/`cat` on the instance,
what URL to hit in a browser).

---

## 4. Syllabus topics covered here

| Day 3 topic | Covered? | Where |
|---|---|---|
| How Terraform uses/manages state | ✅ | `3.1`, `3.2` |
| Remote state: S3 backend + DynamoDB locking | ✅ | `3.1` |
| Local backend & state locking | ✅ (by contrast, before `3.1` introduces remote) | — |
| Inspecting state via CLI | ✅ | `3.2` |
| Drift detection/reconciliation | ✅ *(new — full worked example, not just a command list)* | `3.6` |
| Importing existing infrastructure (`terraform import`) | ✅ *(new — full worked example, both classic command and modern `import` block)* | `3.5` |
| Verbose logging (`TF_LOG`) | ✅ *(new)* | `3.6` README, bonus section |

| Domain 4 topic (taught here rather than in Part2/3) | Covered? | Where |
|---|---|---|
| Expressions & functions | ✅ | `3.4` |
| Provisioners (`file`, `remote-exec`, `local-exec`), connection blocks, `self` | ✅ | `4.1`–`4.4` |

---

## 5. Suggested in-class flow

1. **`3.1`** — remote state, S3 + DynamoDB (15 min)
2. **`3.2`** — state inspection commands, live (15 min)
3. **`3.5`** *(new)* — import a hand-created bucket, both ways (15 min)
4. **`3.6`** *(new)* — cause and detect drift live; this is usually the "aha" moment for the day (15 min)
5. **`3.3`** — CLI workspaces, and explicitly contrast with HCP Terraform workspaces (covered Day 5) (15 min)
6. **`3.4`** — functions, run through `terraform output` once, don't belabor each one (10 min)
7. **`4.1`–`4.4`** — provisioners, time permitting; call out HashiCorp's own guidance that
   provisioners are a "last resort" compared to `user_data`/configuration management tools (20 min)

---

## 6. Cleanup checklist

- [ ] `terraform destroy` in every subfolder applied
- [ ] `3.1`/`3.3`: after destroying resources, the S3 state bucket and DynamoDB table
      themselves are **not** managed by these configs — delete them manually if you don't need
      them for the next cohort
- [ ] `4.1`–`4.4`: confirm the EC2 instances are terminated (check the AWS Console, not just
      Terraform's exit code) — these are the only non-trivial-cost resources in Parts 2–4
- [ ] Delete the EC2 key pair (`terraform-key`) if you won't reuse it

---

## 7. Reference links

- [Backend Type: s3](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- [State: the `terraform state` commands](https://developer.hashicorp.com/terraform/cli/state)
- [Refresh-only mode](https://developer.hashicorp.com/terraform/tutorials/state/resource-drift)
- [Import](https://developer.hashicorp.com/terraform/language/import)
- [Built-in Functions](https://developer.hashicorp.com/terraform/language/functions)
- [Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
- [Debugging / TF_LOG](https://developer.hashicorp.com/terraform/internals/debugging)
