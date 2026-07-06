# HCP Terraform Workspaces & Projects

> **Don't confuse this with CLI workspaces.** [Part4 3.3 Workspaces](../../LWN-Terra-Part4/3.3%20Workspaces)
> covers `terraform workspace new/select/list` — multiple state files sharing one backend and
> one configuration, switched locally. This lesson is a *different, related* concept: HCP
> Terraform workspaces are the exam's Domain 8 topic and are a full unit of remote execution.

## HCP Terraform Workspace vs. CLI Workspace

| | CLI workspace (`terraform workspace`) | HCP Terraform workspace |
|---|---|---|
| Scope | One `.tf` config, many state files | One state file, its own variables, run history, permissions |
| Where it lives | Local backend metadata | HCP Terraform organization |
| Typical use | Quick dev/qa/prod state separation for one config | Each app/component/environment as its own governed unit |
| Variables | Shared `.tfvars` files | Per-workspace Terraform variables + environment variables, set in the UI |
| Who can see it | Whoever has the state file | Controlled by HCP Terraform team permissions |

In practice, most real organizations use **one HCP Terraform workspace per environment per
component** (e.g. `networking-dev`, `networking-prod`, `app1-dev`, `app1-prod`) rather than
CLI workspaces layered on top of a single HCP Terraform workspace.

## Projects

A **Project** is a folder-like grouping of workspaces, used to apply consistent team access
and policy sets across related workspaces (e.g. group every workspace for one application, or
every workspace one team owns).

### Walkthrough

1. In the HCP Terraform UI, go to your organization → **Projects** → **New Project**.
2. Name it something like `lwm-training`.
3. Move the `lwm-day5-hcp-demo` workspace (from [5.1](../5.1%20HCP%20Terraform%20Setup)) into
   this project (workspace **Settings → General → Project**).
4. Under the project's **Team Access** tab, grant a team (or yourself) a permission level —
   note the built-in levels: **Read**, **Plan**, **Write**, **Admin**.

## Community vs. Enterprise/HCP edition — what's actually free

| Feature | Terraform CLI (Community, free) | HCP Terraform Free tier | HCP Terraform Plus/Enterprise |
|---|---|---|---|
| Local `plan`/`apply` | ✅ | — | — |
| Remote state + locking | Self-managed (e.g. S3+DynamoDB) | ✅ Managed | ✅ Managed |
| Remote/VCS-driven runs | ❌ | ✅ | ✅ |
| Projects & team permissions | ❌ | ✅ (limited) | ✅ (full RBAC/SSO) |
| Sentinel / OPA policy as code | ❌ | ❌ | ✅ |
| Cost estimation | ❌ | ❌ | ✅ |
| Private Registry | ❌ | ✅ (limited) | ✅ |
| Audit logging | ❌ | ❌ | ✅ |

This distinction — knowing what's Community vs. what requires HCP Terraform's paid tiers — is
explicitly named in Domain 8 of the exam blueprint.
