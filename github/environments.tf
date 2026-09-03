# Looks up the existing required-reviewer user by username, rather than
# hardcoding their numeric GitHub user ID - self-documenting, and correct
# regardless of which numeric ID GitHub actually assigned.
data "github_user" "reviewer" {
  username = var.reviewer_username
}

# --- app-demo: dev -----------------------------------------------------
# No protection rules today (confirmed via
# `gh api repos/arek-devops-platform/app-demo/environments/dev`: empty
# protection_rules, deployment_branch_policy is null) - dev deploys
# automatically, matching "dev: automatic" from the current setup.
resource "github_repository_environment" "app_demo_dev" {
  repository  = github_repository.app_demo.name
  environment = "dev"

  lifecycle {
    prevent_destroy = true
  }
}

# --- app-demo: prod ------------------------------------------------------
# Matches `gh api repos/arek-devops-platform/app-demo/environments/prod`:
# can_admins_bypass=false, one required reviewer, custom branch policy
# restricted to "main".
resource "github_repository_environment" "app_demo_prod" {
  repository          = github_repository.app_demo.name
  environment         = "prod"
  can_admins_bypass   = false
  prevent_self_review = false

  reviewers {
    users = [data.github_user.reviewer.id]
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

# The actual "main"-only branch pattern is a separate resource - matches
# deployment policy id 58709259 from
# `gh api repos/arek-devops-platform/app-demo/environments/prod/deployment-branch-policies`.
resource "github_repository_environment_deployment_policy" "app_demo_prod_main" {
  repository     = github_repository.app_demo.name
  environment    = github_repository_environment.app_demo_prod.environment
  branch_pattern = "main"

  lifecycle {
    prevent_destroy = true
  }
}

# --- terraform-infra: infra-prod -----------------------------------------
# Matches
# `gh api repos/arek-devops-platform/terraform-infra/environments/infra-prod`:
# same shape as app-demo's prod above.
resource "github_repository_environment" "terraform_infra_infra_prod" {
  repository          = github_repository.terraform_infra.name
  environment         = "infra-prod"
  can_admins_bypass   = false
  prevent_self_review = false

  reviewers {
    users = [data.github_user.reviewer.id]
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Matches deployment policy id 58740422 from
# `gh api repos/arek-devops-platform/terraform-infra/environments/infra-prod/deployment-branch-policies`.
resource "github_repository_environment_deployment_policy" "terraform_infra_infra_prod_main" {
  repository     = github_repository.terraform_infra.name
  environment    = github_repository_environment.terraform_infra_infra_prod.environment
  branch_pattern = "main"

  lifecycle {
    prevent_destroy = true
  }
}
