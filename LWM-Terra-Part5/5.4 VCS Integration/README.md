# HCP Terraform Integrations: VCS-Driven Runs

Instead of running `terraform plan`/`apply` from your own machine, a workspace can be
connected directly to a Git repository so HCP Terraform drives the workflow itself.

## How it works

1. Connect a VCS provider (GitHub, GitLab, Bitbucket, or Azure DevOps) to your HCP Terraform
   organization: **Organization Settings → VCS Providers → Add a VCS Provider**, then
   authorize via OAuth (or a GitHub App).
2. Create (or edit) a workspace and choose **Version control workflow**, pointing it at a repo
   and a working directory (useful if your Terraform lives in a subfolder of a larger repo).
3. From then on:
   - **Push a commit to a non-default branch / open a pull request** → HCP Terraform runs a
     **speculative plan** and posts the result as a status check / PR comment. Nothing is
     applied — it's purely informational, so reviewers can see the infrastructure impact of a
     PR before approving it.
   - **Merge to the branch configured as the workspace's source** (commonly `main`) → HCP
     Terraform queues a real run: `plan` → (manual confirm, unless auto-apply is enabled) → `apply`.

## Why this matters for governance

- No one needs local AWS credentials or Terraform installed to propose an infrastructure
  change — they just open a PR.
- Every apply is tied to a specific commit SHA, giving you a natural audit trail.
- Combine with [Sentinel/OPA policy checks](../5.3%20Governance%20Policy%20and%20Cost) so a PR
  that violates policy is blocked automatically, before a human ever clicks "Apply".

## Walkthrough (using this repository as the example)

1. Push this repo to GitHub (if it isn't already).
2. In HCP Terraform: **Workspaces → New → Version control workflow** → select the repo.
3. Set **Terraform Working Directory** to `LWM-Terra-Part5/5.1 HCP Terraform Setup`.
4. Open a pull request that changes a tag in that folder's `main.tf` — watch HCP Terraform post
   a speculative plan as a PR check.
5. Merge the PR and watch the real run trigger automatically in the workspace's **Runs** tab.

## Reference

- [HCP Terraform VCS docs](https://developer.hashicorp.com/terraform/cloud-docs/vcs)
