# Terraform Associate (004) — Practice Questions

24 multiple-choice questions, 3 per objective domain, mirroring the exam's format. Run this as
a **timed mock exam: 25 minutes, no notes**, then review with the answer key at the bottom.

---

### Domain 1 — Infrastructure as Code (IaC)

**1.** Which of the following best describes a benefit of Infrastructure as Code (IaC) compared to manual provisioning?
A. It eliminates the need for version control
B. It allows infrastructure changes to be reviewed, versioned, and repeated consistently
C. It requires cloud-specific scripting for every provider
D. It removes the need for testing infrastructure changes

**2.** Terraform is best described as which type of IaC tool?
A. Mutable, procedural
B. Declarative, immutable-infrastructure-oriented
C. Imperative, mutable
D. GUI-only, no code

**3.** Which statement about Terraform's cloud-agnostic design is correct?
A. Terraform only works with AWS
B. Terraform uses the same configuration language across many providers, though provider-specific resources differ
C. Terraform requires a different CLI binary per cloud provider
D. Terraform cannot manage on-premises infrastructure

### Domain 2 — Terraform Fundamentals

**4.** What is the correct order of block types when starting a new configuration that uses the AWS provider?
A. provider block only
B. terraform block (required_providers) then provider block
C. resource block then terraform block
D. module block only

**5.** Which command downloads the provider plugins declared in `required_providers`?
A. terraform validate
B. terraform init
C. terraform fmt
D. terraform get

**6.** Which file does Terraform create to lock provider versions after `terraform init`?
A. terraform.tfvars
B. .terraform.lock.hcl
C. provider.lock
D. terraform.tfstate

### Domain 3 — Core Terraform Workflow

**7.** What is the correct sequence of the Terraform core workflow?
A. apply → plan → init → destroy
B. init → plan → apply → destroy
C. plan → init → destroy → apply
D. init → apply → plan → destroy

**8.** Which command shows a preview of changes without modifying real infrastructure?
A. terraform apply
B. terraform plan
C. terraform refresh
D. terraform validate

**9.** Which command rewrites configuration files into canonical style without changing their behavior?
A. terraform validate
B. terraform fmt
C. terraform init
D. terraform graph

### Domain 4 — Terraform Configuration

**10.** Which meta-argument forces a new resource to be created before the old one is destroyed?
A. prevent_destroy
B. create_before_destroy
C. depends_on
D. ignore_changes

**11.** Which type constraint would you use for a variable that must hold a fixed-length sequence with a different type allowed per position?
A. list(string)
B. set(string)
C. tuple([...])
D. map(string)

**12.** What block do you add inside a variable definition to enforce custom input constraints?
A. lifecycle
B. validation
C. precondition
D. depends_on

### Domain 5 — Terraform Modules

**13.** Which of these is a valid way to source a module directly from the public Terraform Registry?
A. source = "./modules/vpc"
B. source = "terraform-aws-modules/vpc/aws"
C. source = "git::https://example.com/vpc.git"
D. Registry modules cannot be referenced by a source argument

**14.** What is the purpose of the `version` argument in a module block?
A. Pins the Terraform CLI version
B. Constrains which versions of that module may be used
C. Sets the AWS provider version
D. Has no effect for registry modules

**15.** In a root module calling a child module, where are the child module's input variables scoped?
A. Globally across the entire configuration
B. Only within that child module, unless explicitly passed as arguments in the module block
C. Automatically inherited from the root module's variables.tf
D. Shared with sibling modules automatically

### Domain 6 — Terraform State Management

**16.** What is the primary purpose of Terraform state?
A. To store provider plugin binaries
B. To map real-world resources to your configuration and track metadata/dependencies
C. To store the Terraform CLI version only
D. To hold provisioner scripts

**17.** Which backend configuration combination provides both remote state storage and state locking on AWS?
A. S3 bucket alone
B. S3 bucket + DynamoDB table
C. Local backend + DynamoDB
D. EC2 instance store

**18.** Which command displays the resources currently tracked in the state file?
A. terraform show
B. terraform taint
C. terraform fmt
D. terraform output

### Domain 7 — Maintain Infrastructure with Terraform

**19.** Which command (or block, in modern Terraform) brings an existing, unmanaged cloud resource under Terraform management?
A. terraform apply
B. terraform import
C. terraform refresh
D. terraform validate

**20.** "Drift" refers to:
A. Differences between two Terraform versions
B. A difference between the real infrastructure and what's recorded in Terraform state
C. The time delay of a remote apply
D. A type of variable

**21.** Which environment variable increases Terraform's logging verbosity for troubleshooting?
A. TF_DEBUG
B. TF_LOG
C. TF_VERBOSE
D. TF_TRACE

### Domain 8 — HCP Terraform

**22.** In HCP Terraform, what is a Workspace?
A. A local .tfvars file
B. An isolated unit of state, variables, and run history for a given configuration
C. A CLI-only feature unrelated to HCP Terraform
D. A billing plan tier

**23.** Which HCP Terraform feature requires a Team & Governance (or higher) plan?
A. Remote state storage
B. Sentinel/OPA policy as code
C. terraform plan
D. Workspace creation

**24.** In a VCS-driven HCP Terraform workspace, what happens when a pull request is opened against the connected repo?
A. Terraform automatically applies the change
B. A speculative plan runs and is posted as a check/comment; nothing is applied
C. Nothing happens until manually triggered from the CLI
D. The workspace is deleted

---

## Answer Key

| # | Answer | | # | Answer | | # | Answer |
|---|---|---|---|---|---|---|---|
| 1 | B | | 9 | B | | 17 | B |
| 2 | B | | 10 | B | | 18 | A |
| 3 | B | | 11 | C | | 19 | B |
| 4 | B | | 12 | B | | 20 | B |
| 5 | B | | 13 | B | | 21 | B |
| 6 | B | | 14 | B | | 22 | B |
| 7 | B | | 15 | B | | 23 | B |
| 8 | B | | 16 | B | | 24 | B |

---

## Exam Day Logistics (recap)

| | |
|---|---|
| Assessment type | Multiple choice |
| Delivery format | Online proctored |
| Duration | 1 hour |
| Language | English |
| Price | US $70.50 + applicable taxes (retake not included) |
| Credential validity | 2 years |
| Tested on | Terraform 1.12 |

Register at [developer.hashicorp.com/certifications/infrastructure-automation](https://developer.hashicorp.com/certifications/infrastructure-automation).
