# github/ - GitHub Platform Configuration as Code

A third, independent Terraform stage in this repository (alongside the
root and `kubernetes/` stages), managing the `arek-devops-platform` GitHub
organization's repositories, teams, permissions, Environments, and branch
Ruleset - instead of configuring them by hand in the GitHub UI.

**This stage is entirely separate from the other two.** It has its own
provider (`integrations/github`, not `azurerm`), its own backend state key
(`github.tfstate`), and manages no Azure resources at all. Nothing here
touches the root or `kubernetes/` stage's state, resources, or credentials.

## Status: not yet imported or applied

Every resource in this directory corresponds to a GitHub object that
**already exists**. Nothing has been imported, planned against real state,
or applied. `terraform init`/`validate` have been run to confirm the
configuration is syntactically correct; `terraform import` and
`terraform apply` have not been run - see `import-existing.ps1` for the
exact (not-yet-executed) import commands.

## Authentication

The `github` provider reads the `GITHUB_TOKEN` environment variable
automatically - no token is ever written into any `.tf` file or committed
to version control.

For local bootstrap/testing:

```powershell
$env:GITHUB_TOKEN = "<your Personal Access Token>"
```

### Token scopes needed

The scopes needed depend on what you're doing:

| Action | Required PAT scopes |
|---|---|
| Read-only inspection (`gh api GET ...`, done to write this module) | `read:org`, `repo` |
| `terraform import` / `terraform plan` (read existing resources into state) | `repo`, `admin:org` |
| `terraform apply` (create/modify real resources, not done in this step) | `repo`, `admin:org` |

`admin:org` (not just `read:org`) is required for managing teams and
team-repository permissions through this provider - `read:org` alone is
sufficient to inspect them but not to import or manage them as Terraform
resources.

### GitHub App vs. Personal Access Token

A PAT is used here because this is a one-person lab. For a production or
multi-person enterprise setup, a **GitHub App** is preferable: its
installation token is short-lived, scoped to exactly the repositories and
permissions the App was installed with, and isn't tied to any individual's
account (so it doesn't break if that person leaves or revokes their token).
The provider supports this via an `app_auth` block instead of `GITHUB_TOKEN`
- not configured here, since no GitHub App exists for this project yet.

## Remote state

Same Azure Storage Account as the root and `kubernetes/` stages, with its
own blob key so the three never collide:

```powershell
terraform init `
  -backend-config="resource_group_name=<state-resource-group>" `
  -backend-config="storage_account_name=<state-storage-account>" `
  -backend-config="container_name=tfstate" `
  -backend-config="key=github.tfstate"
```

## What this manages

- **Repositories** (`repositories.tf`) - `app-demo`, `platform-workflows`,
  `terraform-infra`, adopted (not created).
- **Teams** (`teams.tf`) - `developers`, `platform`.
- **Team repository permissions** (`team-repositories.tf`) - `developers` ->
  `app-demo` (Write), `platform` -> all three repos (Maintain).
- **GitHub Environments** (`environments.tf`) - `app-demo`'s `dev` (no
  protection) and `prod` (required reviewer + `main`-only), and
  `terraform-infra`'s `infra-prod` (required reviewer + `main`-only).
- **Branch Ruleset** (`rulesets.tf`) - `app-demo`'s "Protect main": pull
  request required, 1 approval, stale reviews dismissed on push, Code Owner
  review required, conversation resolution required, up-to-date branch
  required, force pushes blocked, deletions restricted, six required status
  checks, and the existing pull-request-only bypass for the repo owner.

## What this deliberately does NOT manage yet

**CODEOWNERS.** `app-demo/.github/CODEOWNERS` already exists and is managed
by hand as a regular file in that repository. It is intentionally **not**
brought under Terraform here, because doing so with
`github_repository_file` would require Terraform to own the file's full
content from that point on - if this module's copy of the content ever
drifted from what's actually committed (e.g. someone edits it directly), the
next `apply` would silently overwrite their change. Since we haven't
inventoried the exact current byte-for-byte content as part of this
read-only step, managing it now would risk exactly that.

If you do want it Terraform-managed later, the pattern is:

```hcl
resource "github_repository_file" "app_demo_codeowners" {
  repository          = github_repository.app_demo.name
  branch              = "main"
  file                = ".github/CODEOWNERS"
  content             = "* @arek-devops-platform/platform\n"
  commit_message      = "Manage CODEOWNERS via Terraform"
  overwrite_on_create = true
}
```

first importing the existing file with
`terraform import github_repository_file.app_demo_codeowners app-demo:.github/CODEOWNERS:main`
so the *first* apply is a no-op rather than an overwrite.

## Settings that could not be verified through read-only inspection

Flagged with `TODO` comments in the relevant files rather than guessed:

- **`repositories.tf`** - only `name` and `visibility` were confirmed
  against the live repositories. Description, topics, `has_issues`,
  `has_wiki`, `has_downloads`, `delete_branch_on_merge`, and merge-commit
  options were not compared field-by-field and are left unmanaged.
- **`rulesets.tf`** - two API-level fields
  (`dismissal_restriction.enabled` and
  `require_extra_approval_for_unattributed_changes`) have no corresponding
  argument in the provider's schema. Both were observed as `false`
  (their default/off value) on the real ruleset, so nothing is currently
  lost - but if either is ever turned on through the GitHub UI, this
  Terraform resource will not be able to represent that change.

## Next steps (not part of this step)

1. Review every file in this directory, especially the `TODO` comments
   above.
2. Export `GITHUB_TOKEN` with the scopes listed above.
3. Run `terraform init` with the `github.tfstate` backend config shown above.
4. Run the commands in `import-existing.ps1` one at a time, checking
   `terraform state show <address>` after each.
5. Run `terraform plan` and resolve every proposed change before ever
   considering `terraform apply`.
