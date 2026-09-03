# Authentication: the GitHub provider reads the GITHUB_TOKEN environment
# variable automatically - no token is ever written into this configuration
# or into any .tf file. For local bootstrap/testing, export a Personal
# Access Token with the scopes listed in github/README.md before running
# `terraform init` / `plan` / `import`:
#
#   $env:GITHUB_TOKEN = "<your PAT>"    # PowerShell, current session only
#
# For a production/enterprise setup, a GitHub App is preferable to a personal
# PAT: an App's installation token is short-lived, scoped to only the
# repositories/permissions the App was installed with, and isn't tied to any
# one person's account (so it doesn't break if that person leaves or
# revokes their token). The provider supports this via an `app_auth` block
# (app_id / installation_id / pem_file) as an alternative to GITHUB_TOKEN -
# not configured here, since no GitHub App has been set up for this homework
# yet. This is intentionally left as a future improvement, not a gap.
provider "github" {
  owner = var.github_organization
}
