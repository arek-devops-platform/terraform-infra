# Terraform import commands to adopt EXISTING GitHub resources into this
# stage's state. This script is NOT executed as part of any automated step -
# review every line yourself before running any of it.
#
# `terraform import` only reads from the GitHub API and writes to local
# Terraform state; it does not modify anything on GitHub. Nothing here is
# destructive. Still, run these one at a time and inspect the result
# (`terraform state show <address>`) rather than pasting the whole file
# blindly, especially the first time.
#
# Prerequisites:
#   - cd into this github/ directory
#   - $env:GITHUB_TOKEN set to a PAT with the scopes listed in README.md
#   - terraform init already run successfully against the github.tfstate
#     backend key

# --- Repositories ---------------------------------------------------------
terraform import github_repository.app_demo app-demo
terraform import github_repository.platform_workflows platform-workflows
terraform import github_repository.terraform_infra terraform-infra

# --- Teams ------------------------------------------------------------
terraform import github_team.developers developers
terraform import github_team.platform platform

# --- Team -> repository permissions --------------------------------------
terraform import github_team_repository.developers_app_demo developers:app-demo
terraform import github_team_repository.platform_app_demo platform:app-demo
terraform import github_team_repository.platform_platform_workflows platform:platform-workflows
terraform import github_team_repository.platform_terraform_infra platform:terraform-infra

# --- GitHub Environments -----------------------------------------------
terraform import github_repository_environment.app_demo_dev app-demo:dev
terraform import github_repository_environment.app_demo_prod app-demo:prod
terraform import github_repository_environment_deployment_policy.app_demo_prod_main app-demo:prod:58709259

terraform import github_repository_environment.terraform_infra_infra_prod terraform-infra:infra-prod
terraform import github_repository_environment_deployment_policy.terraform_infra_infra_prod_main terraform-infra:infra-prod:58740422

# --- Repository Ruleset ----------------------------------------------
terraform import github_repository_ruleset.app_demo_protect_main app-demo:21947935

# After every import above succeeds, run `terraform plan` (still no
# apply) and read it carefully. Anything it proposes to change is either
# a genuine drift between this configuration and the real resource, or a
# setting one of the TODO comments in this module flagged as unverified -
# resolve every proposed change deliberately before ever running apply.
