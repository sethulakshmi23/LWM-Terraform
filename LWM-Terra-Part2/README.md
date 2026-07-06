# Day 1 (continued) — HCL Fundamentals, Providers & Meta-Arguments

Lab material for **Day 1** of the Terraform Associate (004) course, in `LWM-Terra-Part2/`.
Maps to exam **Domain 1** (IaC), **Domain 2** (Terraform fundamentals), **Domain 4** (Terraform configuration — meta-arguments).

> Focus: version-pin Terraform and providers, configure multiple providers, and control resource
> lifecycle with `count`, `for_each`, and the `lifecycle` block.

For install steps and the base core-workflow commands (`init`/`fmt`/`validate`/`plan`/`apply`/`destroy`),
see [Part1's README](../LWM-Terra-Part1/README.md) — this document only covers what's specific to Part 2.

---

## 1. What's in this folder

Each subfolder is a single, focused `main.tf` — no `variables.tf`/`provider.tf` split, since the
point of each lab is a single language feature.

| Folder | Resources | Feature taught |
|---|---|---|
| [`1.1 Required Version`](1.1%20Required%20Version) | *(none — terraform block only)* | Pinning Terraform CLI (`required_version`) and provider (`required_providers`) versions |
| [`1.2 multiple provider`](1.2%20multiple%20provider) | 2× `aws_vpc` | A default provider + an **aliased** second provider (`alias = "sing"`), routing one resource to each via `provider = aws.sing` |
| [`1.3 Immutable`](1.3%20Immutable) | 1× `aws_vpc` | Baseline resource for discussing Terraform's immutable-infrastructure model (changing a `ForceNew` attribute like `cidr_block` destroys & recreates rather than mutating in place) |
| [`1.4 Count`](1.4%20Count) | 1× `aws_vpc` (×2 via `count`) | The `count` meta-argument + `count.index` |
| [`1.5 For each Map`](1.5%20For%20each%20Map) | 3× `aws_s3_bucket` | `for_each` over a **map**; `each.key` / `each.value` |
| [`1.6 For each Set`](1.6%20For%20each%20Set) | 4× `aws_iam_user` | `for_each` over a **set** (`toset([...])`); `each.key` |
| [`1.7 Create Before Destroy`](1.7%20Create%20Before%20Destroy) | 1× `aws_vpc` | `lifecycle { create_before_destroy = true }` |
| [`1.8 Prevent Destroy`](1.8%20Prevent%20Destroy) | 1× `aws_vpc` | `lifecycle { prevent_destroy = true }` |
| [`1.9 Ignore Changes`](1.9%20Ignore%20Changes) | 1× `aws_vpc` | `lifecycle { ignore_changes = [tags] }` |
| [`1.10 Depends On`](1.10%20Depends%20On) | 3× `aws_s3_bucket`, 2× `aws_vpc` (`count`), 6× `aws_iam_user` | Explicit `depends_on` chaining a `for_each` S3 lab → a `count` VPC lab → a `for_each` IAM lab |

**Total: 10 labs, ~20 resource instances across `aws_vpc`, `aws_s3_bucket`, and `aws_iam_user`** — all cheap/free-tier-safe resource types.

---

## 2. Syllabus topics covered here

| Day 1 topic | Covered? | Where |
|---|---|---|
| Installing and versioning Terraform and providers | ✅ | `1.1 Required Version` |
| HCL fundamentals: blocks, arguments, expressions | ✅ | Every lab; `${count.index}` / `${each.key}` are the first interpolated expressions students see |
| Multi-cloud, hybrid-cloud, service-agnostic workflows | ⚠️ Partial | `1.2 multiple provider` shows **multi-region** provider aliasing (two AWS regions), which teaches the *provider alias* mechanism but not a second cloud vendor — say so explicitly when teaching "service-agnostic" |
| How Terraform uses providers; the plugin model | ✅ (via `terraform init` output) | `1.1`, `1.2` |
| Resource meta-arguments: `count`, `for_each`, `depends_on`, lifecycle | ✅ | `1.4`–`1.10` |

**Known version inconsistency (trainer note):** these folders pin AWS provider `~> 3.0` or
`~> 4.0` depending on when each lab was authored. Both ranges still resolve and run fine today,
but if you want one consistent teaching version across the day, update every `required_providers`
block to `~> 5.0` to match [Part1](../LWM-Terra-Part1/README.md) and the newer Part 3/4/5 labs. Note that AWS
provider v5 **removes** the inline `acl` argument on `aws_s3_bucket` (used in `1.5` and `1.10`) —
if you upgrade those two folders, drop `acl = "private"` or add a separate `aws_s3_bucket_acl` resource.

---

## 3. Commands to run

Same core workflow as Part 1, run inside whichever subfolder you're teaching:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

### Lab-specific things worth showing live

- **`1.1 Required Version`** — there's no provider/resource block, so `plan`/`apply` do nothing.
  Run `terraform init` and point out the version constraint being satisfied; then temporarily
  edit `required_version` to something impossible (e.g. `"< 1.0.0"`) and re-run `init` to show
  the version-mismatch error.
- **`1.2 multiple provider`** — after `apply`, run `terraform state list` and show that both
  `aws_vpc.my-vpc-1` and `aws_vpc.my-vpc-2` exist, one per AWS region, from one `apply`.
- **`1.3 Immutable`** — apply once, then change `cidr_block` and run `plan` again: point out the
  plan shows `-/+` (destroy and recreate), not `~` (in-place update), because `cidr_block` forces
  replacement.
- **`1.7`/`1.8`/`1.9`** — each needs a second `plan`/`apply` after a manual edit to actually show
  the lifecycle behavior:
  - `1.7`: change `cidr_block`, re-apply, and note the replacement resource is created *before*
    the old one is destroyed (check `terraform apply`'s ordering in the output).
  - `1.8`: try `terraform destroy` and show it's **blocked** by `prevent_destroy`.
  - `1.9`: change a tag by hand in the AWS Console, then run `terraform plan` and show Terraform
    reports no drift for that tag — because it's in the `ignore_changes` list.
- **`1.10 Depends On`** — run `terraform graph` (or just read the `depends_on` arguments) to show
  the explicit ordering: IAM users wait on the VPC, which waits on the S3 buckets, even though
  none of them actually reference each other's attributes.

---

## 4. Suggested in-class flow

1. **`1.1`** — version pinning (5 min)
2. **`1.2`** — multiple/aliased providers (10 min)
3. **`1.3`** — immutable infrastructure concept (10 min)
4. **`1.4`–`1.6`** — `count` vs. `for_each` over a map vs. `for_each` over a set (15 min) — this
   is the natural point to ask "when would you use `count` vs `for_each`?" (answer: `for_each`
   when items need stable identity and can be added/removed from the middle of the collection
   without reshuffling every other resource's index)
5. **`1.7`–`1.9`** — the three `lifecycle` arguments (15 min)
6. **`1.10`** — tie it together with `depends_on` across all three resource types (10 min)

---

## 5. Cleanup checklist

- [ ] `terraform destroy` completed in **every** subfolder you applied (each has its own state)
- [ ] `1.8 Prevent Destroy` needs `prevent_destroy = false` (or remove the block) **before**
      `destroy` will succeed — call this out, it trips students up every time
- [ ] Confirm no leftover VPCs, S3 buckets, or IAM users in the AWS Console

---

## 6. Reference links

- [Meta-arguments: count](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [Meta-arguments: for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
- [The lifecycle Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- [Provider Configuration: alias](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
