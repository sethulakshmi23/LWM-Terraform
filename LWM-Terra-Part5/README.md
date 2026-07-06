# Day 5 — HCP Terraform, Governance & Exam Readiness

Lab material for **Day 5** of the Terraform Associate (004) course.
Maps to exam **Domain 8** (HCP Terraform) and serves as the **full review** day.

> Focus: adopt collaborative, governed workflows with HCP Terraform, then consolidate for the exam.

This folder is newly authored to close the gap identified in
[`syllabus/Gap-Analysis-vs-Existing-Labs.md`](../syllabus/Gap-Analysis-vs-Existing-Labs.md) —
Parts 1–4 build strong CLI/local and self-managed-S3-backend Terraform skills, but none of them
touch HCP Terraform, which is its own exam domain (Domain 8).

---

## 1. What's in this folder

| Subfolder | Contents | Domain 8 topic |
|---|---|---|
| [`5.1 HCP Terraform Setup`](5.1%20HCP%20Terraform%20Setup) | `main.tf` (`cloud` block + S3 bucket), README walkthrough | Using HCP Terraform to create infrastructure |
| [`5.2 Workspaces and Projects`](5.2%20Workspaces%20and%20Projects) | README (conceptual + UI walkthrough) | Organizing workspaces/projects; Community vs. Enterprise/HCP |
| [`5.3 Governance Policy and Cost`](5.3%20Governance%20Policy%20and%20Cost) | `example-policy.sentinel`, README | Collaboration/governance: policy as code, cost estimation |
| [`5.4 VCS Integration`](5.4%20VCS%20Integration) | README (UI walkthrough) | Configuring HCP Terraform integrations (VCS-driven runs) |
| [`5.5 Exam Readiness`](5.5%20Exam%20Readiness) | `practice-questions.md` (24 Qs, all 8 domains + answer key) | Full review + timed mock exam |

### Example count

- **1** runnable Terraform config (`5.1`) — a `cloud` block + 1 `aws_s3_bucket` resource
- **1** illustrative Sentinel policy (`5.3`)
- **4** README-driven UI/conceptual walkthroughs (`5.1`–`5.4`)
- **24** practice questions with answer key (`5.5`)

---

## 2. Why this day looks different from Days 1–4

HCP Terraform is a **hosted SaaS control plane**, not a language feature — you can't teach it
with `main.tf` alone the way `count` or `for_each` are taught. Most of this folder is
**guided walkthroughs against the free HCP Terraform tier**, with one small, cheap, runnable
Terraform config (an S3 bucket) as the hands-on anchor. Governance features (Sentinel/OPA,
cost estimation) require a paid **Team & Governance** tier or higher — those sections are
written to be taught conceptually (reading the example policy, discussing enforcement levels)
even without a paid org to demo against live.

---

## 3. Prerequisites & Installation

Everything from [Part1's README](../LWM-Terra-Part1/README.md#3-prerequisites--installation) still applies
(Terraform CLI, AWS CLI configured, VS Code). Additionally for Day 5:

### 3.1 Create a free HCP Terraform account

1. Go to https://app.terraform.io and sign up (free tier, no credit card).
2. Create an Organization.

### 3.2 Authenticate the CLI

```bash
terraform login
```

Full setup detail is in [`5.1 HCP Terraform Setup/README.md`](5.1%20HCP%20Terraform%20Setup/README.md).

---

## 4. Commands to run (5.1 lab)

| Step | Command | What it does |
|---|---|---|
| 1 | `terraform login` | Authenticates the CLI against HCP Terraform |
| 2 | `terraform init` | Creates/connects the HCP Terraform workspace named in the `cloud` block |
| 3 | `terraform plan` | Queues a **remote** plan, streamed to your terminal |
| 4 | `terraform apply` | Requires approval (UI or CLI); the S3 bucket is created |
| 5 | `terraform destroy` | Tears down the bucket; also remote |

Note there is **no local `terraform.tfstate` file** — state lives entirely in HCP Terraform.

---

## 5. Suggested in-class flow

1. **Talk (10 min):** Why teams outgrow local/S3-backend Terraform — collaboration, audit trail, governance. Show the Community vs. HCP Terraform feature table in [5.2](5.2%20Workspaces%20and%20Projects/README.md).
2. **Live demo (15 min):** Run through [5.1](5.1%20HCP%20Terraform%20Setup) end-to-end — sign up, `terraform login`, `init`/`plan`/`apply`, inspect the run in the UI.
3. **Walkthrough (10 min):** [5.2](5.2%20Workspaces%20and%20Projects) — create a Project, move the workspace into it, discuss workspace vs. CLI-workspace distinction.
4. **Concept talk (10 min):** [5.3](5.3%20Governance%20Policy%20and%20Cost) — read `example-policy.sentinel` together, explain enforcement levels and cost estimation.
5. **Walkthrough (10 min):** [5.4](5.4%20VCS%20Integration) — connect a GitHub repo, open a PR, show the speculative plan comment.
6. **Full review + mock exam (remaining time):** [5.5](5.5%20Exam%20Readiness/practice-questions.md) — 25-minute timed run, then review answers together, mapping each question back to its objective domain.

---

## 6. Cleanup checklist

- [ ] `terraform destroy` run against the `5.1` workspace
- [ ] Remove `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` workspace variables if the HCP Terraform org won't be reused
- [ ] Confirm no S3 buckets from this lab remain in the AWS console

---

## 7. Reference links

- [HCP Terraform docs](https://developer.hashicorp.com/terraform/cloud-docs)
- [Sentinel language docs](https://developer.hashicorp.com/sentinel/docs/language)
- [HashiCorp Certified: Terraform Associate (004) exam objectives](https://developer.hashicorp.com/certifications/infrastructure-automation)
