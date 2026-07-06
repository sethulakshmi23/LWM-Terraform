# Governance: Policy as Code & Cost Estimation

Both features require an HCP Terraform **Team & Governance** plan or higher — the free tier
used in [5.1](../5.1%20HCP%20Terraform%20Setup)/[5.2](../5.2%20Workspaces%20and%20Projects) can't
run them live. Teach this section conceptually, using `example-policy.sentinel` to read through
the logic, plus screenshots/the public docs if you don't have a paid org to demo against.

## Policy as Code (Sentinel / OPA)

HCP Terraform can run a policy check between `plan` and `apply` and **block the apply** if the
plan violates a rule — this is how organizations enforce guardrails (tagging standards,
allowed instance types, no public S3 buckets, mandatory encryption, etc.) without relying on
every engineer remembering the rule.

- **Sentinel** — HashiCorp's own policy language (see `example-policy.sentinel` in this folder).
- **OPA (Open Policy Agent)** — an open-source alternative HCP Terraform also supports.

### Reading `example-policy.sentinel`

1. `import "tfplan/v2"` — gives the policy access to the proposed plan (not just the config).
2. `s3_buckets` — filters the plan down to only `aws_s3_bucket` resources being created or updated.
3. `require_managed_by_tag` — a rule that's true only if *every* matching bucket has a `ManagedBy` tag.
4. `main` — the rule HCP Terraform actually evaluates; if it's `false`, the run is blocked
   (in **hard-mandatory** enforcement) or merely flagged (in **advisory**/**soft-mandatory** enforcement).

### Enforcement levels (exam-relevant)

| Level | Behavior |
|---|---|
| `advisory` | Logs the result, never blocks the run |
| `soft-mandatory` | Blocks the run, but an authorized user can override |
| `hard-mandatory` | Blocks the run, no override |

## Cost Estimation

On supported providers (including AWS), HCP Terraform annotates a plan with the estimated
monthly cost delta of the changes — e.g. "+ $14.60/mo" — surfaced right next to the plan output
before anyone clicks Apply. It's read-only information, not a policy gate by itself, though
it's commonly combined with a Sentinel/OPA policy that blocks plans over a cost threshold.

## Quick recap: Community vs. Enterprise/HCP features

See the comparison table in [5.2](../5.2%20Workspaces%20and%20Projects) — Sentinel/OPA and cost
estimation are two of the clearest lines the exam draws between the free CLI/Community
experience and paid HCP Terraform tiers.
